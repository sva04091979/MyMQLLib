#ifndef _ORDER_
#define _ORDER_

#include "CBaseTrade.mqh"
#include "..\GraficObjects\CHLine.mqh"

#define ACTIVATE                       \
   {cFlag|=ORDER_ACTIVATE;              \
   cOrderStatus=ORDER_STATUS_ACTIVATE;}
//----------------------------------------------------------   
#define REMOVED                        \
   {cFlag|=ORDER_REMOVED;               \
   cOrderStatus=ORDER_STATUS_REMOVED;}
//--------------------------------------------------------------
#ifdef __MQL5__
   #define MQL5_SET                                         \
      ENUM_ORDER_TYPE_TIME mTypeTime=ORDER_TIME_GTC,\
      ENUM_FILLING_MODE mFilling=FILLING_AUTO,  \
      bool mIsMain=true
   #define MQL5_SET_IN  \
      mTypeTime,       \
      mFilling
#endif
//------------------------------------------------------------------
#define _SET                      \
   string mSymbol,               \
   order_type mType,             \
   double mVolume,               \
   double mPrice,                \
   double mSL,                   \
   double mTP,                   \
   long_type mMagic=0,           \
   long_type mDeviation=0,       \
   datetime mExpiration=0,       \
   string mComment=NULL,         \
   CTradeConst* mTradeConst=NULL,\
   bool mIsOpenIfHit=false
   

#ifdef __MQL5__
   #define SET _SET,MQL5_SET
#else
   #define SET _SET
#endif
//------------------------------------------------------------------------------------
#ifdef __MQL4__
   #define _SET_DEVIATION !mDeviation?INT_MAX:mDeviation
#else
   #define _SET_DEVIATION mDeviation
#endif

#define _SET_IN \
   mSymbol,    \
   mType,      \
   mVolume,    \
   mPrice,     \
   mSL,        \
   mTP,        \
   mMagic,     \
   _SET_DEVIATION, \
   mExpiration,\
   mComment,   \
   mTradeConst,\
   mIsOpenIfHit 

#ifdef __MQL5__
   #define SET_IN _SET_IN,MQL5_SET_IN
#else
   #define SET_IN _SET_IN
#endif
//-------------------------------------------------------------------------------------   
enum ENUM_ORDER_STATUS
  {
   ORDER_STATUS_ERROR,
   ORDER_STATUS_NOT_INIT,
   ORDER_STATUS_INIT,
   ORDER_STATUS_MUST_OPEN,
   ORDER_STATUS_PENDING,
   ORDER_STATUS_ACTIVATE,
   ORDER_STATUS_REMOVED
  };

