#include "../Define/StdDefine.mqh"

#ifndef _STD_F_TRADE_
#define _STD_F_TRADE_

#include "TradeDefine.mqh"

#define _tFTrade STD_FTrade

class STD_FTrade{
public:
   static double TradePrice(string symbol,_tEDirect direct) {return direct==_eNo?0.0:direct==_eUp?SymbolInfoDouble(symbol,SYMBOL_ASK):SymbolInfoDouble(symbol,SYMBOL_BID);}
};

#endif