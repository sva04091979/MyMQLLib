#ifndef _C_CONVERT_
#define _C_CONVERT_

#include "..\..\Functions\PriceFunctions.mqh"


class CConvert
  {
protected:
   string            cSymbol;
   string            cAccCurrency;
   string            cCurrency[2];
   int               cPow[2];
   double            cLotSize;
   double            cTickSize;
   double            cPoint;
public:
                     CConvert(string mSymbol=NULL);
   void              Reset(string mSymbol=NULL);
   double            GetPointPrice(int mCount=1);
private:
   void              ComputeParam();
   bool              OneStepCross(string mProfit,string mBase,string mPrefix,string mSuffix);
   bool              FindCross(string mProfit,string mBase,string mPrefix,string mSuffix);
  };
//-----------------------------------------------------------
CConvert::CConvert(string mSymbol=NULL):cSymbol(mSymbol==NULL?_Symbol:mSymbol),cAccCurrency(AccountInfoString(ACCOUNT_CURRENCY)),
                                        cLotSize(SymbolInfoDouble(mSymbol,SYMBOL_TRADE_CONTRACT_SIZE)),
                                        cTickSize(SymbolInfoDouble(mSymbol,SYMBOL_TRADE_TICK_SIZE)),
                                        cPoint(SymbolInfoDouble(mSymbol,SYMBOL_POINT)){
   ComputeParam();}
//-------------------------------------------------------------
void CConvert::Reset(string mSymbol=NULL){
   cSymbol=mSymbol==NULL?_Symbol:mSymbol;
   cAccCurrency=AccountInfoString(ACCOUNT_CURRENCY);
   cLotSize=SymbolInfoDouble(mSymbol,SYMBOL_TRADE_CONTRACT_SIZE);
   cTickSize=SymbolInfoDouble(mSymbol,SYMBOL_TRADE_TICK_SIZE);
   cPoint=SymbolInfoDouble(mSymbol,SYMBOL_POINT);
   ComputeParam();}
//-------------------------------------------------------------
double CConvert::GetPointPrice(int mCount=1){
   double tickValue=SymbolInfoDouble(cSymbol,SYMBOL_TRADE_TICK_VALUE);
   if (!cTickSize) cTickSize=SymbolInfoDouble(cSymbol,SYMBOL_TRADE_TICK_SIZE);
   if (!cPoint) cPoint=SymbolInfoDouble(cSymbol,SYMBOL_POINT);
   if (tickValue!=0.0&&cTickSize!=0.0&&cPoint!=0.0) return mCount*tickValue*cPoint/cTickSize;
   if (!cPow[0]) return cLotSize*mCount*cPoint;
   double res=MathPow(Bid(cCurrency[0]),cPow[0]);
   if (!cPow[1]) return res*mCount;
   else return mCount*res*MathPow(Bid(cCurrency[1]),cPow[1]);}
//--------------------------------------------------------------
void CConvert::ComputeParam(void){
   cCurrency[0]=cCurrency[1]=NULL;
   ArrayInitialize(cPow,0);
   string profit=SymbolInfoString(cSymbol,SYMBOL_CURRENCY_PROFIT),
          base=SymbolInfoString(cSymbol,SYMBOL_CURRENCY_BASE),
          symbol=base+profit;
   int pos=StringFind(cSymbol,symbol);
   string prefix=pos==0?NULL:StringSubstr(cSymbol,0,pos),
          suffix=(pos+=StringLen(symbol))==StringLen(cSymbol)?NULL:StringSubstr(cSymbol,pos);
   if (cAccCurrency==profit   ||
       (!OneStepCross(profit,base,prefix,suffix)
        &&!FindCross("USD",profit,prefix,suffix)
        &&!FindCross("EUR",profit,prefix,suffix))) return;}
//---------------------------------------------------------------
bool CConvert::OneStepCross(string mProfit,string mBase,string mPrefix,string mSuffix){
   string name=mPrefix+mProfit+cAccCurrency+mSuffix;
   if (SymbolSelect(name,true)){
      cCurrency[0]=name;
      cPow[0]=1;
      return true;}
   else if (SymbolSelect(name=mPrefix+cAccCurrency+mProfit+mSuffix,true)){
      cCurrency[0]=name;
      cPow[0]=-1;
      return true;}
   else if (SymbolSelect(name=mPrefix+mBase+cAccCurrency+mSuffix,true)){
      cCurrency[0]=cSymbol;   cCurrency[1]=name;
      cPow[0]=-1;             cPow[1]=1;
      return true;}
   else if (SymbolSelect(name=mPrefix+cAccCurrency+mBase+mSuffix,true)){
      cCurrency[0]=cSymbol;   cCurrency[1]=name;
      cPow[0]=-1;             cPow[1]=-1;
      return true;}
   else return false;}
//--------------------------------------------------------------------
bool CConvert::FindCross(string mCross,string mProfit,string mPrefix,string mSuffix){
   string name=mPrefix+mCross+cAccCurrency+mSuffix,
          temp=name;
   if (!SymbolSelect(name,true)&&!SymbolSelect(name=mPrefix+cAccCurrency+mCross+mSuffix,true)) return false;
   cCurrency[1]=name;
   cPow[1]=name==temp?1:-1;
   temp=mProfit+mCross;
   if (!SymbolSelect(name=temp,true)&&!SymbolSelect(name=mPrefix+mCross+mProfit+mSuffix,true)) return false;
   cCurrency[0]=name;
   cPow[0]=name==temp?1:-1;
   return true;}
   
#endif