#include "pch.mqh"

#ifndef _SADJ_START_
#define _SADJ_START_

#include "..\Lib\Objects\CFlag.mqh"
#include "Stop.mqh"

#define INIT_FLAG_START 0x1
#define INIT_FLAG_CHANGE_FRAME 0x2
#define INIT_FLAG_CHANGE_SYMBOL 0x4
#define INIT_FLAG_CHANGE_PARAM 0x8
#define INIT_FLAG_CHANGE_CHART 0x10

#define INIT_FLAG_ALL_REASON (INIT_FLAG_START|INIT_FLAG_CHANGE_FRAME|INIT_FLAG_CHANGE_SYMBOL|INIT_FLAG_CHANGE_PARAM)

enum ENUM_START_FLAG{
   START_FLAG_NONE,
   START_FLAG_CHANGE_PARAM,
   START_FLAG_RESTART,
   START_FLAG_CHARTCHANGE
};

struct SStartValue{
   string symbol;
   double lotStep,lotMax,lotMin,tickSize,stopLevel,freezeLevel,lotSize;
   ENUM_TIMEFRAMES timeFrame;
   int lotDigits;
} gChartVal;

//---------------------------------------------------------------------
ENUM_INIT_RETCODE Start(ENUM_START_FLAG fFlag=START_FLAG_NONE){
   static CFlag flag(INIT_FLAG_START);
   ENUM_INIT_RETCODE res=INIT_SUCCEEDED;;
   switch(fFlag){
      case START_FLAG_RESTART:      flag+=INIT_FLAG_START;        return INIT_SUCCEEDED;
      case START_FLAG_CHANGE_PARAM: flag+=INIT_FLAG_CHANGE_PARAM; return INIT_SUCCEEDED;
      case START_FLAG_CHARTCHANGE:  flag+=INIT_FLAG_CHANGE_CHART; return INIT_SUCCEEDED;}
   if (!flag) return INIT_SUCCEEDED;
   if (flag.Check(INIT_FLAG_CHANGE_CHART)) CheckChartOnInit(flag);
   if (flag.Check(INIT_FLAG_CHANGE_SYMBOL)) RestartOnInit(res);
   else if (flag.Check(INIT_FLAG_START)) StartOnInit(res);
   else{
      if (flag.Check(INIT_FLAG_CHANGE_PARAM)) ChangeParamOnInit(res);
      if (flag.Check(INIT_FLAG_CHANGE_FRAME)) ChangeFrameOnInit(res);
   }
   flag=0;
   return res;
}
//-------------------------------------------------------------------------------
void CheckChartOnInit(CFlag &mFlag){
   if (gChartVal.symbol!=_Symbol) mFlag+=INIT_FLAG_CHANGE_SYMBOL;
   else if (gChartVal.timeFrame!=_Period) mFlag+=INIT_FLAG_CHANGE_FRAME;}
//-------------------------------------------------------------------------------
void RestartOnInit(ENUM_INIT_RETCODE &fRes){
   StopOnInit(fRes);
   if (fRes==INIT_SUCCEEDED) StartOnInit(fRes);}
//-------------------------------------------------------------------------------
void StartOnInit(ENUM_INIT_RETCODE &fRes){
   InitChartValues();}
//-------------------------------------------------------------------------------
void ChangeParamOnInit(ENUM_INIT_RETCODE &fRes){};
//-------------------------------------------------------------------------------
void ChangeFrameOnInit(ENUM_INIT_RETCODE &fRes){
   gChartVal.timeFrame=_Period;}
//--------------------------------------------------------------------------------
void StopOnInit(ENUM_INIT_RETCODE &fRes){};
//--------------------------------------------------------------------
void InitChartValues(){
   gChartVal.symbol=_Symbol;
   gChartVal.timeFrame=_Period;
   gChartVal.lotSize=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_CONTRACT_SIZE);
   gChartVal.lotStep=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   gChartVal.lotDigits=MathMax(-(int)MathFloor(MathLog10(gChartVal.lotStep)),0);
   gChartVal.lotMax=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   gChartVal.lotMin=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   gChartVal.tickSize=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   gChartVal.stopLevel=SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   gChartVal.freezeLevel=SymbolInfoInteger(_Symbol,SYMBOL_TRADE_FREEZE_LEVEL)*_Point;}


#endif