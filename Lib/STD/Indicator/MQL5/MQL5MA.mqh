#include "..\..\Define\StdDefine.mqh"

#ifndef _STD_INDICATOR_MA_
#define _STD_INDICATOR_MA_

#define _tMA __std(MQL5_MA)
#define _tMAData __std(MAData)

#include "CMQL5IndicatorBase.mqh"

class _tMAData:public _tIndicatorSingleData<_tMAData>{
public:
   _tMAData(int hndl):_tIndicatorSingleData<_tMAData>(hndl){}
};

class _tMA:public _tIndicatorOneBuffer<_tMAData>{
   int                 cMAPeriod;
   int                 cMAShift;
   ENUM_MA_METHOD      cMAMethod;
   ENUM_APPLIED_PRICE  cAppliedPrice;
public:
   _tMA(string mSymbol,ENUM_TIMEFRAMES mFrame,int mPeriod,
        int mShift=0,
        ENUM_MA_METHOD mMethod=MODE_SMA,
        ENUM_APPLIED_PRICE mAppliedPrice=PRICE_CLOSE);
   _tMA(int mPeriod,
        int mShift=0,
        ENUM_MA_METHOD mMethod=MODE_SMA,
        ENUM_APPLIED_PRICE mAppliedPrice=PRICE_CLOSE);
   int Period() const   {return cMAPeriod;}
   int Shift() const    {return cMAShift;}
   ENUM_MA_METHOD Method() const {return cMAMethod;}
   ENUM_APPLIED_PRICE AppliedPrice() const {return cAppliedPrice;}
};
//----------------------------------------------------------------
_tMA::_tMA(string mSymbol,ENUM_TIMEFRAMES mFrame,int mPeriod,int mShift,ENUM_MA_METHOD mMethod, ENUM_APPLIED_PRICE mAppliedPrice):
   _tIndicatorOneBuffer<_tMAData>(iMA(mSymbol,mFrame,mPeriod,mShift,mMethod,mAppliedPrice),
                                  mSymbol,
                                  mFrame),
   cMAPeriod(mPeriod),
   cMAShift(mShift),
   cMAMethod(mMethod),
   cAppliedPrice(mAppliedPrice){}
//----------------------------------------------------------------
_tMA::_tMA(int mPeriod,int mShift,ENUM_MA_METHOD mMethod, ENUM_APPLIED_PRICE mAppliedPrice):
   _tIndicatorOneBuffer<_tMAData>(iMA(_Symbol,PERIOD_CURRENT,mPeriod,mShift,mMethod,mAppliedPrice),
                                  _Symbol,
                                  PERIOD_CURRENT),
   cMAPeriod(mPeriod),
   cMAShift(mShift),
   cMAMethod(mMethod),
   cAppliedPrice(mAppliedPrice){}        

#endif