#ifndef _C_WRAPE_
#define _C_WRAPE_

template<typename T>
class CWrape{
protected:
   T     cValue;
public:
         CWrape():cValue(NULL){}
         CWrape(T mValue):cValue(mValue){}
         template<typename T1>
         CWrape(CWrape<T1> &mWrape):cValue(mWrape.Get()){}
   inline T Get() const {return cValue;}
   inline T  Set(T mVal)         {return cValue=mVal;}
   inline T operator =(T mVal)   {return cValue=mVal;}
   template<typename T1>
   inline T operator =(CWrape<T1> &mWrape)   {return cValue=_(mWrape);}
   inline bool operator ==(T mValue)   const {return cValue==mValue;}
   inline bool operator !()            const {return !cValue;}
   inline bool operator <(T mValue)    const {return cValue<mValue;}
   inline bool operator >(T mValue)    const {return cValue>mValue;}
   inline bool operator <=(T mValue)   const {return cValue<=mValue;}
   inline bool operator >=(T mValue)   const {return cValue>=mValue;}
   inline T operator ++()                    {return ++cValue;}
   inline T operator ++(int)                 {return cValue++;}
   inline T operator --()                    {return --cValue;}
   inline T operator --(int)                 {return cValue--;}
   inline T operator +=(T mValue)            {return cValue+=mValue;}
   inline T operator -=(T mValue)            {return cValue-=mValue;}
   inline T operator *=(T mValue)            {return cValue*=mValue;}
   inline T operator /=(T mValue)            {return cValue/=mValue;}
   inline T operator %=(T mValue)            {return cValue%=mValue;}   
};

#endif