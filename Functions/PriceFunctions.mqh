#ifndef _PRICE_FUNCTIONS_
#define _PRICE_FUNCTIONS_

#define ASK Ask()
#define BID Bid()
#define OPEN(i) iOpen(_Symbol,PERIOD_CURRENT,i)
#define CLOSE(i) iClose(_Symbol,PERIOD_CURRENT,i)
#define HIGH(i) iHigh(_Symbol,PERIOD_CURRENT,i)
#define LOW(i) iLow(_Symbol,PERIOD_CURRENT,i)
#define VOLUME(i) iVolume(_Symbol,PERIOD_CURRENT,i)
#define PRICE(direct) TradePrice(NULL,direct)
#define SPREAD Spread()

#ifdef __MQL5__
   #define VOLUME_R(i) iVolume(_Symbol,PERIOD_CURRENT,i)
   #define LAST Last()
#endif

double Ask(string fSymbol=NULL){return SymbolInfoDouble(fSymbol,SYMBOL_ASK);}
double Bid(string fSymbol=NULL){return SymbolInfoDouble(fSymbol,SYMBOL_BID);}
int Spread(string fSymbol=NULL){return (int)SymbolInfoInteger(fSymbol,SYMBOL_SPREAD);}
double TradePrice(string fSymbol,int fDirect){return !fDirect?0.0:fDirect>0?Ask(fSymbol):Bid(fSymbol);}

#ifdef __MQL5__
   double Last(string fSymbol=NULL){return SymbolInfoDouble(fSymbol,SYMBOL_LAST);}
#endif

#endif 