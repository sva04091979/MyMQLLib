#ifndef _C_WRAPE_
#define _C_WRAPE_

#include "IWrape.mqh"

template<typename T>
class CWrape{
public:
   T     cValue;
         CWrape():cValue(NULL){}
         CWrape(T mValue):cValue(mValue){}
         template<typename T1>
         CWrape(CWrape<T1> &mWrape):cValue(mWrape.Get()){}
   T     Get() {return cValue;}
   void  Set(T mVal) {cValue=mVal;}
   void operator =(T mVal) {cValue=mVal;}
   template<typename T1>
   void operator =(CWrape<T1> &mWrape) {cValue=mWrape.Get();}
};

#endif