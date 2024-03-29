#ifndef _C_BASE_TRADE_
#define _C_BASE_TRADE_

#include "..\..\Define\MQLDefine.mqh"
#include "..\..\Functions\TradeFunctions.mqh"
#include "DefineTrade.mqh"
#include "CTradeConst.mqh"

#ifdef __MQL5__
   enum ENUM_FILLING_MODE
   {
      FILLING_AUTO,
      FILLING_FOK,
      FILLING_IOC,
      FILLING_RETURN
   };
#endif 

class CBaseTrade
{
private:
   datetime          cTimeInitialServer;
   datetime          cTimeInitialLocal;
   datetime          cTimeInitialGMT;
protected:
   bool              cIsDeleteableTradeConst;
   CTradeConst*         cTradeConst;
   ulong                cFlag;
   ulong                cStateFlag;
   ulong                cCloseFlag;
   double            cSLControl;
   double            cTPControl;
   uint                 cErrorCode;
   bool              cIsFirstControl;
   _tTicket          cIdent;
   #ifdef __MQL5__
      bool              cIsNetting;
      MqlTradeRequest   cRequest;
      MqlTradeResult    cResult;
   #endif
public:
   datetime          GetTimeInitial(ENUM_TIME_TYPE mTimeType=TIME_SERVER) const;
   ulong             GetFlag()                                                               {return cFlag;}
   ulong             GetCloseFlag()                                                          {return cCloseFlag;}
   const CTradeConst*      GetTradeConst() const                                                        {return cTradeConst;}
   string            GetSymbol()    const                                                         {return _symbol;}
   int               GetDigits()    const                                                         {return _digits;}
   uint              ErrorCode()    const {return cErrorCode;}
   bool              IsCancelByDeviation()         {return bool(cCloseFlag&CANCEL_BY_DEVIATION);}
   bool              IsError()   const             {return bool(cFlag&TRADE_ERROR);}
   bool              IsFinish()  const             {return bool(cFlag&TRADE_FINISH);}
   void              SetVirtualStops(bool mIsOn)   {SetVirtualTP(mIsOn); SetVirtualSL(mIsOn);}
   void              SetVirtualTP(bool mIsOn)      {if (mIsOn) cStateFlag|=FLAG_VIRTUAL_TP; else cStateFlag&=~FLAG_VIRTUAL_TP;}
   void              SetVirtualSL(bool mIsOn)      {if (mIsOn) cStateFlag|=FLAG_VIRTUAL_SL; else cStateFlag&=~FLAG_VIRTUAL_SL;}
   void              SetVirtualPending(bool mIsOn) {if (mIsOn) cStateFlag|=FLAG_VIRTUAL_PENDING; else cStateFlag&=~FLAG_VIRTUAL_PENDING;}
   double            Point() const {return _point;}
   _tTicket          GetIdent() const                                                          {return cIdent;}
                    ~CBaseTrade()   {if (cIsDeleteableTradeConst) delete cTradeConst;}
   double            NormalizePrice(double mPrice)    {return NormalizeDouble(MathRound(mPrice/_tickSize)*_tickSize,_digits);}
protected:
                     CBaseTrade(string mSymbol,CTradeConst* mTradeConst):
                        cFlag(0),
                        cStateFlag(0),
                        cCloseFlag(0),
                        cTradeConst(!CheckPointer(mTradeConst)?new CTradeConst(mSymbol):mTradeConst),
                        cIsDeleteableTradeConst(!CheckPointer(mTradeConst)),
                        cSLControl(0.0),
                        cTPControl(0.0),
                        cErrorCode(0),
                        cIsFirstControl(true),
                        cIdent(0)
                        #ifdef __MQL5__
                           ,cIsNetting(AccountInfoInteger(ACCOUNT_MARGIN_MODE)!=ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
                        #endif 
                        {BaseInit();}
   double            NormalizeVolume(double mVolume,bool mMinIsAlways=true);
   bool              IsFatalError(int_type mError);
   #ifdef __MQL5__
                     CBaseTrade(CTradeConst* mTradeConst,string symbol);
      void           ZeroSend()  {ZeroMemory(cRequest); ZeroMemory(cResult);}
   #else
                     CBaseTrade(CTradeConst* mTradeConst);
   #endif
private:
   void              BaseInit();
};
//--------------------------------------------------------------------------------
void CBaseTrade::BaseInit(){
   cTimeInitialServer=TimeCurrent();
   cTimeInitialLocal=TimeLocal();
   cTimeInitialGMT=TimeGMT();
   #ifdef __MQL5__
      ZeroSend();
   #endif
   if (!CheckPointer(cTradeConst)){cCloseFlag|=ERROR_INIT_TRADE_CONST; cFlag|=TRADE_ERROR;}}
//--------------------------------------------------------------------------------
double CBaseTrade::NormalizeVolume(double mVolume,bool mMinIsAlways=true){
   double x=MathPow(10,_lotDigits);
   mVolume=MathFloor(MathRound(mVolume*x)/_lotStep/x)*_lotStep;
   if (mVolume<_lotMin) return mMinIsAlways?_lotMin:0.0;
   if (mVolume>_lotMax) return _lotMax;
   return NormalizeDouble(mVolume,_lotDigits);}
//-------------------------------------------------------------------------------
datetime CBaseTrade::GetTimeInitial(ENUM_TIME_TYPE mTimeType=TIME_SERVER) const{
   switch(mTimeType){
      default:          return 0;
      case TIME_SERVER: return cTimeInitialServer;
      case TIME_LOCAL:  return cTimeInitialLocal;
      case TIME_GMT:    return cTimeInitialGMT;}}
//-------------------------------------------------------------------------------
   CBaseTrade::CBaseTrade(CTradeConst *mTradeConst,string symbol):
      cTimeInitialServer(0),
      cTimeInitialLocal(0),
      cTimeInitialGMT(0),
      cIsDeleteableTradeConst(!CheckPointer(mTradeConst)),
      cTradeConst(!CheckPointer(mTradeConst)?new CTradeConst(symbol):mTradeConst),
      cFlag(0),
      cStateFlag(0),
      cCloseFlag(0),
      cErrorCode(0),
      cIsFirstControl(false)
#ifdef __MQL5__
      ,cIsNetting(AccountInfoInteger(ACCOUNT_MARGIN_MODE)!=ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
#endif{
         if (!CheckPointer(cTradeConst)){
            cFlag|=TRADE_ERROR;
            cCloseFlag|=ERROR_INIT_TRADE_CONST;
         }
#ifdef __MQL5__
         ZeroSend();
#endif
      }
//-------------------------------------------------------------------------------
bool CBaseTrade::IsFatalError(int_type mError){
   switch(mError){
      default:                      return false;
#ifdef __MQL5__
      case TRADE_RETCODE_CLIENT_DISABLES_AT:
      case TRADE_RETCODE_NO_MONEY:
      case TRADE_RETCODE_INVALID_STOPS:
      case TRADE_RETCODE_MARKET_CLOSED:
         cErrorCode=mError;
         return true;
#else
      case ERR_TRADE_DISABLED:
      case ERR_NOT_ENOUGH_MONEY:
      case ERR_INVALID_STOPS:
      case ERR_MARKET_CLOSED:
         cErrorCode=mError;
         return true;
#endif}}

#endif