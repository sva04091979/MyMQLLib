#ifndef _C_MA_
#define _C_MA_

#include <MyMQLLib\Objects\CFlag.mqh>

#define CMA_FLAG_PERIOD_CURRENT  0x1

class CMA{
   string               cSymbol;
   int                  cPeriod;
   int                  cShift;
   ENUM_TIMEFRAMES      cFrame;
   ENUM_MA_METHOD       cMethod;
   ENUM_APPLIED_PRICE   cAppliedPrice;
   CFlag                cFlag;
public:
                        CMA(string mSymbol,ENUM_TIMEFRAMES mFrame,int mPeriod,int mShift,ENUM_MA_METHOD mMethod,ENUM_APPLIED_PRICE mAppliedPrice):
                           cSymbol(mSymbol),cPeriod(mPeriod),cShift(mShift),cFrame(mFrame),cMethod(mMethod),cAppliedPrice(mAppliedPrice),
                           cFlag(!mPeriod?CMA_FLAG_PERIOD_CURRENT:0){}
   void                 Restart(string mSymbol,ENUM_TIMEFRAMES mFrame,int mPeriod,int mShift,ENUM_MA_METHOD mMethod,ENUM_APPLIED_PRICE mAppliedPrice);
   string               GetSymbol() {return cSymbol==NULL?_Symbol:cSymbol;}
   int                  GetPeriod() {return cPeriod;}
   int                  GetShift()  {return cShift;}
   ENUM_TIMEFRAMES      GetFrame()  {return cFrame==PERIOD_CURRENT?(ENUM_TIMEFRAMES)_Period:cFrame;}
   ENUM_MA_METHOD       GetMethod() {return cMethod;}
   ENUM_APPLIED_PRICE   GetAppliedPrice() {return cAppliedPrice;}
   void                 SetSymbol(string mSymbol) {cSymbol=mSymbol;}
   void                 SetPeriod(int mPeriod) {cPeriod=mPeriod; if (!cPeriod) cFlag+=CMA_FLAG_PERIOD_CURRENT; else cFlag-=CMA_FLAG_PERIOD_CURRENT;}
   void                 SetShift(int mShift)  {cShift=mShift;}
   void                 SetFrame(ENUM_TIMEFRAMES mFrame)  {cFrame=mFrame;}
   void                 SetMethod(ENUM_MA_METHOD mMethod) {cMethod=mMethod;}
   void                 SetAppliedPrice(ENUM_APPLIED_PRICE mAppliedPrice) {cAppliedPrice=mAppliedPrice;}
   inline double        Get(int mShift)                        {return Get(mShift,cFlag.Check(CMA_FLAG_PERIOD_CURRENT)?false:true);}
   inline double        Get(int mShift,bool mIsCheckHistory)   {return mIsCheckHistory?_GetWhithCheck(mShift):_iMA(mShift);}
   double operator [](int mShift) {return Get(mShift);}
private:
   inline double        _GetWhithCheck(int mShift);
   inline double        _iMA(int mShift) {return iMA(cSymbol,cFrame,cPeriod,cShift,cMethod,cAppliedPrice,mShift);}
};
//----------------------------------------------------------------------------------------------
void CMA::Restart(string mSymbol,ENUM_TIMEFRAMES mFrame,int mPeriod,int mShift,ENUM_MA_METHOD mMethod,ENUM_APPLIED_PRICE mAppliedPrice){
   cSymbol=mSymbol;
   cPeriod=mPeriod;
   cShift=mShift;
   cFrame=mFrame;
   cMethod=mMethod;
   cAppliedPrice=mAppliedPrice;
   if (mPeriod) cFlag-=CMA_FLAG_PERIOD_CURRENT;
   else cFlag+=CMA_FLAG_PERIOD_CURRENT;}
//----------------------------------------------------------------------------------------------
double CMA::_GetWhithCheck(int mShift){
   ResetLastError();
   double res=_iMA(mShift);
   return !_LastError?res:0.0;}

#undef CMA_FLAG_PERIOD_CURRENT

#endif