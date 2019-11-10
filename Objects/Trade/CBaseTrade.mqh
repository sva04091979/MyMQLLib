#ifndef _C_BASE_TRADE_
#define _C_BASE_TRADE_

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
   TRADE_CONST_DECL;
   ulong                cFlag;
   ulong                cStateFlag;
   ulong                cCloseFlag;
   #ifdef __MQL5__
      ulong             cIdent;
      bool              cIsNetting;
      bool              cIsMain;
      MqlTradeRequest   cRequest;
      MqlTradeResult    cResult;
   #endif
public:
   datetime          GetTimeInitial(ENUM_TIME_TYPE mTimeType=TIME_SERVER);
   ulong             GetFlag()                                                               {return cFlag;}
   ulong             GetCloseFlag()                                                          {return cCloseFlag;}
   string            GetSymbol()                                                             {return _symbol;}
   int               GetDigits()                                                             {return _digits;}
   bool              IsCancelByDeviation()         {return bool(cCloseFlag&CANCEL_BY_DEVIATION);}
   void              SetVirtualStops(bool mIsOn)   {SetVirtualTP(mIsOn); SetVirtualSL(mIsOn);}
   void              SetVirtualTP(bool mIsOn)      {if (mIsOn) cStateFlag|=FLAG_VIRTUAL_TP; else cStateFlag&=~FLAG_VIRTUAL_TP;}
   void              SetVirtualSL(bool mIsOn)      {if (mIsOn) cStateFlag|=FLAG_VIRTUAL_SL; else cStateFlag&=~FLAG_VIRTUAL_SL;}
   void              SetVirtualPending(bool mIsOn) {if (mIsOn) cStateFlag|=FLAG_VIRTUAL_PENDING; else cStateFlag&=~FLAG_VIRTUAL_PENDING;}
   #ifdef __MQL5__
      ulong             GetIdent()                                                           {return cIdent;}
   #endif
                    ~CBaseTrade()   {#ifdef __MQL5__ if (cIsMain) #endif delete TRADE_CONST;}
protected:
                     CBaseTrade(string mSymbol
                                #ifdef __MQL5__
                                   ,TRADE_CONST_PUSH,
                                   bool mIsMain
                                #endif):
                        cFlag(0),
                        cStateFlag(0),
                        cCloseFlag(0),
                        TRADE_CONST_INIT(#ifdef __MQL5__
                                            !CheckPointer(mTradeConst)?new CTradeConst(mSymbol):mTradeConst
                                         #else
                                            new CTradeConst(mSymbol)
                                         #endif)
                        #ifdef __MQL5__
                           ,cIsMain(mIsMain),
                           cIdent(-1),
                           cIsNetting(AccountInfoInteger(ACCOUNT_MARGIN_MODE)!=ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
                        #endif 
                        {BaseInit();}
   double            NormalizeVolume(double mVolume,bool mMinIsAlways=true);
   double            NormalizePrice(double mPrice)    {return NormalizeDouble(MathRound(mPrice/_tickSize)*_tickSize,_digits);}
   bool              IsFatalError(int_type mError);
   #ifdef __MQL5__
                     CBaseTrade(TRADE_CONST_PUSH);
      void           ZeroSend()  {ZeroMemory(cRequest); ZeroMemory(cResult);}
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
   if (!CheckPointer(TRADE_CONST)) {cCloseFlag|=ERROR_INIT_TRADE_CONST; cFlag|=TRADE_ERROR;}}
//--------------------------------------------------------------------------------
double CBaseTrade::NormalizeVolume(double mVolume,bool mMinIsAlways=true){
   double x=MathPow(10,_lotDigits);
   mVolume=MathFloor(MathRound(mVolume*x)/_lotStep/x)*_lotStep;
   if (mVolume<_lotMin) return mMinIsAlways?_lotMin:0.0;
   if (mVolume>_lotMax) return _lotMax;
   return NormalizeDouble(mVolume,_lotDigits);}
//-------------------------------------------------------------------------------
datetime CBaseTrade::GetTimeInitial(ENUM_TIME_TYPE mTimeType=TIME_SERVER){
   switch(mTimeType){
      default:          return 0;
      case TIME_SERVER: return cTimeInitialServer;
      case TIME_LOCAL:  return cTimeInitialLocal;
      case TIME_GMT:    return cTimeInitialGMT;}}
//-------------------------------------------------------------------------------
#ifdef __MQL5__
   CBaseTrade::CBaseTrade(TRADE_CONST_PUSH):cFlag(0),TRADE_CONST(M_TRADE_CONST),
      cIsMain(false),cIsNetting(AccountInfoInteger(ACCOUNT_MARGIN_MODE)!=ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
   {BaseInit();}
#endif
//-------------------------------------------------------------------------------
bool CBaseTrade::IsFatalError(int_type mError){
   switch(mError){
      default:                      return false;
#ifdef __MQL5__
      case TRADE_RETCODE_NO_MONEY:  return true;
#else
      case ERR_NOT_ENOUGH_MONEY: return true;
#endif}}

#endif