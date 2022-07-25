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
      if (HistoryDealGetInteger(cCloseOrder.GetOrderTicket(),DEAL_REASON)==DEAL_REASON_SL) cCloseFlag|=CLOSE_BY_SL; \
      if (HistoryDealGetInteger(cCloseOrder.GetOrderTicket(),DEAL_REASON)==DEAL_REASON_TP) cCloseFlag|=CLOSE_BY_TP; \
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
      cDealComission=OrderCommission(); \
      string comment=OrderComment();\
      if (StringFind(comment,"[sl]")>=0) cCloseFlag|=CLOSE_BY_SL; \
      else if (StringFind(comment,"[tp]")>=0) cCloseFlag|=CLOSE_BY_TP; \
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

//#ifdef __MQL5__
//   #define SET _SET,MQL5_SET
//#else
//   #define SET _SET
//#endif

class CPosition:public CDeal
  {
protected:
   datetime          cCloseTime;
   double            cClosePrice;
   double            cProfit;
   double            cClosedProfit;
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
   ITral*            Tral() const            {return cTral;}
   datetime          CloseTime() const       {return cCloseTime;}
   ulong             Control();
   #ifdef MY_MQL_LIB_TRADE_LOG
      bool              Closing(string from);
      void              Close(double volume,string from);
   #else
      bool              Closing();
      void              Close(double volume);
   #endif
   bool              IsTralOn()              {return cTral!=NULL;}
   bool              IsClosed()              {return cClosePrice!=0.0;}
   bool              IsClosingProcess() const {return !IsFinish()&&bool(cFlag&(POSITION_MUST_CLOSE));}
   bool              IsChangeInProcess() const {return IsClosingProcess() #ifdef __MQL5__ ||!cActiveOrder.IsEmpty() #endif; }
   bool              IsChangeSL() const {return bool(cFlag&TRADE_CHANGE_SL);}
   bool              IsChangeTP() const {return bool(cFlag&TRADE_CHANGE_TP);}
   bool              IsChangeStop() const {return bool(cFlag&TRADE_CHANGE_STOP);}
   bool              IsChangeVolume() const {return bool(cFlag&TRADE_CHANGED_VOLUME);}
   bool              IsChanged() const {return bool(cFlag&TRADE_CHANGED);}
   void              SetTral(ITral *mTral)   {cTral=mTral.Init(cTradeConst,cOrderDirect);}
   void              CancelTral()            {if (cTral==NULL) return; delete cTral; cTral=NULL;}
   pos_type          GetPositionType() const {return _type;}
   ENUM_ORDER_TYPE   Type()  const                #ifdef __MQL5__
                                                {return IsOpen()?(ENUM_ORDER_TYPE)cPositionType:(ENUM_ORDER_TYPE)cOrderType;}
                                             #else
                                                {return (ENUM_ORDER_TYPE)cOrderType;}
                                             #endif
   order_type        CheckType();
   int               GetDirect()             {return _direct;}
   double            GetVolume()      const  {return #ifdef __MQL5__ !(cFlag&DEAL_FULL)?cOrderVolume: #endif _volume;}
   double            GetOpenPrice()   const       {return cDealPrice;}
   double            ClosePrice() const {return cClosePrice;}
   double            GetSL() const;
   double            GetTP() const;
   double            GetTotalProfit() const {return _comission+cPositionSwap+cProfit+cClosedProfit;}
   long_type         Ticket() const {return _ticket;}
   double            Comission() const {return _comission;}
   double            Swap() const {return cPositionSwap;}
   void              NewSL(int mSL);
   void              NewTP(int mTP);
   void              NewStops(double mSL,double mTP,double mPrice=0.0,bool mIsCancelIfError=true)  {NewSL(mSL,mPrice,mIsCancelIfError);
                                                                                                    NewTP(mTP,mPrice,mIsCancelIfError);}
   void              NewSL(double mSL,double mPrice=0.0,bool mIsCancelIfError=true);
   void              NewTP(double mTP,double mPrice=0.0,bool mIsCancelIfError=true);
   bool              SetBreakEven(int mBE);
   bool              IsSLClosed()  const  {return bool(cCloseFlag&CLOSE_BY_SL);}
   bool              IsTPClosed()  const {return bool(cCloseFlag&CLOSE_BY_TP);}
   #ifdef __MQL5__
      int            Direct() const {return IsOpen()?cPositionDirect:cOrderDirect;}
   #else
      int            Direct() const {return _type%2==0?1:-1;}
   #endif
protected:
   bool              SelectPosition()  {return #ifdef __MQL5__ cIsNetting?SelectNettingPosition():SelectHedgePosition();
                                               #else OrderSelect(_ticket,SELECT_BY_TICKET); #endif}
   void              PositionStopsControl();
   void              ModifyPosition(double mSL,double mTP);
   bool              CheckClosePosition();
   bool              CheckDealFull();
   bool           ChangePosition(double volume #ifdef MY_MQL_LIB_TRADE_LOG, string fromWhere #endif);
   #ifdef __MQL5__
   public:
                     CPosition(CTradeConst* tradeConst,ulong ident); //Position
                     CPosition(_tTicket ticket, CTradeConst* tradeConst); //Order
      bool           TradeTransaction(const MqlTradeTransaction& trans,
                                      const MqlTradeRequest& request,
                                      const MqlTradeResult& result);
   protected:
      bool           SelectNettingPosition();
      bool           SelectHedgePosition();
      bool           PositionSelectByIdent();
      void           CheckChangePosition();
      void           SetNewData();
      void           FindNewDeals();
      void           ActiveOrdersControl();
   #else
      public:
                     CPosition(CTradeConst* mTradeConst);
      private:
         bool        CheckPartialClose();
   #endif
  };
//------------------------------------------------------
CPosition::CPosition(SET):
   CDeal(SET_IN),cCloseTime(0),cClosePrice(0.0),cProfit(0.0),cClosedProfit(0.0),cPositionSwap(0.0)
   #ifdef __MQL5__
      ,cPositionTicket(0.0),cPositionVolume(0.0),cPositionPrice(0.0),cPositionSL(0.0),cPositionTP(0.0),cPositionLastUpdate(0),cSLPips(0),cTPPips(0),
      _comission(0.0)
   #endif
   {#ifdef __MQL5__
      cPositionDirect=mType%2==0?1:-1;
   #endif
   }
//------------------------------------------------------
ulong CPosition::Control(){
   cFlag&=~TRADE_CHANGED;
   #ifdef __MQL5__
      ActiveOrdersControl();
   #endif 
   ulong flag=DealControl();
   if (!flag||CheckClosePosition()||bool(flag&TRADE_FINISH)||!CheckDealFull()) return cFlag;
   if (bool(flag&POSITION_MUST_CLOSE)) Closing(#ifdef MY_MQL_LIB_TRADE_LOG __FUNCSIG__ #endif);
   else PositionStopsControl();
   return cFlag;}
//-----------------------------------------------------------------------
bool CPosition::Closing(
#ifdef MY_MQL_LIB_TRADE_LOG
   string from
#endif
   ){
   if (!cFlag                                   ||
       bool(cFlag&(ORDER_REMOVED|TRADE_ERROR))  ||
       !(cFlag&(ORDER_PENDING|ORDER_ACTIVATE))) CLOSE_TRUE
   #ifdef MY_MQL_LIB_TRADE_LOG
      if (!(cFlag&POSITION_MUST_CLOSE)){
         PrintFormat("Position %i close from %s",_ticket,from);
      }
   #endif
   cFlag|=POSITION_MUST_CLOSE;
   if (bool(cFlag&ORDER_PENDING)){
      if (!(cFlag&ORDER_ACTIVATE)) return Remove();
      else if (!(cFlag&DEAL_FULL)&&!(DealControl()&DEAL_FULL)) return false;}
   #ifdef __MQL5__
      if (CheckPointer(cCloseOrder))
         if (bool(cCloseOrder.DealControl()|DEAL_FULL)){
            if (!cCloseOrder.GetDealTime()){
               DELETE(cCloseOrder);
            }      
            else{
               CLOSE_VALUE_INIT
            }
         }
         else return false;
      if (!SelectPosition()) return CheckClosePosition();
      cCloseOrder=new CDeal(_symbol,ENUM_ORDER_TYPE(1-_type),_volume,0.0,0.0,0.0,0,0,0,NULL,cTradeConst,0,0,false);
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
void CPosition::Close(double volume #ifdef MY_MQL_LIB_TRADE_LOG ,string from #endif){
   if (!IsOpen()||CompareDouble(volume,_volume,_lotDigits)!=LESS){
      Closing(#ifdef MY_MQL_LIB_TRADE_LOG from #endif);
   }
   else{
      ChangePosition(-volume #ifdef MY_MQL_LIB_TRADE_LOG, from #endif);
   }
}
//----------------------------------------------------------------------
void CPosition::PositionStopsControl(void){
   if (!SelectPosition()) return;
   #ifdef __MQL5__
      double sl=PositionGetDouble(POSITION_SL);
      double tp=PositionGetDouble(POSITION_TP);
      cPositionSwap=PositionGetDouble(POSITION_SWAP);
      cProfit=PositionGetDouble(POSITION_PROFIT);
   #else
      double sl=OrderStopLoss();
      double tp=OrderTakeProfit();      
      cPositionSwap=OrderSwap();
      cProfit=OrderProfit();
   #endif
   double price=TradePrice(_symbol,-_direct);
   if (cTral!=NULL){
      double tralSL=cTral.GetSL(price,sl,_price);
      if (CompareDouble(tralSL,_sl,_digits)!=EQUALLY){
         cSLControl=_sl=tralSL;
         cFlag|=TRADE_SL_CHANGE_IN_PROCESS;
      }
   }
   if(CompareDouble(tp,cTPControl,_digits)==0)
      cFlag&=~TRADE_TP_CHANGE_IN_PROCESS;
   else if (!cIsFirstControl){
      if (!(cFlag&TRADE_TP_CHANGE_IN_PROCESS)){
         cFlag|=TRADE_CHANGE_TP;
         cTPControl=tp;
         _tp=tp;
      }
   }
   if(CompareDouble(sl,cSLControl,_digits)==0){
      cFlag&=~TRADE_SL_CHANGE_IN_PROCESS;
   }
   else if (!cIsFirstControl){
      if (!(cFlag&TRADE_SL_CHANGE_IN_PROCESS)){
         cFlag|=TRADE_CHANGE_SL;
         cSLControl=sl;
         _sl=sl;
      }
   }
   cIsFirstControl=false;
   bool isSLTPClose=false;
   if ((!sl||CompareDouble(sl,cSLControl,_digits)!=0)&&cSLControl&&ComparePrice(price,cSLControl,-_direct,_digits)>=0) {isSLTPClose=true; cCloseFlag|=CLOSE_BY_SL;}
   if ((!tp||CompareDouble(tp,cTPControl,_digits)!=0)&&cTPControl&&ComparePrice(price,cTPControl,_direct,_digits)>=0) {isSLTPClose=true; cCloseFlag|=CLOSE_BY_TP;}
   if (isSLTPClose) {Closing(#ifdef MY_MQL_LIB_TRADE_LOG __FUNCSIG__ #endif); return;}
   double modSL=IS_VIRTUAL_SL?sl:CheckPriceLevel(sl,price,_freezeLevel,_digits),
          modTP=IS_VIRTUAL_TP?tp:CheckPriceLevel(tp,price,_freezeLevel,_digits);
   if (!IS_VIRTUAL_SL&&CompareDouble(_sl,sl,_digits)!=0){
      if (!sl||modSL!=0.0) modSL=!_sl?_sl:CheckPriceLevel(_sl,price,_stopLevel,_digits);
      if (!modSL&&_sl>0.0) modSL=sl;}
   if (!IS_VIRTUAL_TP&&CompareDouble(_tp,tp,_digits)!=0){
      if (!tp||modTP!=0.0) modTP=!_tp?_tp:CheckPriceLevel(_tp,price,_stopLevel,_digits);
      if (!modTP&&_tp>0.0) modTP=tp;}
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
      double price=!_price?cOrderPrice:_price;
      bool res=OrderModify(_ticket,price,mSL,mTP,0);
//      if (!res) Print(_stopLevel," | ",Ask," | ",Bid," | ",_ticket," | ",price," | ",mSL," | ",mTP," | ",_sl," | ",_tp," | ",OrderStopLoss()," | ",OrderTakeProfit()," | ",OrderCloseTime());
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
double CPosition::GetSL(void) const {
   #ifdef __MQL5__
      if (_ticket) return _sl; 
   #endif
   return cOrderSL;}
//------------------------------------------------------------------------
double CPosition::GetTP(void) const {
   #ifdef __MQL5__
      if (_ticket) return _tp; 
   #endif
   return cOrderTP;}
//----------------------------------------------------------------------
void CPosition::NewSL(int mSL){
   if (mSL<0) return;
   cSLPips=mSL;
   if (_price){
      _sl=!mSL?0.0:_price-_direct*mSL*_point;
      cSLControl=_sl;
      cFlag|=TRADE_SL_CHANGE_IN_PROCESS;
   }
}
//---------------------------------------------------------------------
void CPosition::NewTP(int mTP){
   if (mTP<0) return;
   cTPPips=mTP;
   if (_price){
      _tp=!mTP?0.0:_price+_direct*mTP*_point;
      cTPControl=_tp;
      cFlag|=TRADE_TP_CHANGE_IN_PROCESS;
   }
}
//----------------------------------------------------------------------
bool CPosition::SetBreakEven(int mBE){
   if (!_price) return false;
   double sl=_price+_direct*mBE*_point;
   if (ComparePrice(sl,_direct>0?Bid(_symbol):Ask(_symbol),_direct,_digits)>=0) return false;
   _sl=sl;
   cSLControl=_sl;
   cFlag|=TRADE_SL_CHANGE_IN_PROCESS;
   return true;}
//----------------------------------------------------------------------
void CPosition::NewSL(double mSL,double mPrice=0.0,bool mIsCancelIfError=true){
   #ifdef __MQL5__
      if (IsOpen()) mPrice=!mPrice?TradePrice(_symbol,-_direct):mPrice; 
      else{
         COrder::NewSL(mSL);
         return;}
   #else
      mPrice=!IsOpen()?cOrderPrice:!mPrice?TradePrice(_symbol,-_direct):mPrice;
   #endif
   if ((!mIsCancelIfError #ifndef __MQL5__ &&_type>O_T_SELL #endif)||(!mSL&&_sl>0.0)||ComparePrice(mSL,mPrice,_direct,_digits)<0){
   _sl=NormalizePrice(mSL);
   cSLControl=_sl;
   cFlag|=TRADE_SL_CHANGE_IN_PROCESS;
   }
}
//----------------------------------------------------------------------
void CPosition::NewTP(double mTP,double mPrice=0.0,bool mIsCancelIfError=true){
   #ifdef __MQL5__
      if (IsOpen()) mPrice=!mPrice?TradePrice(_symbol,-_direct):mPrice; 
      else{
         COrder::NewTP(mTP);
         return;}
   #else
      mPrice=!IsOpen()?cOrderPrice:!mPrice?TradePrice(_symbol,-_direct):mPrice;
   #endif
   if ((!mIsCancelIfError #ifndef __MQL5__ &&_type>O_T_SELL #endif)||(!mTP&&_tp>0.0)||ComparePrice(mTP,mPrice,_direct,_digits)>0){
   _tp=NormalizePrice(mTP);
   cTPControl=_tp;
   cFlag|=TRADE_TP_CHANGE_IN_PROCESS;
   }
}
//---------------------------------------------------------------------------
bool CPosition::CheckClosePosition(void){
   #ifdef __MQL5__
      if (PositionSelectByTicket(_ticket)){
         double volume=PositionGetDouble(POSITION_VOLUME);
         if (CompareDouble(_volume,volume,_digits)!=EQUALLY){
            if (_volume!=0.0)
               cFlag|=TRADE_CHANGED_VOLUME;
            _volume=volume;
         }
         return false;
      }
      else{
         for (int i=PositionsTotal()-1;i>=0;--i){
            _tTicket ticket=PositionGetTicket(i);
            if (PositionGetInteger(POSITION_IDENTIFIER)==cIdent){
               if (PositionSelectByTicket(ticket)){
                  _ticket=ticket;
               if (_volume!=0.0)
                  cFlag|=TRADE_CHANGED_VOLUME;
               _volume=PositionGetDouble(POSITION_VOLUME);
               return false;
               }
            }
         }
      }
      if (!HistorySelectByPosition(cIdent)) return false;
      ulong ticket=0;
      for (int i=HistoryDealsTotal()-1;i>=0;--i,ticket=0){
         ticket=HistoryDealGetTicket(i);
         if (!ticket) continue;
         ENUM_DEAL_ENTRY deal=(ENUM_DEAL_ENTRY)HistoryDealGetInteger(ticket,DEAL_ENTRY);
         if (deal==DEAL_ENTRY_OUT||deal==DEAL_ENTRY_OUT_BY){
            DELETE(cCloseOrder);
            cCloseOrder=new CDeal(ticket,cTradeConst);
            cPositionSwap=cCloseOrder.GetDealSwap();
            CLOSE_VALUE_INIT}}
   #else
      if (OrderSelect(_ticket,SELECT_BY_TICKET)&&OrderCloseTime()){
         if(!CheckPartialClose())
            CLOSE_VALUE_INIT
         else
            cFlag|=TRADE_CHANGED_VOLUME;
      }
   #endif
   return false;}
//----------------------------------------------------------------------------
   bool CPosition::CheckDealFull(){
      if (_price) return true;
      if (!bool(cFlag&DEAL_FULL)) return false;
      _price=cDealPrice;
      _sl=cOrderSL?cOrderSL:!cSLPips?0.0:NormalizePrice(_price-_direct*cSLPips*_point);
      _tp=cOrderTP?cOrderTP:!cTPPips?0.0:NormalizePrice(_price+_direct*cTPPips*_point);
      cSLControl=_sl;
      cTPControl=_tp;
      #ifdef __MQL5__
         _ticket=cOrderTicket;
         _volume=cDealVolume;
         _comission=cDealComission;
         cPositionLastUpdate=cDealTime;
      #endif
      return true;}
//----------------------------------------------------------------------
#ifdef __MQL5__
      CPosition::CPosition(ulong ticket,CTradeConst *tradeConst):
         CDeal(ticket,tradeConst!=NULL?tradeConst:new CTradeConst(OrderGetString(ORDER_SYMBOL))){
         cIsDeleteableTradeConst=tradeConst==NULL;
         cCloseTime=0;
         cClosePrice=0.0;
         cPositionComission=cDealComission;
         cTral=NULL;
         cSLPips=0;
         cTPPips=0;
         cCloseOrder=NULL;
         if (PositionSelectByTicket(ticket)){
            cProfit=PositionGetDouble(POSITION_PROFIT);
            cPositionSwap=PositionGetDouble(POSITION_SWAP);
            cPositionTicket=PositionGetInteger(POSITION_TICKET);
            cPositionType=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
            cPositionVolume=PositionGetDouble(POSITION_VOLUME);
            cPositionPrice=PositionGetDouble(POSITION_PRICE_OPEN);
            cPositionLastUpdate=PositionGetInteger(POSITION_TIME_UPDATE);
            cPositionDirect=cPositionType%2==0?1:-1;
            cPositionSL=PositionGetDouble(POSITION_SL);
            cPositionTP=PositionGetDouble(POSITION_TP);
         }
         else{
            cProfit=0.0;
            cPositionSwap=0.0;
            cPositionTicket=0;
            cPositionVolume=0.0;
            cPositionPrice=0.0;
            cPositionLastUpdate=0;
            cPositionDirect=0;
            cPositionSL=0.0;
            cPositionTP=0.0;
         }
            cSLControl=cOrderSL;
            cTPControl=cOrderTP;
      }
//------------------------------------------------------------------------
   CPosition::CPosition(CTradeConst *tradeConst,ulong ident):
      CDeal(tradeConst!=NULL?tradeConst:new CTradeConst(PositionGetString(POSITION_SYMBOL)),ident){
         cIsDeleteableTradeConst=tradeConst==NULL;
         cCloseTime=0;
         cClosePrice=0.0;
         cPositionComission=cDealComission;
         cTral=NULL;
         cSLPips=0;
         cTPPips=0;
         cCloseOrder=NULL;
         if (PositionSelectByTicket(ident)){
            cProfit=PositionGetDouble(POSITION_PROFIT);
            cPositionSwap=PositionGetDouble(POSITION_SWAP);
            cPositionTicket=PositionGetInteger(POSITION_TICKET);
            cPositionType=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
            cPositionVolume=PositionGetDouble(POSITION_VOLUME);
            cPositionPrice=PositionGetDouble(POSITION_PRICE_OPEN);
            cPositionLastUpdate=PositionGetInteger(POSITION_TIME_UPDATE);
            cPositionDirect=cPositionType%2==0?1:-1;
            cPositionSL=PositionGetDouble(POSITION_SL);
            cPositionTP=PositionGetDouble(POSITION_TP);
      }
         else{
            cProfit=0.0;
            cPositionSwap=0.0;
            cPositionTicket=0;
            cPositionVolume=0.0;
            cPositionPrice=0.0;
            cPositionLastUpdate=0;
            cPositionDirect=0;
            cPositionSL=0.0;
            cPositionTP=0.0;
         }
            cSLControl=cPositionSL;
            cTPControl=cPositionTP;
}
//---------------------------------------------------------------------------
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
      if (!cPositionSL) cPositionSL=PositionGetDouble(POSITION_SL);
      if (!cPositionTP) cPositionTP=PositionGetDouble(POSITION_TP);
      cPositionLastUpdate=PositionGetInteger(POSITION_TIME_UPDATE_MSC);}
//----------------------------------------------------------------------------
   void CPosition::ActiveOrdersControl(void){
      if (cActiveOrder.IsEmpty()) return;
      for (CDeal* it=cActiveOrder.Begine();it!=NULL;)
         if (!(it.IS_ORDER_END)){
            _comission+=it.GetDealComission()+it.GetDealSwap();
            cClosedProfit+=it.DealProfit();
            bool isLast=cActiveOrder.IsLast();
            if(it.DealType()%2==Type()%2)
               cPositionVolume+=it.DealVolume();
            else
               cPositionVolume-=it.DealVolume();
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
         if (pos<0) cOrder.PushBack(new CDeal(dealTicket,cTradeConst));
         else if (dealTicket==cOrder[pos].GetDealTicket()) break;
         else cOrder.PushNext(new CDeal(dealTicket,cTradeConst));
         cClosedProfit+=HistoryDealGetDouble(dealTicket,DEAL_PROFIT);
         _comission+=HistoryDealGetDouble(dealTicket,DEAL_COMMISSION)+HistoryDealGetDouble(dealTicket,DEAL_SWAP);
      }
   }
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
//-------------------------------------------------------------------------------------------
   bool CPosition::ChangePosition(double volume #ifdef MY_MQL_LIB_TRADE_LOG, string fromWhere #endif){
      if (NormalizeDouble(volume,_lotDigits)==0.0)
         return true;
      if (NormalizeDouble(_volume+volume,_lotDigits)==0.0){
         Closing(#ifdef MY_MQL_LIB_TRADE_LOG fromWhere #endif);
         return true;
      }
      ENUM_ORDER_TYPE type=volume>0.0?(ENUM_ORDER_TYPE)_type:ENUM_ORDER_TYPE(1-_type);
      CDeal* deal=new CDeal(_symbol,type,MathAbs(volume),0.0,0.0,0.0,0,0,0,NULL,cTradeConst,0,0,false);
      if (!cIsNetting)
         deal.SetClosePositionTicket(_ticket);
      deal.DealControl();
      bool ret=!deal.IsError();
      if (ret)
         cActiveOrder.PushBack(deal);
      else
         delete deal;
      return ret;
   }
#else
   CPosition::CPosition(CTradeConst* mTradeConst):
      CDeal(mTradeConst),
      cCloseTime(OrderCloseTime()),
      cClosePrice(OrderClosePrice()),
      cProfit(OrderProfit()),
      cPositionSwap(OrderSwap()),
      cTral(NULL),
      cSLPips(0),
      cTPPips(0)
      {if (!cCloseTime) return;
      else cFlag|=ORDER_REMOVED;}
//-------------------------------------------------------------------------------------------
   bool CPosition::ChangePosition(double volume #ifdef MY_MQL_LIB_TRADE_LOG, string fromWhere #endif){
      if (NormalizeDouble(volume,_lotDigits)==0.0)
         return true;
      if (NormalizeDouble(_volume+volume,_lotDigits)==0.0){
         Closing(#ifdef MY_MQL_LIB_TRADE_LOG fromWhere #endif);
         return true;
      }
      if (!OrderSelect(_ticket,SELECT_BY_TICKET)) return false;
      if (OrderCloseTime()) CLOSE_VALUE_INIT
      if (OrderClose(OrderTicket(),MathAbs(volume),TradePrice(_symbol,-1),SHORT_MAX,clrAliceBlue)){
         CheckPartialClose();
         return true;
      }
      else
         return false;
   }
//----------------------------------------------------
   bool CPosition::CheckPartialClose(){
      string comment=OrderComment();
      int pos=StringFind(comment,"to #");
      if(pos<0)
         return false;
      int ticket=(int)StringToInteger(StringSubstr(comment,pos+StringLen("to #")));
      double closedProfit=OrderProfit();
      double closedSwap=OrderSwap();
      double closedComission=OrderCommission();
      if (!OrderSelect(ticket,SELECT_BY_TICKET))
         return false;
      _ticket=ticket;
      _volume=OrderLots();
      cClosedProfit+=closedProfit;
      CheckPartialClose();
      return OrderCloseTime()==0;
   }
#endif
//-------------------------------------------------------------------------------
bool CheckEndTrade(ulong fFlag){
   return !fFlag||bool(fFlag&(POSITION_CLOSED|TRADE_ERROR));}

//-----------------------------------------------------------------------
#undef _ticket
#undef CLOSE_VALUE_INIT
#undef CLOSE_TRUE
#undef IS_ORDER_END

#endif