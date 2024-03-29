#ifndef _C_MQL5_MA_
#define _C_MQL5_MA_

#include "CMQL5IndicatorBase.mqh"

class CMQL5MA:public CMQL5IndicatorBase{
   uint                 cMAPeriod;
   int                 cMAShift;
   ENUM_MA_METHOD      cMAMethod;
   ENUM_APPLIED_PRICE  cAppliedPrice;
public:
   CMQL5MA(string mSymbol,ENUM_TIMEFRAMES mFrame,int mPeriod,int mShift,ENUM_MA_METHOD mMethod,ENUM_APPLIED_PRICE mAppliedPrice);
   CMQL5MA(int mPeriod,int mShift,ENUM_MA_METHOD mMethod,ENUM_APPLIED_PRICE mAppliedPrice);
   int Shift() const {return cMAShift;}
   //double operator[](int mPos) {return cBuffers[0][mPos];}
   void ChangeParam(string mSymbol,ENUM_TIMEFRAMES mFrame,uint mPeriod,int mShift,ENUM_MA_METHOD mMethod,ENUM_APPLIED_PRICE mPrice);
};
//----------------------------------------------------------------
CMQL5MA::CMQL5MA(string mSymbol,ENUM_TIMEFRAMES mFrame,int mPeriod,int mShift,ENUM_MA_METHOD mMethod, ENUM_APPLIED_PRICE mAppliedPrice):
   CMQL5IndicatorBase(iMA(mSymbol,mFrame,mPeriod,mShift,mMethod,mAppliedPrice),
                      mSymbol,mFrame,1),
   cMAPeriod(mPeriod),
   cMAShift(mShift),
   cMAMethod(mMethod),
   cAppliedPrice(mAppliedPrice){}
//-------------------------------------------------------------------------------
void CMQL5MA::ChangeParam(string mSymbol,ENUM_TIMEFRAMES mFrame,uint mPeriod,int mShift,ENUM_MA_METHOD mMethod,ENUM_APPLIED_PRICE mPrice){
   CMQL5IndicatorBase::ChangeParam(iMA(mSymbol,mFrame,mPeriod,mShift,mMethod,mPrice),
                      mSymbol,mFrame);
   cMAPeriod=mPeriod;
   cMAShift=mShift;
   cMAMethod=mMethod;
   cAppliedPrice=mPrice;
}                 
//----------------------------------------------------------------
CMQL5MA::CMQL5MA(int mPeriod,int mShift,ENUM_MA_METHOD mMethod, ENUM_APPLIED_PRICE mAppliedPrice):
   CMQL5IndicatorBase(iMA(_Symbol,PERIOD_CURRENT,mPeriod,mShift,mMethod,mAppliedPrice),
                      _Symbol,PERIOD_CURRENT,1),
   cMAPeriod(mPeriod),
   cMAShift(mShift),
   cMAMethod(mMethod),
   cAppliedPrice(mAppliedPrice){}                   
#endif