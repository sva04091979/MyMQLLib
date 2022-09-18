#ifndef _STD_S_SHARED_PTR_
#define _STD_S_SHARED_PTR_

#include "..\Define\StdDefine.mqh"
#include "Wrape.mqh"

#define _tSharedPtr __std(SSharedPtr)
#define _tdeclSharedPtr __decl(SSharedPtr)

NAMESPACE(STD)

template<typename T>
struct _tdeclSharedPtr{
protected:
   T* cObject;
   _tCounter* cCount;
public:
   _tdeclSharedPtr():cObject(NULL),cCount(NULL){}
   _tdeclSharedPtr(T* obj):cObject(obj),cCount(!obj?NULL:new _tCounter(1)){}
   _tdeclSharedPtr(T* obj,_tCounter* _count):cObject(obj),cCount(!obj?NULL:_count){if (cCount!=NULL) ++cCount;}
   _tdeclSharedPtr(_tdeclSharedPtr<T> &other);
  ~_tdeclSharedPtr() {if (cCount!=NULL&&!--cCount) {DEL(cObject); DEL(cCount);}}
   template<typename T1>
   _tdeclSharedPtr<T1> StaticCast() {_tdeclSharedPtr<T1> ret((T1*)cObject,cCount); return ret;}
   template<typename T1>
   _tdeclSharedPtr<T1> DynamicCast() {_tdeclSharedPtr<T1> ret(dynamic_cast<T1*>(cObject),cCount); return ret;}
   T* Dereference() {return cObject;}
   T* Get()         {return cObject;}
   void Free();
   void operator =(_tdeclSharedPtr<T> &other);
   void operator =(T* ptr);
   _tSizeT Count() {return !cCount?0:_(cCount);}
   bool operator !() {return !cObject;}
};
//--------------------------------------------------------------------------
template<typename T>
_tdeclSharedPtr::_tdeclSharedPtr(_tdeclSharedPtr<T> &other){
   cObject=other.cObject;
   cCount=other.cCount;
   if (cCount!=NULL) ++cCount;}
//--------------------------------------------------------------------------
template<typename T>
void _tdeclSharedPtr::Free(){
   if (!cCount) return;
   if (!--cCount){DEL(cObject); DEL(cCount);}
   cObject=NULL;
   cCount=NULL;}
//--------------------------------------------------------------------------
template<typename T>
void _tdeclSharedPtr::operator =(_tdeclSharedPtr<T> &other){
   if (cObject==_(other)) return;
   if (cCount!=NULL&&!--cCount) {delete cObject; delete cCount;}
   cObject=other.cObject;
   cCount=other.cCount;
   if (cCount!=NULL) ++cCount;
}
//--------------------------------------------------------------------------
template<typename T>
void _tdeclSharedPtr::operator =(T* ptr){
   if (cObject==ptr) return;
   if (cCount!=NULL&&!--cCount) {DEL(cObject); DEL(cCount);}
   cObject=ptr;
   cCount=!ptr?NULL:new _tCounter(1);
}

END_SPACE

#endif