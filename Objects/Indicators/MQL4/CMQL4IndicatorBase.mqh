#ifndef _C_MQL4_INDICATOR_BASE_
#define _C_MQL4_INDICATOR_BASE_

template<typename T>
class CMQL4IndicatorBase{
protected:
   string            cSymbol;
   ENUM_TIMEFRAMES   cFrame;
private:
   uint              cBuf;
protected:
   CMQL4IndicatorBase(string mSymbol,ENUM_TIMEFRAMES mFrame):
      cSymbol(mSymbol),cFrame(mFrame){}
public:
   string Symbol() const {return cSymbol;}
   ENUM_TIMEFRAMES TimeFrame() const {return cFrame;}
   virtual double Get(int mShift,uint mBufferNumber)const =0;
   double operator[](int mShift) const {return Get(mShift,cBuf);}
   T* b(uint mBufferNumber) {cBuf=mBufferNumber; return &this;}
};

#endif