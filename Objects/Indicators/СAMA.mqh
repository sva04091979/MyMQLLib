#ifndef _C_AMA_
#define _C_AMA_

#include "..\..\Functions\MathFunctions.mqh"
#include "СIndicatorBase.mqh"

class CAMA : public CIndicatorBase
  {
private:
   int                 cAMAPeriod;
   int                 cFastEMAPeriod;
   int                 cSlowEMAPeriod;
   int                 cAMAShift;
   ENUM_APPLIED_PRICE  cAppliedPrice;
public:
                     CAMA(string mSymbol,ENUM_TIMEFRAMES mPeriod,int mAMAPeriod,int mFastEMAPeriod,int mSlowEMAPeriod,int mAMAShift,ENUM_APPLIED_PRICE mAppliedPrice,int mBufferSize=0);
   double            Get(int mPos,bool mIsCheck=true) {return GetBuffer(0,mPos,mIsCheck);}
   int               Equal(double mPrice,int mPos) {return !CheckBuffer()?INT_MAX:CompareDouble(Get(mPos,false),mPrice,cDigits);}
   double operator[](int mPos)   {return GetBuffer(0,mPos,true);}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAMA::CAMA(string mSymbol,ENUM_TIMEFRAMES mPeriod,int mAMAPeriod,int mFastEMAPeriod,int mSlowEMAPeriod,int mAMAShift,ENUM_APPLIED_PRICE mAppliedPrice,int mBufferSize=0):
   CIndicatorBase(iAMA(mSymbol,mPeriod,mAMAPeriod,mFastEMAPeriod,mSlowEMAPeriod,mAMAShift,mAppliedPrice),mSymbol,mPeriod,1,mBufferSize),
   cAMAPeriod(mAMAPeriod),cFastEMAPeriod(mFastEMAPeriod),
   cSlowEMAPeriod(mSlowEMAPeriod),cAMAShift(mAMAShift),cAppliedPrice(mAppliedPrice){}
//+------------------------------------------------------------------+

#endif