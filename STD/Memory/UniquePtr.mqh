#ifndef _STD_S_UNIQUE_PTR_
#define _STD_S_UNIQUE_PTR_

#include <STD\Define\StdDefine.mqh>

#define _tUniquePtr __std(SUniquePtr)

#define _tdeclUniquePtr __decl(SUniquePtr)

NAMESPACE(STD)

template<typename T>
struct _tdeclUniquePtr{
protected:
   T* cPtr;
public:
   _tdeclUniquePtr():cPtr(NULL){}
   _tdeclUniquePtr(T* &obj):cPtr(obj){obj=NULL;}
   _tdeclUniquePtr(_tdeclUniquePtr<T> &other):cPtr(other.Move()){}
  ~_tdeclUniquePtr() {delete cPtr;}
   template<typename T1>
   _tdeclUniquePtr<T1> StaticCast() {_tdeclUniquePtr<T1> ret((T1*)cPtr); cPtr=NULL; return ret;}
   template<typename T1>
   _tdeclUniquePtr<T1> DynamicCast() {_tdeclUniquePtr<T1> ret(dynamic_cast<T1*>(cPtr)); cPtr=NULL; return ret;}
   T* Dereference() {return cPtr;}
   T* Get()         {return cPtr;}
   void Free()      {DELETE(cPtr);}
   T* Move()        {T* ret=cPtr; cPtr=NULL; return ret;}
   void operator =(_tdeclUniquePtr<T> &other);
   void operator =(T* &ptr);
   bool operator !() {return !cPtr;}
};
//--------------------------------------------------------------------------
template<typename T>
void _tdeclUniquePtr::operator =(_tdeclUniquePtr<T> &other){
   DEL(cPtr);
   cPtr=other.Move();
}
//--------------------------------------------------------------------------
template<typename T>
void _tdeclUniquePtr::operator =(T* &ptr){
   DEL(cPtr);
   cPtr=ptr;
   ptr=NULL;
}

template<typename T>
T* _fdeclMove(_tdeclUniquePtr<T> &ptr) {return ptr.Move();}

template<typename T>
_tdeclUniquePtr<T> Copy(_tdeclUniquePtr<T> &fPtr){
   return _tdeclUniquePtr<T>(new T(_(fPtr)));
}

END_SPACE

#endif