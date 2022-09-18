#include "CPosition.mqh"


#define FLAG_CONST_CREATE_HEAR   0x1

class CExample{
   TRADE_CONST_DEF;
   int cFlag;
                  CExample(string mSymbol,CTradeConst* mTradeConst):
                     TRADE_CONST(!CheckPointer(mTradeConst)?new CTradeCons(mSymbol)t:mTradeConst)
                     {if (!CheckPointer(mTradeConst)) cFlag|=FLAG_CONST_CREATE_HEAR;}
                 ~CExample()  {if (bool(cFlag&FLAG_CONST_CREATE_HEAR)) delete TRADE_CONST;}
};

CTradeConst* tradeConst=new CTradeConst;
CExampe* exsample[10];
for (int i=0;i<10;example[i++]=new CExample(_Symbol,tradeConst));


