#ifndef _C_POSITION_
#define _C_POSITION_

#include "..\Array\CList.mqh"
#include "Tral\ITral.mqh"
#include "CDeal.mqh"

#define CLOSE_TRUE         \
   {cFlag|=ORDER_REMOVED;  \
   return true;}
//-------------------------
#define IS_ORDER_END DealControl()&(DEAL_FULL|ORDER_REMOVED|TRADE_ERROR)

#ifdef __MQL5__
   #define CLOSE_VALUE_INIT                     \
      {cCloseTime=cCloseOrder.GetDealTime();    \
      cClosePrice=cCloseOrder.GetDealPrice();   \
      cPositionComission+=cCloseOrder.GetDealComission(); \
      if (HistoryOrderGetInteger(cCloseOrder.GetOrderTicket(),ORDER_REASON)==ORDER_REASON_SL) cCloseFlag|=CLOSE_BY_SL; \
      if (HistoryOrderGetInteger(cCloseOrder.GetOrderTicket(),ORDER_REASON)==ORDER_REASON_TP) cCloseFlag|=CLOSE_BY_TP; \
      CLOSE_TRUE}
   #define _ticket   cPositionTicket
   #define _price    cPositionPrice
   #define _sl       cPositionSL
   #define _tp       cPositionTP
   #define _type     cPositionType
   #define _volume   cPositionVolume
   #define _direct   cPositionDirect
   #define _comission cPositionComission       
#else
   #define CLOSE_VALUE_INIT            \
      {cCloseTime=OrderCloseTime();    \
      cClosePrice=OrderClosePrice();   \
      cPositionComission=OrderComission;       \
      CLOSE_TRUE}
   #define _ticket   cOrderTicket
   #define _price    cDealPrice
   #define _sl       cOrderSL
   #define _tp       cOrderTP
   #define _type     cOrderType
   #define _volume   cOrderVolume
   #define _direct   cOrderDirect
   #define _comission cDealComission    
#endif

