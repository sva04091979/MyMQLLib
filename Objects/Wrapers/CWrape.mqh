#ifndef _C_WRAPE_
#define _C_WRAPE_

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
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
template<typename T>
class CWrapeS:public CWrape<T>
{
public:
   bool operator <(T mValue) {return cValue<mValue;}
   bool operator >=(T mValue) {return cValue>=mValue;}
   bool operator !() {return !cValue;}
   T operator ++()   {return ++cValue;}
   T operator ++(int){return cValue++;}
   T operator --()   {return --cValue;}
   T operator --(int){return cValue--;}
   
};

#endif