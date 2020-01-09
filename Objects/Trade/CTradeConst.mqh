#ifndef _C_TRADE_CONST_
#define _C_TRADE_CONST_

#define TRADE_CONST_GET_PTR (!CheckPointer(cTradeConst)?NULL:GetPointer(cTradeConst))
#define _symbol      cTradeConst.symbol
#define _lotDigits   cTradeConst.lotDigits
#define _lotStep     cTradeConst.lotStep
#define _lotMax      cTradeConst.lotMax
#define _lotMin      cTradeConst.lotMin
#define _tickSize    cTradeConst.tickSize
#define _point       cTradeConst.point
#define _stopLevel   cTradeConst.stopLevel
#define _freezeLevel cTradeConst.freezeLevel
#define _digits      cTradeConst.digits
#ifdef __MQL5__
   #define _marginMode        cTradeConst.marginMode
   #define _executionMode     cTradeConst.executionMode
   #define _expirationMode    cTradeConst.expirationMode
   #define _fillingMode       cTradeConst.fillingMode
   #define _orderMode         cTradeConst.orderMode
#endif 

class CTradeConst
  {
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
#ifdef __MQL5__
   ENUM_ACCOUNT_MARGIN_MODE      marginMode;
   ENUM_SYMBOL_TRADE_EXECUTION   executionMode;
   int                           expirationMode;
   int                           fillingMode;
   int                           orderMode;
#endif   
public:
                     CTradeConst(string mSymbol=NULL):symbol(mSymbol==NULL?_Symbol:mSymbol){if (!Init()) delete GetPointer(this);}
private:
   bool              Init();
  };
bool CTradeConst::Init(void){
   if (!MQLInfoInteger(MQL_TESTER)&&!SymbolSelect(symbol,true)) return false;
   lotStep=SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);
   lotDigits=MathMax(-(int)MathFloor(MathLog10(lotStep)),0);
   lotMax=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);
   lotMin=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);
   point=SymbolInfoDouble(symbol,SYMBOL_POINT);
   tickSize=SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_SIZE);
   stopLevel=SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL)*point;
   freezeLevel=SymbolInfoInteger(symbol,SYMBOL_TRADE_FREEZE_LEVEL)*point;
   digits=(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);
#ifdef __MQL5__
   marginMode=(ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE);
   executionMode=(ENUM_SYMBOL_TRADE_EXECUTION)SymbolInfoInteger(symbol,SYMBOL_TRADE_EXEMODE);
   fillingMode=(int)SymbolInfoInteger(symbol,SYMBOL_FILLING_MODE);
   expirationMode=(int)SymbolInfoInteger(symbol,SYMBOL_EXPIRATION_MODE);
   orderMode=(int)SymbolInfoInteger(symbol,SYMBOL_ORDER_MODE);
#endif 
   return true;}
   
#endif 