class CPosition:public CDeal
  {
protected:
   datetime          cCloseTime;
   double            cClosePrice;
   double            cProfit;
   double            cPositionSwap;
   ITral*            cTral;
   int               cSLPips;
   int               cTPPips;
   #ifdef __MQL5__
      CList<CDeal>         cOrder;
      CList<CDeal>         cActiveOrder;
      CDeal*               cCloseOrder;
      ulong                cPositionTicket;
      ENUM_POSITION_TYPE   cPositionType;
      double               cPositionVolume;
      double               cPositionPrice;
      long                 cPositionLastUpdate;
   protected:
      int                  cPositionDirect;
      double               cPositionSL;
      double               cPositionTP;
      double               cPositionComission;
   #endif
public:
                     CPosition(SET);
                    ~CPosition() {if (CheckPointer(cTral)) delete cTral;
                                  #ifdef __MQL5__
                                    if (CheckPointer(cCloseOrder)) delete cCloseOrder;
                                  #endif}
   ulong             Control();
   bool              Closing();
   void              SetTral(ITral *mTral)   {cTral=mTral.Init(TRADE_CONST,cOrderDirect);}
   void              CancelTral()            {if (cTral==NULL) return; delete cTral; cTral=NULL;}
   order_type        CheckType();
   int               GetDirect()             {return _direct;}
   double            GetVolume()             {return #ifdef __MQL5__ !(cFlag&DEAL_FULL)?cOrderVolume: #endif _volume;}
   double            GetOpenPrice()          {return _price;}
   double            GetSL();
   double            GetTP();
   double            GetTotalProfit()  {return _comission+cPositionSwap+cProfit;}
   void              NewSL(int mSL);
   void              NewTP(int mTP);
   void              NewSL(double mSL,double mPrice=0.0,bool mIsCancelIfError=true);
   void              NewTP(double mTP,double mPrice=0.0,bool mIsCancelIfError=true);
   bool              SetBreakEven(int mBE);
   bool              IsSLClosed()   {return bool(cCloseFlag&CLOSE_BY_SL);}
   bool              IsTPClosed()   {return bool(cCloseFlag&CLOSE_BY_TP);}
protected:
   bool              SelectPosition()  {return #ifdef __MQL5__ cIsNetting?SelectNettingPosition():SelectHedgePosition();
                                               #else OrderSelect(_ticket,SELECT_BY_TICKET); #endif}
   void              PositionStopsControl();
   void              ModifyPosition(double mSL,double mTP);
   bool              CheckClosePosition();
   #ifdef __MQL5__
   public:
      bool           TradeTransaction(const MqlTradeTransaction& trans,
                                      const MqlTradeRequest& request,
                                      const MqlTradeResult& result);
   protected:
      bool           SelectNettingPosition();
      bool           SelectHedgePosition();
      bool           PositionSelectByIdent();
      bool           CheckDealFull();
      void           CheckChangePosition();
      void           SetNewData();
      void           FindNewDeals();
      void           ActiveOrdersControl();
   #endif
  };
//------------------------------------------------------
CPosition::CPosition(SET):
   CDeal(SET_IN),cCloseTime(0),cClosePrice(0.0),cProfit(0.0),cPositionSwap(0.0)
   #ifdef __MQL5__
      ,cPositionTicket(0.0),cPositionVolume(0.0),cPositionPrice(0.0),cPositionSL(0.0),cPositionTP(0.0),cPositionLastUpdate(0),cSLPips(0),cTPPips(0),
      _comission(0.0)
   #endif
   {#ifdef __MQL5__
      cPositionDirect=mType%2==0?1:-1;
   #endif}
//------------------------------------------------------
ulong CPosition::Control(){
   #ifdef __MQL5__
      ActiveOrdersControl();
   #endif 
   ulong flag=DealControl();
   if (!flag||CheckClosePosition()||bool(flag&TRADE_FINISH)#ifdef __MQL5__ ||!CheckDealFull() #endif) return cFlag;
   if (bool(flag&POSITION_MUST_CLOSE)) Closing();
   else PositionStopsControl();
   return cFlag;}
//-----------------------------------------------------------------------
bool CPosition::Closing(){
   if (!cFlag                                   ||
       bool(cFlag&(ORDER_REMOVED|TRADE_ERROR))  ||
       !(cFlag&(ORDER_PENDING|ORDER_ACTIVATE))) CLOSE_TRUE
   cFlag|=POSITION_MUST_CLOSE;
   if (bool(cFlag&ORDER_PENDING)){
      if (!(cFlag&ORDER_ACTIVATE)) return Remove();
      else if (!(cFlag&DEAL_FULL)&&!(DealControl()&DEAL_FULL)) return false;}
   #ifdef __MQL5__
      if (CheckPointer(cCloseOrder))
         if (bool(cCloseOrder.DealControl()|DEAL_FULL)) CLOSE_VALUE_INIT
         else return false;
      if (!SelectPosition()) return CheckClosePosition();
      cCloseOrder=new CDeal(_symbol,ENUM_ORDER_TYPE(1-_type),_volume,0.0,0.0,0.0,0,0,0,NULL,TRADE_CONST,0,0,false);
      cCloseOrder.SetClosePositionTicket(_ticket);
      if (bool(cCloseOrder.DealControl()&DEAL_FULL)) CLOSE_VALUE_INIT
   #else
      if (!OrderSelect(_ticket,SELECT_BY_TICKET)) return false;
      if (OrderCloseTime()) CLOSE_VALUE_INIT
      if (OrderClose(OrderTicket(),OrderLots(),TradePrice(_symbol,-1),SHORT_MAX,clrAliceBlue)   &&
          OrderSelect(_ticket,SELECT_BY_TICKET)) CLOSE_VALUE_INIT
   #endif
   else return false;}
//----------------------------------------------------------------------
void CPosition::PositionStopsControl(void){
   if (!SelectPosition()) return;
   #ifdef __MQL5__
      double sl=PositionGetDouble(POSITION_SL);
      double tp=PositionGetDouble(POSITION_TP);
      cPositionSwap=PositionGetDouble(POSITION_PROFIT);
      cProfit=PositionGetDouble(POSITION_SWAP);
   #else
      double sl=OrderStopLoss();
      double tp=OrderTakeProfit();
      cPositionSwap=OrderSwap();
      cProfit=OrderProfit();
   #endif
   double price=TradePrice(_symbol,-_direct);
   if (cTral!=NULL) _sl=cTral.GetSL(price,_sl,_price);
   bool isSLTPClose=false;
   if ((!sl||CompareDouble(sl,_sl,_digits)!=0)&&_sl&&ComparePrice(price,_sl,-_direct,_digits)>=0) {isSLTPClose=true; cCloseFlag|=CLOSE_BY_SL;}
   if ((!tp||CompareDouble(tp,_tp,_digits)!=0)&&_tp&&ComparePrice(price,_tp,_direct,_digits)>=0) {isSLTPClose=true; cCloseFlag|=CLOSE_BY_TP;}
   if (isSLTPClose) {Closing(); return;}
   double modSL=IS_VIRTUAL_SL?sl:CheckPriceLevel(sl,price,_freezeLevel,_digits),
          modTP=IS_VIRTUAL_TP?tp:CheckPriceLevel(tp,price,_freezeLevel,_digits);
   if (!IS_VIRTUAL_SL&&CompareDouble(_sl,sl,_digits)!=0){
      if (!sl||modSL!=0.0) modSL=CheckPriceLevel(_sl,price,_stopLevel,_digits);
      if (!modSL) modSL=sl;}
   if (!IS_VIRTUAL_TP&&CompareDouble(_tp,tp,_digits)!=0){
      if (!tp||modTP!=0.0) modTP=CheckPriceLevel(_tp,price,_stopLevel,_digits);
      if (!modTP) modTP=tp;}
   if (modSL==sl&&modTP==tp) return;
   else ModifyPosition(modSL,modTP);}
//----------------------------------------------------------------------
void CPosition::ModifyPosition(double mSL,double mTP){
   #ifdef __MQL5__
      ZeroSend();
      cRequest.action=TRADE_ACTION_SLTP;
      cRequest.symbol=_symbol;
      cRequest.position=_ticket;
      cRequest.sl=mSL;
      cRequest.tp=mTP;
      bool res=OrderSend(cRequest,cResult);
   #else
      bool res=OrderModify(_ticket,_price,mSL,mTP,0);
   #endif}
//----------------------------------------------------------------------
order_type CPosition::CheckType(void){
   #ifdef __MQL5__
      if (!cOrderTicket||OrderSelect(cOrderTicket)||!HistoryOrderSelect(cOrderTicket)) return cOrderType;
      ENUM_ORDER_STATE state=(ENUM_ORDER_STATE)HistoryOrderGetInteger(cOrderType,ORDER_STATE);
      if (state==ORDER_STATE_FILLED||state==ORDER_STATE_PARTIAL) return order_type(cOrderType%2);
      else return cOrderType;
   #else
      return OrderSelect(_ticket,SELECT_BY_TICKET)?OrderType():-1;
   #endif}
//------------------------------------------------------------------------
double CPosition::GetSL(void){
   #ifdef __MQL5__
      if (_ticket) return _sl; 
   #endif
   return cOrderSL;}
//------------------------------------------------------------------------
double CPosition::GetTP(void){
   #ifdef __MQL5__
      if (_ticket) return _tp; 
   #endif
   return cOrderTP;}
//----------------------------------------------------------------------
void CPosition::NewSL(int mSL){
   if (mSL<0) return;
   cSLPips=mSL;
   if (_price) _sl=_price-_direct*mSL*_point;}
//---------------------------------------------------------------------
void CPosition::NewTP(int mTP){
   if (mTP<0) return;
   cTPPips=mTP;
   if (_price) _tp=_price+_direct*mTP*_point;}
//----------------------------------------------------------------------
bool CPosition::SetBreakEven(int mBE){
   if (!_price) return false;
   double sl=_price+_direct*mBE*_point;
   if (ComparePrice(sl,_direct>0?BID:ASK,_direct,_digits)>=0) return false;
   _sl=sl;
   return true;}
//----------------------------------------------------------------------
void CPosition::NewSL(double mSL,double mPrice=0.0,bool mIsCancelIfError=true){
   #ifdef __MQL5__
      if (_ticket) mPrice=!mPrice?TradePrice(_symbol,-_direct):mPrice; 
      else{
         COrder::NewSL(mSL);
         return;}
   #else
      mPrice=_type>O_T_SELL?cOrderPrice:!mPrice?TradePrice(_symbol,-_direct):mPrice;
   #endif
   if ((!mIsCancelIfError #ifndef __MQL5__ &&_type>O_T_SELL #endif)||ComparePrice(mSL,mPrice,_direct,_digits)<0) _sl=NormalizePrice(mSL);}
//----------------------------------------------------------------------
void CPosition::NewTP(double mTP,double mPrice=0.0,bool mIsCancelIfError=true){
   #ifdef __MQL5__
      if (_ticket) mPrice=!mPrice?TradePrice(_symbol,-_direct):mPrice; 
      else{
         COrder::NewTP(mTP);
         return;}
   #else
      mPrice=_type>O_T_SELL?cOrderPrice:!mPrice?TradePrice(_symbol,-_direct):mPrice;
   #endif
   if ((!mIsCancelIfError #ifndef __MQL5__ &&_type>O_T_SELL #endif)||ComparePrice(mTP,mPrice,_direct,_digits)>0) _tp=NormalizePrice(mTP);}
//---------------------------------------------------------------------------
bool CPosition::CheckClosePosition(void){
   #ifdef __MQL5__
      if (!HistorySelectByPosition(cIdent)) return false;
      ulong ticket=0;
      for (int i=HistoryOrdersTotal()-1;i>=0;--i,ticket=0){
         ticket=HistoryDealGetTicket(i);
         if (!ticket) continue;
         ENUM_DEAL_ENTRY deal=(ENUM_DEAL_ENTRY)HistoryDealGetInteger(ticket,DEAL_ENTRY);
         if (deal==DEAL_ENTRY_OUT||deal==DEAL_ENTRY_OUT_BY){
            cCloseOrder=new CDeal(ticket,TRADE_CONST);
            cPositionSwap=cCloseOrder.GetDealSwap();
            CLOSE_VALUE_INIT}}
   #else
      if (OrderCloseTime()) CLOSE_VALUE_INIT
   #endif
   return false;}
//----------------------------------------------------------------------
#ifdef __MQL5__
   bool CPosition::SelectNettingPosition(void){
      if (!PositionSelect(_symbol)) return false;
      CheckChangePosition();
      return true;}
//-------------------------------------------------------------------------
   bool CPosition::SelectHedgePosition(void){
      if (!PositionSelectByTicket(_ticket)&&!PositionSelectByIdent()) return false;
      CheckChangePosition();
      return true;}
//--------------------------------------------------------------------------
   bool CPosition::PositionSelectByIdent(void){
      for (int i=PositionsTotal()-1;i>=0;--i)
         if (PositionGetTicket(i)&&PositionGetInteger(POSITION_IDENTIFIER)==cIdent) return true;
      return false;}
//----------------------------------------------------------------------------
   bool CPosition::CheckDealFull(){
      if (_price) return true;
      if (!bool(cFlag&DEAL_FULL)) return false;
      _ticket=cOrderTicket;
      _price=cDealPrice;
      _volume=cDealVolume;
      _sl=cOrderSL?cOrderSL:NormalizePrice(_price-_direct*cSLPips*_point);
      _tp=cOrderTP?cOrderTP:NormalizePrice(_price+_direct*cTPPips*_point);
      _comission=cDealComission;
      cPositionLastUpdate=cDealTime;
      return true;}
//----------------------------------------------------------------------------
   void CPosition::CheckChangePosition(void){
      if (PositionGetInteger(POSITION_TIME_UPDATE_MSC)==cPositionLastUpdate) return;
      SetNewData();
      FindNewDeals();}
//----------------------------------------------------------------------------
   void CPosition::SetNewData(void){
      cPositionTicket=PositionGetInteger(POSITION_TICKET);
      cPositionType=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      cPositionDirect=cPositionType%2==0?1:-1;
      cPositionVolume=PositionGetDouble(POSITION_VOLUME);
      cPositionPrice=PositionGetDouble(POSITION_PRICE_OPEN);
      cPositionSL=PositionGetDouble(POSITION_SL);
      cPositionTP=PositionGetDouble(POSITION_TP);
      cPositionLastUpdate=PositionGetInteger(POSITION_TIME_UPDATE_MSC);}
//----------------------------------------------------------------------------
   void CPosition::ActiveOrdersControl(void){
      if (cActiveOrder.IsEmpty()) return;
      for (CDeal* it=cActiveOrder.Begine();it!=NULL;)
         if (!(it.IS_ORDER_END)){
            _comission+=it.GetDealComission();
            bool isLast=cActiveOrder.IsLast();
            cOrder.PushBack(cActiveOrder.Move());
            it=isLast?NULL:cActiveOrder.It();}
         else it=cActiveOrder.Next();}
//      while (cActiveOrder.Begine()!=NULL&&bool(cActiveOrder.It().IS_ORDER_END)) cOrder.PushBack(cActiveOrder.Move());
//      while (!cActiveOrder.IsLast())
//         if (bool(cActiveOrder.Next().IS_ORDER_END)){
//            bool isLast;
//            do{
//               isLast=cActiveOrder.IsLast();
//               cOrder.PushBack(cActiveOrder.Move());}
//            while(!isLast&&bool(cActiveOrder.It().IS_ORDER_END));}}
//----------------------------------------------------------------------------
   void CPosition::FindNewDeals(void){
      if (!HistorySelectByPosition(cIdent)) return;
      int pos=cOrder.GetSize()-1;
      for (int i=HistoryDealsTotal()-1;i>=0;--i){
         ulong dealTicket=HistoryDealGetTicket(i);
         if (!dealTicket) continue;
         if (dealTicket==cDealTicket) break;
         if (pos<0) cOrder.PushBack(new CDeal(dealTicket,TRADE_CONST));
         else if (dealTicket==cOrder[pos].GetDealTicket()) break;
         else cOrder.PushNext(new CDeal(dealTicket,TRADE_CONST));}}
//----------------------------------------------------------------------------
   bool CPosition::TradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &request,const MqlTradeResult &result){
      if (trans.type!=TRADE_TRANSACTION_DEAL_ADD) return false;
      if (!(cFlag&DEAL_FULL)&&trans.order==cOrderTicket){
         CDeal::TradeTransaction(trans,request,result);
         cPositionTicket=trans.position;
         _comission=cDealComission;
         return true;}
      for (CDeal* it=cActiveOrder.Begine();it!=NULL;it=cActiveOrder.Next())
         if (it.TradeTransaction(trans,request,result)) return true;
      return cCloseOrder!=NULL&&cCloseOrder.TradeTransaction(trans,request,result);}
      
#endif

bool CheckEndTrade(ulong fFlag){
   return !fFlag||bool(fFlag&(POSITION_CLOSED|TRADE_ERROR));}

//-----------------------------------------------------------------------
#undef _ticket
#undef CLOSE_VALUE_INIT
#undef CLOSE_TRUE
#undef IS_ORDER_END

#endif