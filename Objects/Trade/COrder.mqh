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
      mFilling,         \
      mIsMain
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
   CTradeConst* mTradeConst=NULL 

#ifdef __MQL5__
   #define SET _SET,MQL5_SET
#else
   #define SET _SET
#endif
//------------------------------------------------------------------------------------
#define _SET_IN \
   mSymbol,    \
   mType,      \
   mVolume,    \
   mPrice,     \
   mSL,        \
   mTP,        \
   mMagic,     \
   mDeviation, \
   mExpiration,\
   mComment,   \
   mTradeConst 

#ifdef __MQL5__
   #define SET_IN _SET_IN,MQL5_SET_IN
#else
   #define SET_IN _SET_IN
#endif
//-------------------------------------------------------------------------------------   
enum ENUM_ORDER_STATUS
  {
   ORDER_STATUS_NOT_INIT,
   ORDER_STATUS_INIT,
   ORDER_STATUS_MUST_OPEN,
   ORDER_STATUS_PENDING,
   ORDER_STATUS_ACTIVATE,
   ORDER_STATUS_REMOVED,
   ORDER_STATUS_ERROR
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
   int               GetOrderDirect()  {return cOrderDirect;}
   long_type         GetOrderTicket()  {return cOrderTicket;}
   bool              Pending();
   bool              Remove();
   bool              IsActivate()   {return bool(cFlag&ORDER_ACTIVATE);}
   void              Modify(double mPrice,double mSL=EMPTY_VALUE,double mTP=EMPTY_VALUE);
protected:
                     COrder(SET);
                    ~COrder() {delete cLineOrder;}
   ulong             OrderControl();
   bool              CheckOrderPrice(double mPrice);
   bool              CheckOrderTime()  {return !cExpiration||TimeCurrent()<cExpiration;}
   bool              Deal();
private:
   bool              CheckOrderOpenPrice();
   void              OrderActivateControl();
   void              Modify();
   bool              CheckDeviation(double mPrice) {return !cDeviation||MathAbs(mPrice-cOrderPrice)>cDeviation*_point;}
   void              CheckVirtualOrderLine();
#ifdef __MQL5__
public:
   void              SetClosePositionTicket(long_type mTicket)    {cClosePositionTicket=mTicket;}
private:
   ENUM_ORDER_TYPE_FILLING GetFilling(ENUM_FILLING_MODE mFilling);
protected:
                           COrder(ulong mTicket,TRADE_CONST_PUSH);
   virtual void            NewSL(double mSL) {if (ComparePrice(mSL,cOrderPrice,cOrderDirect,_digits)<0) cOrderSL=NormalizePrice(mSL); cFlag&=~ORDER_MODIFY; Modify();}
   virtual void            NewTP(double mTP) {if (ComparePrice(mTP,cOrderPrice,cOrderDirect,_digits)>0) cOrderTP=NormalizePrice(mTP); cFlag&=~ORDER_MODIFY; Modify();}
#endif
};
//--------------------------------------------------------------------
COrder::COrder(SET):
   CBaseTrade(mSymbol
              #ifdef __MQL5__
                 ,mTradeConst,
                 mIsMain
              #endif),
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
   cOrderVolume=NormalizeVolume(mVolume);
   cOrderPrice=NormalizePrice(mPrice);
   cOrderSL=NormalizePrice(mSL);
   cOrderTP=NormalizePrice(mTP);
   #ifdef __MQL5__
      cFilling=GetFilling(mFilling);
   #endif
   cFlag|=CheckOrderPrice(cOrderPrice)&&CheckOrderTime()?ORDER_INIT:TRADE_ERROR;
   if (bool(cFlag&ORDER_INIT)) cOrderStatus=ORDER_STATUS_INIT; else cOrderStatus=ORDER_STATUS_ERROR;}
//-------------------------------------------------------------------------------
bool COrder::CheckOrderPrice(double mPrice=0.0){
   if (!mPrice) mPrice=TradePrice(_symbol,cOrderDirect);
   bool checkSLTP=(!cOrderSL||cOrderDirect*(mPrice-cOrderSL)>=_tickSize)&&
                  (!cOrderTP||cOrderDirect*(cOrderTP-mPrice)>=_tickSize),
        checkPrice=CheckOrderOpenPrice();
   if (!checkSLTP) cCloseFlag|=WRONG_PENDING_PRICE_SLTP;
   if (!checkPrice) cCloseFlag|=WRONG_PENDING_PRICE_CUR_PRICE;
   return checkSLTP&&checkPrice;}
//-------------------------------------------------------------------------------
#ifdef __MQL5__
   ENUM_ORDER_TYPE_FILLING COrder::GetFilling(ENUM_FILLING_MODE mFilling){
      if (!_fillingMode) return ORDER_FILLING_RETURN;
      else if (mFilling==FILLING_AUTO||mFilling==FILLING_FOK) return !(_fillingMode&SYMBOL_FILLING_FOK)?ORDER_FILLING_IOC:ORDER_FILLING_FOK;
      else return  !(_fillingMode&SYMBOL_FILLING_IOC)?ORDER_FILLING_FOK:ORDER_FILLING_IOC;}
