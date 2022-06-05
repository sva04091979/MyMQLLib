#ifndef _STD_C_WRAPE_
#define _STD_C_WRAPE_

#include "..\Define\StdDefine.mqh"

#define _tWrape __std(CWrape)
#define _tNumeric __std(CWrapeNumeric)
#define _tReference __std(CWrapeRefer)
#define _tCounter _tNumeric<_tSizeT>

#define _tdeclWrape __decl(CWrape)
#define _tdeclNumeric __decl(CWrapeNumeric)
#define _tdeclReference __decl(CWrapeRefer)

NAMESPACE(STD)

template<typename T,typename Type>
class _tdeclWrape{
protected:
   T     cValue;
protected:
         _tdeclWrape(){}
public: 
   Type* const Set(const Type &mVal) {cValue=_(mVal); return &this;}
   Type* const This()   {return (Type*)&this;}
   T Get() const {return cValue;}
   T Dereference() const {return cValue;}
   T operator =(const Type &mVal)   {cValue=_(mVal); return cValue;}
};
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
template<typename T>
class _tdeclNumeric:public _tdeclWrape<T,_tdeclNumeric<T>>{
public:
         _tdeclNumeric():_tdeclWrape<T,_tdeclNumeric<T>>(){}
         _tdeclNumeric(T mValue):_tdeclWrape<T,_tdeclNumeric<T>>(){cValue=mValue;}
         _tdeclNumeric(const _tdeclNumeric<T> &mWrape):_tdeclWrape<T,_tdeclNumeric<T>>(){cValue=_(mWrape);}
   _tdeclNumeric<T>* const Set(T mVal)                      {cValue=mVal; return &this;}
   bool operator !()                                  const {return !cValue;}
   bool operator ==(T mValue)                         const {return cValue==mValue;}
   bool operator ==(const _tdeclNumeric<T> &mValue)   const {return cValue==_(mValue);}
   bool operator <(T mValue)                          const {return cValue<mValue;}
   bool operator <(const _tdeclNumeric<T> &mValue)    const {return cValue<_(mValue);}
   bool operator >(T mValue)                          const {return cValue>mValue;}
   bool operator >(const _tdeclNumeric<T> &mValue)    const {return cValue>_(mValue);}
   bool operator <=(T mValue)                         const {return cValue<=mValue;}
   bool operator <=(const _tdeclNumeric<T> &mValue)   const {return cValue<=_(mValue);}
   bool operator >=(T mValue)                         const {return cValue>=mValue;}
   bool operator >=(const _tdeclNumeric<T> &mValue)   const {return cValue>=_(mValue);}
   T operator =(T mVal)                                     {return cValue=mVal;}
   T operator ++()                                          {return ++cValue;}
   T operator ++(int)                                       {return cValue++;}
   T operator --()                                          {return --cValue;}
   T operator --(int)                                       {return cValue--;}
   T operator +=(T mValue)                                  {return cValue+=mValue;}
   T operator +=(const _tdeclNumeric<T> &mValue)            {return cValue+=_(mValue);}
   T operator -=(T mValue)                                  {return cValue-=mValue;}
   T operator -=(const _tdeclNumeric<T> &mValue)            {return cValue-=_(mValue);}
   T operator *=(T mValue)                                  {return cValue*=mValue;}
   T operator *=(const _tdeclNumeric<T> &mValue)            {return cValue*=_(mValue);}
   T operator /=(T mValue)                                  {return cValue/=mValue;}
   T operator /=(const _tdeclNumeric<T> &mValue)            {return cValue/=_(mValue);}
   T operator %=(T mValue)                                  {return Remainder(cValue,mValue);} 
   T operator %=(const _tdeclNumeric<T> &mValue)            {return Remainder(cValue,_(mValue));}
private:
   T Remainder(T &mRes,T mVal);
};
//-------------------------------------------------------------------------------------------
template<typename T>
T _tdeclNumeric::Remainder(T &mRes,T mVal){
   long res=long(mRes/mVal);
   return mRes-=T(res*mVal);
}
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
template<typename T>
class _tdeclReference:public _tdeclWrape<T,_tdeclReference<T>>{
public:
         _tdeclReference(){}
         _tdeclReference(const T &mValue) {cValue=mValue;}
         _tdeclReference(const _tdeclReference<T> &mWrape) {cValue=_(mWrape);}
   _tdeclReference<T>* const Set(const T &mVal)             {cValue=mVal; return &this;}     
   T operator =(const T &mVal)                              {cValue=mVal; return cValue;}
};

END_SPACE

#endif