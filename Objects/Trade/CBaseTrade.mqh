#ifndef _C_BASE_TRADE_
#define _C_BASE_TRADE_

#include <MyMQLLib\Define\MQLDefine.mqh>
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
   bool              cIsDeleteableTradeConst;
   datetime          cTimeInitialServer;
   datetime          cTimeInitialLocal;
   datetime          cTimeInitialGMT;
protected:
   CTradeConst*         cTradeConst;
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
   CTradeConst*      GetTradeConst()                                                         {return cTradeConst;}
   string            GetSymbol()                                                             {return _symbol;}
   int               GetDigits()                                                             {return _digits;}
   bool              IsCancelByDeviation()         {return bool(cCloseFlag&CANCEL_BY_DEVIATION);}
   bool              IsError()                     {return bool(cFlag&TRADE_ERROR);}
   bool              IsFinish()                    {return bool(cFlag&TRADE_FINISH);}
   void              SetVirtualStops(bool mIsOn)   {SetVirtualTP(mIsOn); SetVirtualSL(mIsOn);}
   void              SetVirtualTP(bool mIsOn)      {if (mIsOn) cStateFlag|=FLAG_VIRTUAL_TP; else cStateFlag&=~FLAG_VIRTUAL_TP;}
   void              SetVirtualSL(bool mIsOn)      {if (mIsOn) cStateFlag|=FLAG_VIRTUAL_SL; else cStateFlag&=~FLAG_VIRTUAL_SL;}
   void              SetVirtualPending(bool mIsOn) {if (mIsOn) cStateFlag|=FLAG_VIRTUAL_PENDING; else cStateFlag&=~FLAG_VIRTUAL_PENDING;}
   #ifdef __MQL5__
      ulong             GetIdent()                                                           {return cIdent;}
   #endif
                    ~CBaseTrade()   {if (cIsDeleteableTradeConst) delete cTradeConst;}
   double            NormalizePrice(double mPrice)    {return NormalizeDouble(MathRound(mPrice/_tickSize)*_tickSize,_digits);}
protected:
                     CBaseTrade(string mSymbol,CTradeConst* mTradeConst
                                #ifdef __MQL5__
                                   ,bool mIsMain
                                #endif):
                        cFlag(0),
                        cStateFlag(0),
                        cCloseFlag(0),
                        cTradeConst(!CheckPointer(mTradeConst)?new CTradeConst(mSymbol):mTradeConst),
                        cIsDeleteableTradeConst(!CheckPointer(mTradeConst))
                        #ifdef __MQL5__
                           ,cIsMain(mIsMain),
                           cIdent(-1),
                           cIsNetting(AccountInfoInteger(ACCOUNT_MARGIN_MODE)!=ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
                        #endif 
                        {BaseInit();}
   double            NormalizeVolume(double mVolume,bool mMinIsAlways=true);
   bool              IsFatalError(int_type mError);
   #ifdef __MQL5__
                     CBaseTrade(CTradeConst* mTradeConst);
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
datetime CBaseTrade::GetTimeInitial(ENUM_TIME_TYPE mTimeType=TIME_SERVER){
   switch(mTimeType){
      default:          return 0;
      case TIME_SERVER: return cTimeInitialServer;
      case TIME_LOCAL:  return cTimeInitialLocal;
      case TIME_GMT:    return cTimeInitialGMT;}}
//-------------------------------------------------------------------------------
#ifdef __MQL5__
   CBaseTrade::CBaseTrade(CTradeConst* mTradeConst):cFlag(0),cTradeConst(mTradeConst),
      cIsMain(false),cIsNetting(AccountInfoInteger(ACCOUNT_MARGIN_MODE)!=ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
   {BaseInit();}
#else
   CBaseTrade::CBaseTrade(CTradeConst *mTradeConst):
   cTimeInitialServer(0),
   cTimeInitialLocal(0),
   cTimeInitialGMT(0),
   cTradeConst(!CheckPointer(mTradeConst)?new CTradeConst(OrderSymbol()):mTradeConst),
   cFlag(0),
   cStateFlag(0),
   cCloseFlag(0)
   {if (!CheckPointer(cTradeConst)) {cFlag|=TRADE_ERROR; cCloseFlag|=ERROR_INIT_TRADE_CONST;}}
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