#endif
//-------------------------------------------------------------------------------
ulong COrder::OrderControl(void){
   if (bool(cFlag&(ORDER_MODIFY))&&cFlag!=0&&!(cFlag&(ORDER_ACTIVATE))&&cOrderStatus!=ORDER_STATUS_MUST_OPEN) Modify();
   switch(cOrderStatus){
      case ORDER_STATUS_INIT:        if (!Pending())  break;
      case ORDER_STATUS_MUST_OPEN:   if (!Deal())     break;
      case ORDER_STATUS_PENDING:     OrderActivateControl();}
   return cFlag;}
//--------------------------------------------------------------------------------
bool COrder::CheckOrderOpenPrice(void){
   if (cOrderType==O_T_BUY||cOrderType==O_T_SELL) return true;
   #ifdef __MQL5__
      if (_marginMode==ACCOUNT_MARGIN_MODE_EXCHANGE   &&
          cOrderType!=O_T_BUY_STOP                    &&
          cOrderType!=O_T_SELL_STOP)                  return true;
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
      #else
         cOrderTicket=OrderTicket();
         cOrderTime=OrderOpenTime();
      #endif
      cFlag|=ORDER_PENDING;
      cOrderStatus=ORDER_STATUS_PENDING;
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

#define CHECK_PRICE(price)                                                    \
   if (!CheckOrderPrice(price)){                                              \
      cFlag|=TRADE_ERROR;                                                     \
      cOrderStatus=ORDER_STATUS_ERROR;                                        \
      return false;}                                                          \
   CHECK_STOPS

bool COrder::Deal(void){
   if (cOrderStatus>ORDER_STATUS_MUST_OPEN) return true;
   DELETE(cLineOrder);
      double price=cOrderType==O_T_BUY?Ask(_symbol):Bid(_symbol);
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
         CHECK_PRICE(cRequest.price);}
      while (!OrderSend(cRequest,cResult)&&cResult.retcode==10004){
         cRequest.price=cOrderType==O_T_BUY?cResult.ask:cResult.bid;
         CHECK_PRICE(cRequest.price);}
      if (cResult.retcode<10008||cResult.retcode>10010){
         if (IsFatalError(cResult.retcode)){
   #else
      CHECK_PRICE(price);
      if (!OrderSelect(OrderSend(_symbol,
                                 cOrderType,
                                 cOrderVolume,
                                 price,
                                 IS_VIRTUAL_PENDING?INT_MAX:cDeviation,
                                 sl,
                                 tp,
                                 cOrderComment,
                                 cOrderMagic,
                                 cExpiration,
                                 cOrderType==O_T_BUY?clrGreen:clrRed),SELECT_BY_TICKET)){
         if (IsFatalError(_LastError)){
   #endif
            cFlag|=TRADE_ERROR;
            cOrderStatus=ORDER_STATUS_ERROR;
            Print("Order deal fatal error N",#ifdef __MQL5__
                                                cResult.retcode
                                             #else
                                                _LastError
                                             #endif);}
         return false;}
      else{
         #ifdef __MQL5__
            cOrderTicket=cResult.order;
         #else
            cOrderTicket=OrderTicket();
            cOrderTime=OrderOpenTime();
         #endif
         ACTIVATE;
         return true;}}
         
#undef CHECK_PRICE
#undef CHECK_STOPS
//------------------------------------------------------------------------
void COrder::OrderActivateControl(void){
   if (cOrderStatus>ORDER_STATUS_PENDING) return;
   #ifdef __MQL5__
      if (!HistoryOrderSelect(cOrderTicket)) return;
      switch((int)HistoryOrderGetInteger(cOrderTicket,ORDER_STATE)){
         default:                         ACTIVATE
                                          break;
         case ORDER_STATE_PLACED:
         case ORDER_STATE_CANCELED:
         case ORDER_STATE_REJECTED:
         case ORDER_STATE_EXPIRED:
         case ORDER_STATE_REQUEST_CANCEL: REMOVED}}
   #else
      if (!OrderSelect(cOrderTicket,SELECT_BY_TICKET)) return;
      if (OrderCloseTime()) REMOVED
      else if (OrderType()<2) ACTIVATE}
   #endif 
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
      if (!res) Print("Error ",cResult.retcode);
      if (res||cResult.retcode==TRADE_RETCODE_NO_CHANGES) cFlag&=~ORDER_MODIFY;
   #else
   #endif}
//---------------------------------------------------------------------------------
void COrder::CheckVirtualOrderLine(void){
   if (cLineOrder!=NULL) return;
   cLineOrder=new CHLine((string)GetMicrosecondCount(),cOrderPrice,clrRed,1,STYLE_DASH);}
//-----------------------------------------------------------------------
#ifdef __MQL5__
   COrder::COrder(ulong mTicket,TRADE_CONST_PUSH):CBaseTrade(M_TRADE_CONST),
      cOrderStatus(ORDER_STATUS_ACTIVATE),cDeviation(0)
      {if (!HistoryDealSelect(mTicket)) return;
      cOrderTicket=HistoryDealGetInteger(mTicket,DEAL_ORDER);
      if (!HistoryOrderSelect(cOrderTicket)) return;
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
      cFlag|=(ORDER_INIT|ORDER_ACTIVATE);}
#endif

#undef ACTIVATE
#undef REMOVED

#endif