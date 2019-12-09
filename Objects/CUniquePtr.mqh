#ifndef _C_UNIQUE_PTR_
#define _C_UNIQUE_PTR_

#include <MyMQLLib\Functions\MathFunctions.mqh>

template<typename T>
class CUniquePtr
{
   T*    cObj;
public:
   CUniquePtr():cObj(NULL){}
   CUniquePtr(T* mObj):cObj(Move(mObj)){}
  ~CUniquePtr()   {delete cObj;}
   bool IsValid() {return CheckPointer(cObj)!=POINTER_INVALID;}
   T* Move()   {return Move(cObj);}
   void operator =(T* mObj)   {cObj=Move(mObj);}
   void operator =(CUniquePtr<T> &mPtr) {cObj=mPtr.Move();}
};

#endif