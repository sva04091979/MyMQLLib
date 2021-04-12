#ifndef _STD_CHART_
#define _STD_CHART_

#include "..\Define\StdDefine.mqh"
#include "Symbol.mqh"

#define tChart __std(CChart)
#define tdeclChart __decl(CChart)

NAMESPACE(STD)

class tdeclChart{
   datetime cLastTime;
   const tdeclSymbol* cSymbol;
   ENUM_TIMEFRAMES cFrame;
   int cCountFromLastCheckedBar;
   bool cIsSymbolControl;
public:
   tdeclChart()   {Init(new tdeclSymbol(),PERIOD_CURRENT,true);}
   tdeclChart(string symbol)  {Init(new tdeclSymbol(symbol),PERIOD_CURRENT,true);}
   tdeclChart(const tdeclSymbol &symbol) {Init(&symbol,PERIOD_CURRENT,false);}
   tdeclChart(ENUM_TIMEFRAMES frame) {Init(new tdeclSymbol(),frame,true);}
   tdeclChart(string symbol,ENUM_TIMEFRAMES frame) {Init(new tdeclSymbol(symbol),frame,true);}
   tdeclChart(const tdeclSymbol &symbol,ENUM_TIMEFRAMES frame) {Init(&symbol,PERIOD_CURRENT,false);}
  ~tdeclChart() {if (cIsSymbolControl) DEL(cSymbol);}
   bool IsNewBar();
   int CountFromLastCheckedBar() const {return cCountFromLastCheckedBar;}
   int BarShift(datetime time) const {return cSymbol.BarShift(time);}
   void SetFirstCheckNotNewBar();
private:
   void Init(const tdeclSymbol* symbol,ENUM_TIMEFRAMES frame,bool isSymbolControl);
};
//--------------------------------------------------------
void tdeclChart::Init(const tdeclSymbol* symbol,ENUM_TIMEFRAMES frame,bool isSymbolControl){
   cSymbol=symbol;
   cFrame=frame;
   cIsSymbolControl=isSymbolControl;
   cLastTime=0;
   cCountFromLastCheckedBar=-1;
}
//--------------------------------------------------------------------
void tdeclChart::SetFirstCheckNotNewBar(){
   if (!cLastTime) cLastTime=TimeCurrent();
}
//--------------------------------------------------------------------
bool tdeclChart::IsNewBar(){
   datetime time=cSymbol.Time(cFrame);
   if (time>cLastTime){
      cCountFromLastCheckedBar=!cLastTime?-1:cSymbol.BarShift(cLastTime);
      cLastTime=time;
      return true;
   }
   else return false;
}

END_SPACE

#endif