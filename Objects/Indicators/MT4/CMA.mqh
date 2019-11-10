#ifndef _C_MA_
#define _C_MA_

#define GET_MA(dShift) {ResetLastError(); double res=iMA(cSymbol,cFrame,cPeriod,cShift,cMethod,cAppliedPrice,dShift); return !_LastError?res:0.0;}

class CMA{
   string               cSymbol;
   int                  cPeriod;
   int                  cShift;
   ENUM_TIMEFRAMES      cFrame;
   ENUM_MA_METHOD       cMethod;
   ENUM_APPLIED_PRICE   cAppliedPrice;
public:
                        CMA(string mSymbol,ENUM_TIMEFRAMES mFrame,int mPeriod,int mShift,ENUM_MA_METHOD mMethod,ENUM_APPLIED_PRICE mAppliedPrice):
                           cSymbol(mSymbol),cPeriod(mPeriod),cShift(mShift),cFrame(mFrame),cMethod(mMethod),cAppliedPrice(mAppliedPrice){}
   string               GetSymbol() {return cSymbol==NULL?_Symbol:cSymbol;}
   int                  GetPeriod() {return cPeriod;}
   int                  GetShift()  {return cShift;}
   ENUM_TIMEFRAMES      GetFrame()  {return cFrame==PERIOD_CURRENT?_Period:cFrame;}
   ENUM_MA_METHOD       GetMethod() {return cMethod;}
   ENUM_APPLIED_PRICE   GetAppliedPrice() {return cAppliedPrice;}
   void                 SetSymbol(string mSymbol) {cSymbol=mSymbol;}
   void                 SetPeriod(int mPeriod) {cPeriod=mPeriod;}
   void                 SetShift(int mShift)  {cShift=mShift;}
   void                 SetFrame(ENUM_TIMEFRAMES mFrame)  {cFrame=mFrame;}
   void                 SetMethod(ENUM_MA_METHOD mMethod) {cMethod=mMethod;}
   void                 SetAppliedPrice(ENUM_APPLIED_PRICE mAppliedPrice) {cAppliedPrice=mAppliedPrice;}
   double               Get(int mShift) GET_MA(mShift)
   double operator [](int mShift) GET_MA(mShift)
};

#endif