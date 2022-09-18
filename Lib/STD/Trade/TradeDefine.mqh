#include "../Define/StdDefine.mqh"

#ifndef _STD_TRADE_DEFINE_
#define _STD_TRADE_DEFINE_

#include "../Math/Math.mqh"

#define _tTradeConst STD_TradeConst

#ifdef __MQL5__
   #define _tTradeError uint
#else
   #define _tTradeError int
#endif

struct TradeState{
};

enum ECloseReason{
   eCloseReasonNull,
   eCloseReasonManual,
   eCloseReasonAlgo,
   eCloseReasonSL,
   eCloseReasonTP
};

class STD_TradeConst{
public:
   string                  symbol;
   int                     lotDigits;
   double                  lotStep;
   double                  lotMax;
   double                  lotMin;
   double                  tickSize;
   double                  point;
   double                  stopLevel;
   double                  freezeLevel;
   int                     digits;
   ENUM_SYMBOL_TRADE_EXECUTION   executionMode;
#ifdef __MQL5__
   ENUM_ACCOUNT_MARGIN_MODE      marginMode;
   int                           expirationMode;
   int                           fillingMode;
   int                           orderMode;
#endif   
   STD_TradeConst():symbol(NULL){}
   STD_TradeConst(string _symbol):symbol(NULL){Init(_symbol);}
   STD_TradeConst(const STD_TradeConst& other) {this=other;}
   bool Init(string _symbol);
   bool IsInit() const {return symbol!=NULL;}
};
//----------------------------------------------------------------------
bool STD_TradeConst::Init(string _symbol){
   if (!MQLInfoInteger(MQL_TESTER)&&!SymbolSelect(_symbol,true))
      return false;
   symbol=_symbol;
   lotStep=SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);
   lotDigits=MathMax(-(int)MathFloor(MathLog10(lotStep)),0);
   lotMax=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);
   lotMin=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);
   point=SymbolInfoDouble(symbol,SYMBOL_POINT);
   tickSize=SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_SIZE);
   stopLevel=SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL)*point;
   freezeLevel=SymbolInfoInteger(symbol,SYMBOL_TRADE_FREEZE_LEVEL)*point;
   digits=(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);
   executionMode=(ENUM_SYMBOL_TRADE_EXECUTION)SymbolInfoInteger(symbol,SYMBOL_TRADE_EXEMODE);
#ifdef __MQL5__
   marginMode=(ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE);
   fillingMode=(int)SymbolInfoInteger(symbol,SYMBOL_FILLING_MODE);
   expirationMode=(int)SymbolInfoInteger(symbol,SYMBOL_EXPIRATION_MODE);
   orderMode=(int)SymbolInfoInteger(symbol,SYMBOL_ORDER_MODE);
#endif
   return true;
}

#endif 