class COrder:public CBaseTrade
{
protected:
   CHLine*                       cLineOrder;
   ENUM_ORDER_STATUS             cOrderStatus;
   long_type                     cOrderTicket;
   order_type                    cOrderType;
   double                        cOrderVolume;
   double                        cOrderPrice;
   double                        cOrderSL;
   double                        cOrderTP;
   datetime                      cExpiration;
   int                           cOrderDirect;
   long_type                     cDeviation;
   long_type                     cOrderMagic;
   string                        cOrderComment;
   datetime                      cOrderTime;
   #ifdef __MQL5__
      ENUM_ORDER_TYPE_TIME       cTypeTime;
      ENUM_ORDER_TYPE_FILLING    cFilling;
      long_type                  cClosePositionTicket;
   #endif
public:
   string            Comment() const {return cOrderComment;}
   long_type         Magic() const {return cOrderMagic;}
   int               GetOrderDirect()  {return cOrderDirect;}
   long_type         GetOrderTicket() const {return cOrderTicket;}
   order_type        GetOrderType()    {return cOrderType;}
   double            GetOrderPrice()  const  {return cOrderPrice;}
   datetime          OrderTime() const {return cOrderTime;}
   datetime          ExpirationTime() const {return cExpiration;}
   bool              Pending();
   bool              Remove();
   bool              IsActivate() const  {return bool(cFlag&ORDER_ACTIVATE);}
   bool              IsPending() const {return bool(cFlag&ORDER_PENDING);}
   bool              IsChangeOrderPrice() const {return bool(cFlag&TRADE_OPEN_PRICE_CHANGED);}
   void              Modify(double mPrice,double mSL=EMPTY_VALUE,double mTP=EMPTY_VALUE);
protected:
                     COrder(SET);
                    ~COrder() {delete cLineOrder;}
   ulong             OrderControl();
   bool              CheckOrderPrice(double mPrice,bool mIsOpenIfHit);
   bool              CheckOrderTime()  {return !cExpiration||TimeCurrent()<cExpiration;}
   bool              Deal();
private:
   bool              CheckOrderOpenPrice();
   void              OrderActivateControl();
   void              Modify();
   bool              CheckDeviation(double mPrice) {return !cDeviation||cOrderType>O_T_SELL_STOP||cOrderType==O_T_BUY_LIMIT||cOrderType==O_T_SELL_LIMIT||MathAbs(mPrice-cOrderPrice)<=cDeviation*_point;}
   void              CheckVirtualOrderLine();
   void              CheckStops();
#ifdef __MQL5__
   public:
      void              SetClosePositionTicket(long_type mTicket)    {cClosePositionTicket=mTicket;}
   private:
      ENUM_ORDER_TYPE_FILLING GetFilling(ENUM_FILLING_MODE mFilling);
   protected:
                              COrder(ulong mTicket,CTradeConst* mTradeConst,string symbol);
                              COrder(CTradeConst* mTradeConst,ulong mTicket,string symbol);
      virtual void            NewSL(double mSL) {if (ComparePrice(mSL,cOrderPrice,cOrderDirect,_digits)<0) cOrderSL=NormalizePrice(mSL); cFlag&=~ORDER_MODIFY; Modify();}
      virtual void            NewTP(double mTP) {if (ComparePrice(mTP,cOrderPrice,cOrderDirect,_digits)>0) cOrderTP=NormalizePrice(mTP); cFlag&=~ORDER_MODIFY; Modify();}
#else
   protected:
                     COrder(CTradeConst* mTradeConst);
#endif
};
//--------------------------------------------------------------------
COrder::COrder(SET):
   CBaseTrade(mSymbol,mTradeConst),
   cLineOrder(NULL),
   cOrderTicket(#ifdef __MQL5__
                   0
                #else
                   -1
                #endif),
   cOrderType(mType),
   cOrderMagic(mMagic),
   cOrderComment(mComment),
   cOrderDirect(mType%2==0?1:-1),
   cDeviation(#ifdef __MQL5__
                 mDeviation<0?0:mDeviation
              #else
                 mDeviation<0?SHORT_MAX:mDeviation
              #endif),
   cExpiration(mExpiration),
   cOrderTime(0)
   #ifdef __MQL5__
      ,cTypeTime(mTypeTime),
      cClosePositionTicket(0)
   #endif
{
   if(!IsError()){
      cOrderVolume=NormalizeVolume(mVolume);
      cOrderPrice=NormalizePrice(mPrice);
      cOrderSL=NormalizePrice(mSL);
      cOrderTP=NormalizePrice(mTP);
      #ifdef __MQL5__
         cFilling=GetFilling(mFilling);
      #endif
      cFlag|=/*CheckOrderPrice(cOrderPrice,mIsOpenIfHit)&&*/CheckOrderTime()?ORDER_INIT:TRADE_ERROR;
   }
   if (bool(cFlag&ORDER_INIT)) cOrderStatus=ORDER_STATUS_INIT; else cOrderStatus=ORDER_STATUS_ERROR;}
//-------------------------------------------------------------------------------
bool COrder::CheckOrderPrice(double mPrice,bool mIsOpenIfHit){
   if (!mPrice) mPrice=TradePrice(_symbol,cOrderDirect);
   bool checkSLTP=(!cOrderSL||cOrderDirect*(mPrice-cOrderSL)>=_tickSize)&&
                  (!cOrderTP||cOrderDirect*(cOrderTP-mPrice)>=_tickSize),
        checkPrice=mIsOpenIfHit||CheckOrderOpenPrice();
   if (!checkSLTP) cCloseFlag|=WRONG_PENDING_PRICE_SLTP;
   if (!checkPrice) cCloseFlag|=WRONG_PENDING_PRICE_CUR_PRICE;
   return checkSLTP&&checkPrice;}
//-------------------------------------------------------------------------------
#ifdef __MQL5__
   ENUM_ORDER_TYPE_FILLING COrder::GetFilling(ENUM_FILLING_MODE mFilling){
      if (!_fillingMode) return ORDER_FILLING_RETURN;
      switch(_executionMode){
         default:
            return mFilling==FILLING_AUTO||mFilling==FILLING_FOK?!(_fillingMode&SYMBOL_FILLING_FOK)?ORDER_FILLING_IOC:ORDER_FILLING_FOK:
                   mFilling==FILLING_IOC||mFilling==FILLING_RETURN?!(_fillingMode&SYMBOL_FILLING_IOC)?ORDER_FILLING_FOK:ORDER_FILLING_IOC:
                   !(_fillingMode&SYMBOL_FILLING_IOC)?ORDER_FILLING_RETURN:ORDER_FILLING_IOC;
         case SYMBOL_TRADE_EXECUTION_EXCHANGE:
            return mFilling==FILLING_AUTO||mFilling==FILLING_RETURN?ORDER_FILLING_RETURN:
                   mFilling==FILLING_FOK?!(_fillingMode&SYMBOL_FILLING_FOK)?ORDER_FILLING_RETURN:ORDER_FILLING_FOK:
                   !(_fillingMode&SYMBOL_FILLING_IOC)?ORDER_FILLING_RETURN:ORDER_FILLING_IOC;}}
#endif
//-------------------------------------------------------------------------------
ulong COrder::OrderControl(void){
   if (bool(cFlag&(ORDER_MODIFY))&&cFlag!=0&&!(cFlag&(ORDER_ACTIVATE))&&cOrderStatus!=ORDER_STATUS_MUST_OPEN) Modify();
   switch(cOrderStatus){
      case ORDER_STATUS_ERROR:       break;
      case ORDER_STATUS_INIT:        if (!Pending())  break;
      case ORDER_STATUS_MUST_OPEN:   if (!Deal())     break;
      case ORDER_STATUS_PENDING:     OrderActivateControl();}
   return cFlag;}
//--------------------------------------------------------------------------------
bool COrder::CheckOrderOpenPrice(void){
   if (cOrderType==O_T_BUY||cOrderType==O_T_SELL) return true;
   #ifdef __MQL5__
      if (_marginMode==ACCOUNT_MARGIN_MODE_EXCHANGE   &&
          cOrderType!=O_T_BUY_LIMIT                   &&
          cOrderType!=O_T_SELL_LIMIT)                 return true;
   #endif
   int k=cOrderType==O_T_BUY_LIMIT||cOrderType==O_T_SELL_LIMIT?-cOrderDirect:cOrderDirect;
   return ComparePrice(TradePrice(_symbol,k),cOrderPrice,k,_digits)<0;}
//--------------------------------------------------------------------------------
bool COrder::Pending(){
   if (cOrderType<2) return Deal();
   double price=TradePrice(_symbol,cOrderDirect);
   if (!price) return false;
   int k=cOrderType==O_T_BUY_LIMIT||cOrderType==O_T_SELL_LIMIT?-cOrderDirect:cOrderDirect;
   if (ComparePrice(price,cOrderPrice,k,_digits)>=0) return Deal();
   if (IS_VIRTUAL_PENDING) {CheckVirtualOrderLine(); return false;}
   if (!CheckPriceLevel(price,cOrderPrice,_stopLevel,_digits)) return false;
   #ifdef __MQL5__
      ZeroSend();
      cRequest.action=TRADE_ACTION_PENDING;
      cRequest.symbol=_symbol;
      cRequest.volume=cOrderVolume;
      cRequest.price=cOrderPrice;
      cRequest.sl=IS_VIRTUAL_SL?0.0:CheckPriceLevel(cOrderSL,cOrderPrice,_stopLevel,_digits);
      cRequest.tp=IS_VIRTUAL_TP?0.0:CheckPriceLevel(cOrderTP,cOrderPrice,_stopLevel,_digits);
      cRequest.type=cOrderType;
      cRequest.expiration=cExpiration;
      cRequest.type_filling=cFilling;
      cRequest.type_time=cTypeTime;
      cRequest.magic=cOrderMagic;
      cRequest.comment=cOrderComment;
      if (!OrderSend(cRequest,cResult)){
         if (IsFatalError(cResult.retcode)){
   #else
      if (!OrderSelect(OrderSend(_symbol,
                                 cOrderType,
                                 cOrderVolume,
                                 cOrderPrice,
                                 cDeviation,
                                 IS_VIRTUAL_SL?0.0:CheckPriceLevel(cOrderSL,cOrderPrice,_stopLevel,_digits),
                                 IS_VIRTUAL_TP?0.0:CheckPriceLevel(cOrderTP,cOrderPrice,_stopLevel,_digits),
                                 cOrderComment,
                                 cOrderMagic,
                                 cExpiration,
                                 cOrderDirect>0?clrGreen:clrRed),SELECT_BY_TICKET)){
         if (IsFatalError(_LastError)){
   #endif 
            cFlag|=TRADE_ERROR;
            cOrderStatus=ORDER_STATUS_ERROR;
            Print("Order pending fatal error N",#ifdef __MQL5__
                                                   cResult.retcode
                                                #else
                                                   _LastError
                                                #endif);}
         return false;}
      else{
      #ifdef __MQL5__
         cOrderTicket=cResult.order;
         cOrderTime=OrderSelect(cOrderTicket)?(datetime)OrderGetInteger(ORDER_TIME_SETUP):TimeCurrent();
      #else
         cOrderTicket=OrderTicket();
         cOrderTime=OrderOpenTime();
      #endif
      cIdent=cOrderTicket;
      cFlag|=ORDER_PENDING;
      cOrderStatus=ORDER_STATUS_PENDING;
      cSLControl=cOrderSL;
      cTPControl=cOrderTP;
      return true;}}
//------------------------------------------------------------------------
bool COrder::Remove(void){
   if (cOrderStatus<ORDER_STATUS_PENDING){cFlag|=ORDER_REMOVED;return true;}
   OrderActivateControl();
   if (bool(cFlag&ORDER_ACTIVATE)) return false;
   if (bool(cFlag&ORDER_REMOVED)) return true;
   #ifdef __MQL5__
      ZeroSend();
      cRequest.action=TRADE_ACTION_REMOVE;
      cRequest.order=cOrderTicket;
      if (OrderSend(cRequest,cResult)&&cResult.retcode==10009) cFlag|=ORDER_REMOVED;
   #else
      if (OrderDelete(cOrderTicket)) cFlag|=ORDER_REMOVED;
   #endif
   return bool(cFlag&ORDER_REMOVED);}
//------------------------------------------------------------------------
#ifdef __MQL5__
   #define CHECK_STOPS                                                        \
      cRequest.sl=CheckPriceLevel(cOrderSL,cRequest.price,_stopLevel,_digits);\
      cRequest.tp=CheckPriceLevel(cOrderTP,cRequest.price,_stopLevel,_digits) 
#else
   #define CHECK_STOPS                                               \
      double sl=CheckPriceLevel(cOrderSL,price,_stopLevel,_digits);  \
      double tp=CheckPriceLevel(cOrderTP,price,_stopLevel,_digits) 
#endif

//------------------------------------------------------------------------------------------------------------
bool COrder::Deal(void){
   if (cOrderStatus>ORDER_STATUS_MUST_OPEN) return true;
   DELETE(cLineOrder);
      double price=_executionMode>SYMBOL_TRADE_EXECUTION_INSTANT?0.0:cOrderType==O_T_BUY?Ask(_symbol):Bid(_symbol);
   if (IS_VIRTUAL_PENDING&&!CheckDeviation(price)){
      cFlag|=TRADE_ERROR;
      cCloseFlag|=CANCEL_BY_DEVIATION;
      cOrderStatus=ORDER_STATUS_ERROR;
      Print("Проскальзывание слишком высоко");
      return false;}
   cOrderStatus=ORDER_STATUS_MUST_OPEN;
   cOrderType%=2;
   #ifdef __MQL5__
      ZeroSend();
      cRequest.action=TRADE_ACTION_DEAL;
      cRequest.symbol=_symbol;
      cRequest.position=cClosePositionTicket;
      cRequest.volume=cOrderVolume;
      cRequest.type=cOrderType;
      cRequest.type_filling=cFilling;
      cRequest.magic=cOrderMagic;
      cRequest.comment=cOrderComment;
      if (_executionMode==SYMBOL_TRADE_EXECUTION_REQUEST||_executionMode==SYMBOL_TRADE_EXECUTION_INSTANT){
         cRequest.price=price;
         cRequest.deviation=IS_VIRTUAL_PENDING?0:cDeviation;
        CHECK_STOPS;}
      while (!OrderSend(cRequest,cResult)&&cResult.retcode==10004){
         cRequest.price=cOrderType==O_T_BUY?cResult.ask:cResult.bid;
         CHECK_STOPS;}
      if (cResult.retcode<10008||cResult.retcode>10010){
         if (IsFatalError(cResult.retcode)){
   #else
      CHECK_STOPS;
      int ticket=OrderSend(_symbol,
                           cOrderType,
                           cOrderVolume,
                           price,
                           IS_VIRTUAL_PENDING?INT_MAX:cDeviation,
                           sl,
                           tp,
                           cOrderComment,
                           cOrderMagic,
                           cExpiration,
                           cOrderType==O_T_BUY?clrGreen:clrRed);
      if (ticket<0){
         if (IsFatalError(_LastError)){
   #endif
            cFlag|=TRADE_ERROR;
            cOrderStatus=ORDER_STATUS_ERROR;
         }
         return false;}
      else{
         #ifdef __MQL5__
            cOrderTicket=cResult.order;
         #else
         cOrderTicket=ticket;
         if (OrderSelect(ticket,SELECT_BY_TICKET))
            cOrderTime=OrderOpenTime();
         #endif
         cIdent=cOrderTicket;
         ACTIVATE;
         return true;}}
         
#undef CHECK_PRICE
#undef CHECK_STOPS
//------------------------------------------------------------------------
void COrder::OrderActivateControl(void){
   if (cOrderStatus>ORDER_STATUS_PENDING) return;
   #ifdef __MQL5__
      if (HistoryOrderSelect(cOrderTicket)){
         switch((int)HistoryOrderGetInteger(cOrderTicket,ORDER_STATE)){
            default:                         ACTIVATE
                                             break;
            case ORDER_STATE_CANCELED:
            case ORDER_STATE_REJECTED:
            case ORDER_STATE_EXPIRED:
            case ORDER_STATE_REQUEST_CANCEL: REMOVED}
      }
      else if (OrderSelect(cOrderTicket))
         CheckStops();
   #else
         if (OrderSelect(cOrderTicket,SELECT_BY_TICKET)){
            if (OrderCloseTime())REMOVED
            else if (OrderType()<2) ACTIVATE
            if (cOrderStatus>ORDER_STATUS_PENDING)
               return;
            else
               CheckStops();
         }
   #endif 
}
//-----------------------------------------------------------------------
void COrder::Modify(double mPrice,double mSL=EMPTY_VALUE,double mTP=EMPTY_VALUE){
   mPrice=!mPrice?cOrderPrice:NormalizePrice(mPrice);
   mSL=mSL==EMPTY_VALUE?cOrderSL:NormalizePrice(mSL);
   mTP=mTP==EMPTY_VALUE?cOrderTP:NormalizePrice(mTP);
   if (CompareDouble(mPrice,cOrderPrice,_digits)==0   &&
       CompareDouble(mSL,cOrderSL,_digits)==0         &&
       CompareDouble(mTP,cOrderTP,_digits)==0)        return;
   if (mPrice!=cOrderPrice) cOrderPrice=NormalizePrice(mPrice);
   if (mSL!=cOrderSL) cOrderSL=NormalizePrice(mSL);
   if (mTP!=cOrderTP) cOrderTP=mTP;
   cFlag|=ORDER_MODIFY;
   Modify();}
//-----------------------------------------------------------------------
void COrder::Modify(){
   if (!(cFlag&ORDER_PENDING)||bool(cFlag&(TRADE_ERROR|ORDER_REMOVED|ORDER_ACTIVATE))) {cFlag&=~ORDER_MODIFY; return;}
   if (!CheckPriceLevel(TradePrice(_symbol,cOrderDirect),cOrderPrice,_freezeLevel,_digits)) return;
   #ifdef __MQL5__
      if (!OrderSelect(cOrderTicket)) return;
      ZeroSend();
      cRequest.action=TRADE_ACTION_MODIFY;
      cRequest.order=cOrderTicket;
      cRequest.price=cOrderPrice;
      cRequest.sl=CheckPriceLevel(cOrderSL,cOrderPrice,_stopLevel,_digits);
      cRequest.tp=CheckPriceLevel(cOrderTP,cOrderPrice,_stopLevel,_digits);
      cRequest.type_time=(ENUM_ORDER_TYPE_TIME)OrderGetInteger(ORDER_TYPE_TIME);
      cRequest.expiration=(datetime)OrderGetInteger(ORDER_TIME_EXPIRATION);
      int res=OrderSend(cRequest,cResult);
      if (!res) 
         Print("Error ",cResult.retcode);
      if (res||cResult.retcode==TRADE_RETCODE_NO_CHANGES) cFlag&=~ORDER_MODIFY;
   #else
      if (OrderModify(cOrderTicket,cOrderPrice,cOrderSL,cOrderTP,cExpiration,clrAliceBlue))cFlag&=~ORDER_MODIFY;
   #endif}
//---------------------------------------------------------------------------------
void COrder::CheckVirtualOrderLine(void){
   if (cLineOrder!=NULL) return;
   cLineOrder=new CHLine((string)GetMicrosecondCount(),cOrderPrice,clrRed,1,STYLE_DASH);}
//-----------------------------------------------------------------------
#ifdef __MQL5__
   COrder::COrder(ulong mTicket,CTradeConst* mTradeConst,string symbol):CBaseTrade(mTradeConst,symbol),
      cOrderStatus(ORDER_STATUS_PENDING),cDeviation(0){
      cOrderTicket=mTicket;
      cIdent=mTicket;
      cOrderType=(ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
      cOrderVolume=OrderGetDouble(ORDER_VOLUME_INITIAL);
      cOrderPrice=OrderGetDouble(ORDER_PRICE_OPEN);
      cOrderSL=OrderGetDouble(ORDER_SL);
      cOrderTP=OrderGetDouble(ORDER_TP);
      cSLControl=cOrderSL;
      cExpiration=(datetime)OrderGetInteger(ORDER_TIME_EXPIRATION);
      cOrderMagic=OrderGetInteger(ORDER_MAGIC);
      cOrderTime=(datetime)OrderGetInteger(ORDER_TIME_DONE);
      cTypeTime=(ENUM_ORDER_TYPE_TIME)OrderGetInteger(ORDER_TYPE_TIME);
      cFilling=(ENUM_ORDER_TYPE_FILLING)OrderGetInteger(ORDER_TYPE_FILLING);
      cOrderComment=OrderGetString(ORDER_COMMENT);
      cOrderDirect=cOrderType%2==0?1:-1;
      cFlag|=(ORDER_INIT|ORDER_PENDING);}
//---------------------------------------------------------------------
   COrder::COrder(CTradeConst *mTradeConst,ulong mTicket,string symbol):
      CBaseTrade(mTradeConst,symbol),
      cDeviation(0),
      cClosePositionTicket(0){
      cLineOrder=NULL;
      if (HistorySelectByPosition(mTicket)){
         _tTicket ticket=0;
         for (int i=0;i<HistoryOrdersTotal();++i){
            ticket=HistoryOrderGetTicket(i);
            if (ticket==mTicket)
               break;
            ticket=0;
         }
         if (ticket!=0){
            cOrderTicket=mTicket;
            cIdent=mTicket;
            cOrderType=(ENUM_ORDER_TYPE)HistoryOrderGetInteger(cOrderTicket,ORDER_TYPE);
            cOrderVolume=HistoryOrderGetDouble(cOrderType,ORDER_VOLUME_INITIAL);
            cOrderPrice=HistoryOrderGetDouble(cOrderType,ORDER_PRICE_OPEN);
            cOrderSL=HistoryOrderGetDouble(cOrderType,ORDER_SL);
            cOrderTP=HistoryOrderGetDouble(cOrderType,ORDER_TP);
            cExpiration=(datetime)HistoryOrderGetInteger(cOrderType,ORDER_TIME_EXPIRATION);
            cOrderMagic=HistoryOrderGetInteger(cOrderType,ORDER_MAGIC);
            cOrderTime=(datetime)HistoryOrderGetInteger(cOrderType,ORDER_TIME_DONE);
            cTypeTime=(ENUM_ORDER_TYPE_TIME)HistoryOrderGetInteger(cOrderType,ORDER_TYPE_TIME);
            cFilling=(ENUM_ORDER_TYPE_FILLING)HistoryOrderGetInteger(cOrderType,ORDER_TYPE_FILLING);
            cOrderComment=HistoryOrderGetString(cOrderType,ORDER_COMMENT);
            cOrderDirect=cOrderType%2==0?1:-1;
            cFlag|=ORDER_INIT;
            switch((ENUM_ORDER_STATE)HistoryOrderGetInteger(mTicket,ORDER_STATE)){
               case ORDER_STATE_STARTED:
               case ORDER_STATE_PLACED:
               case ORDER_STATE_PARTIAL:
               case ORDER_STATE_FILLED:
               case ORDER_STATE_REQUEST_ADD: 
               case ORDER_STATE_REQUEST_MODIFY:
                  cOrderStatus=cOrderType>ORDER_TYPE_SELL?ORDER_STATUS_PENDING:ORDER_STATUS_ACTIVATE;
                  cFlag|=cOrderType>ORDER_TYPE_SELL?ORDER_PENDING:ORDER_ACTIVATE;
                  break;
               case ORDER_STATE_CANCELED:
               case ORDER_STATE_REJECTED:
               case ORDER_STATE_EXPIRED:
               case ORDER_STATE_REQUEST_CANCEL:
                  cOrderStatus=ORDER_STATUS_REMOVED;
                  cFlag|=ORDER_REMOVED;
                  break;
            }
         }
      }
      else{
         cOrderStatus=ORDER_STATUS_ERROR;
         cFlag|=TRADE_ERROR;
      }
   }  
#else
   COrder::COrder(CTradeConst *mTradeConst):
      CBaseTrade(mTradeConst),
      cLineOrder(NULL),
      cOrderTicket(OrderTicket()),
      cOrderType(OrderType()),
      cOrderVolume(OrderLots()),
      cOrderPrice(OrderOpenPrice()),
      cOrderSL(OrderStopLoss()),
      cOrderTP(OrderTakeProfit()),
      cExpiration(OrderExpiration()),
      cOrderDirect(OrderType()%2==0?1:-1),
      cDeviation(0),
      cOrderMagic(OrderMagicNumber()),
      cOrderComment(OrderComment()),
      cOrderTime(OrderOpenTime())
      {cIdent=cOrderTicket;
       cOrderStatus=!OrderCloseTime()?cOrderType>1?ORDER_STATUS_PENDING:ORDER_STATUS_ACTIVATE:!OrderOpenPrice()?ORDER_STATUS_REMOVED:ORDER_STATUS_ACTIVATE;
       if (bool (cFlag&TRADE_ERROR)) return;
       cFlag|=ORDER_INIT;
       if (cOrderStatus==ORDER_STATUS_ACTIVATE) cFlag|=ORDER_ACTIVATE;
       else cFlag|=ORDER_PENDING;}
#endif
//----------------------------------------------------------------------
void COrder::CheckStops(){
#ifdef __MQL5__
   double sl=OrderGetDouble(ORDER_SL);
   double tp=OrderGetDouble(ORDER_TP);
   double price=OrderGetDouble(ORDER_PRICE_OPEN);
#else
   double sl=OrderStopLoss();
   double tp=OrderTakeProfit();
   double price=OrderOpenPrice();
#endif
   cFlag&=~TRADE_OPEN_PRICE_CHANGED;
   if(CompareDouble(tp,cTPControl,_digits)==0)
      cFlag&=~TRADE_TP_CHANGE_IN_PROCESS;
   else {
      if (!(cFlag&TRADE_TP_CHANGE_IN_PROCESS)){
         cFlag|=TRADE_CHANGE_TP;
         cTPControl=tp;
         cOrderTP=tp;
      }
   }
   if(CompareDouble(sl,cSLControl,_digits)==0){
      cFlag&=~TRADE_SL_CHANGE_IN_PROCESS;
   }
   else {
      if (!(cFlag&TRADE_SL_CHANGE_IN_PROCESS)){
         cFlag|=TRADE_CHANGE_SL;
         cSLControl=sl;
         cOrderSL=sl;
      }
   }
   if (CompareDouble(price,cOrderPrice,_digits)!=EQUALLY){
      cFlag|=TRADE_OPEN_PRICE_CHANGED;
      cOrderPrice=price;
   }
}

#undef ACTIVATE
#undef REMOVED

#endif