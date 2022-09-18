#ifndef _STD_SYMBOL_
#define _STD_SYMBOL_

#include "..\Define\StdDefine.mqh"

#define tSymbol __std(CSymbol)
#define tdeclSymbol __decl(CSymbol)

NAMESPACE(STD)

class tdeclSymbol{
   string cSymbol;
public:
   tdeclSymbol():cSymbol(NULL){}
   tdeclSymbol(string symbol):cSymbol(symbol){}
   datetime Time() const {return Time(0,PERIOD_CURRENT);}
   datetime Time(int shift) const {return Time(shift,PERIOD_CURRENT);}
   datetime Time(ENUM_TIMEFRAMES frame) const {return Time(0,frame);}
   #ifdef __MQL5__
      datetime Time(int shift,ENUM_TIMEFRAMES frame) const {return iTime(cSymbol,frame,shift);}
   #else
      datetime Time(int shift,ENUM_TIMEFRAMES frame) const {return iTime(cSymbol,shift,frame);}
   #endif
   int BarShift(datetime time,ENUM_TIMEFRAMES frame=PERIOD_CURRENT) const {return BarShift(time,frame,false);}
   int BarShiftStrong(datetime time,ENUM_TIMEFRAMES frame=PERIOD_CURRENT) const {return BarShift(time,frame,false);}
   int BarShift(datetime time,ENUM_TIMEFRAMES frame,bool exact) const {return iBarShift(cSymbol,frame,time,exact);}
};

END_SPACE

#endif