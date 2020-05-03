#ifndef _C_MQL4_MA_
#define _C_MQL4_MA_

#include "CMQL4IndicatorBase.mqh"

class CMQL4MA:public CMQL4IndicatorBase<CMQL4MA>{
   uint                 cPeriod;
   int                  cShift;
   ENUM_MA_METHOD       cMethod;
   ENUM_APPLIED_PRICE   cPrice;
public:
   CMQL4MA(string mSymbol,ENUM_TIMEFRAMES mFrame,uint mPeriod,int mShift,ENUM_MA_METHOD mMethod,ENUM_APPLIED_PRICE mPrice):
      CMQL4IndicatorBase<CMQL4MA>(mSymbol==NULL?_Symbol:mSymbol,mFrame==PERIOD_CURRENT?(ENUM_TIMEFRAMES)_Period:mFrame),
      cPeriod(mPeriod),cShift(mShift),cMethod(mMethod),cPrice(mPrice){}
   CMQL4MA(uint mPeriod,int mShift,ENUM_MA_METHOD mMethod,ENUM_APPLIED_PRICE mPrice):
      CMQL4IndicatorBase<CMQL4MA>(_Symbol,(ENUM_TIMEFRAMES)_Period),
      cPeriod(mPeriod),cShift(mShift),cMethod(mMethod),cPrice(mPrice){}
   uint Period() const {return cPeriod;}
   int Shift() const {return cShift;}
   ENUM_MA_METHOD Method() const {return cMethod;}
   ENUM_APPLIED_PRICE AppliedPrice() const {return cPrice;}
   double Get(int mShift,uint mBufferNumber=0) const override;
};
//-------------------------------------------------------------------------------
double CMQL4MA::Get(int mShift,uint mBufferNumber=0) const{
   ResetLastError();
   double ret=iMA(cSymbol,cFrame,cPeriod,cShift,cMethod,cPrice,mShift);
   return !_LastError?ret:EMPTY_VALUE;}

#endif