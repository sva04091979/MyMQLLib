#ifndef _PRICE_FUNCTIONS_
#define _PRICE_FUNCTIONS_

#ifdef __MQL5__
   #define VOLUME_R(i) iVolume(_Symbol,PERIOD_CURRENT,i)
   #define LAST Last()
#endif

double Ask(string fSymbol){return SymbolInfoDouble(fSymbol,SYMBOL_ASK);}
double Bid(string fSymbol){return SymbolInfoDouble(fSymbol,SYMBOL_BID);}
int Spread(string fSymbol=NULL){return (int)SymbolInfoInteger(fSymbol,SYMBOL_SPREAD);}
double TradePrice(string fSymbol,int fDirect){return !fDirect?0.0:fDirect>0?Ask(fSymbol):Bid(fSymbol);}

double Price(int shift,ENUM_APPLIED_PRICE priceType) {return Price(NULL,PERIOD_CURRENT,priceType,shift);}
double Price(string symbol,ENUM_TIMEFRAMES frame,ENUM_APPLIED_PRICE priceType,int shift){
   switch(priceType){
      default:             return 0.0;
      case PRICE_CLOSE:    return iClose(symbol,frame,shift);
      case PRICE_OPEN:     return iOpen(symbol,frame,shift);
      case PRICE_HIGH:     return iHigh(symbol,frame,shift);
      case PRICE_LOW:      return iLow(symbol,frame,shift);
      case PRICE_MEDIAN:   return (iHigh(symbol,frame,shift)+iLow(symbol,frame,shift))/2.0;
      case PRICE_TYPICAL:  return (iHigh(symbol,frame,shift)+iLow(symbol,frame,shift)+iClose(symbol,frame,shift))/3.0;
      case PRICE_WEIGHTED: return (iHigh(symbol,frame,shift)+iLow(symbol,frame,shift)+2.0*iClose(symbol,frame,shift))/4.0;}}
double MinPrice(string symbol,ENUM_TIMEFRAMES frame,ENUM_APPLIED_PRICE priceType,int count=WHOLE_ARRAY,int startPos=0){
   int stopPos=count==WHOLE_ARRAY?iBars(symbol,frame):startPos+count;
   double res=Price(symbol,frame,priceType,startPos);
   while(++startPos<stopPos) res=MathMin(res,Price(symbol,frame,priceType,startPos));
   return res;}
double MaxPrice(string symbol,ENUM_TIMEFRAMES frame,ENUM_APPLIED_PRICE priceType,int count=WHOLE_ARRAY,int startPos=0){
   int stopPos=count==WHOLE_ARRAY?iBars(symbol,frame):startPos+count;
   double res=Price(symbol,frame,priceType,startPos);
   while(++startPos<stopPos) res=MathMax(res,Price(symbol,frame,priceType,startPos));
   return res;}
double MinPrice(ENUM_APPLIED_PRICE priceType,int count=WHOLE_ARRAY,int startPos=0) {return MinPrice(NULL,PERIOD_CURRENT,priceType,count,startPos);}
double MaxPrice(ENUM_APPLIED_PRICE priceType,int count=WHOLE_ARRAY,int startPos=0) {return MaxPrice(NULL,PERIOD_CURRENT,priceType,count,startPos);}

#ifdef __MQL5__
   double Last(string fSymbol=NULL){return SymbolInfoDouble(fSymbol,SYMBOL_LAST);}
#else
#endif

#endif 