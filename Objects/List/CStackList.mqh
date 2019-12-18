#ifndef _C_STACK_
#define _C_STACK_

#include "CListBase.mqh"

#define Iterator CIteratorBack<T>

template<typename T>
class CStack:public CListBase<T,Iterator>
  {
public:
            ~CStack() {while(NULL!=(cFlag.Check(_LIST_NO_DELETABLE_)?Erase():Delete()));}
   inline T* Peek()  {return !cBack?NULL:cBack.Get();}
   inline T* Pop();
   inline T* Delete();
   inline T* Erase();
protected:
   inline T* InsertPtr(T* mPtr);
   inline Iterator* Remove();
  };
//--------------------------------------------------------
template<typename T>
T* CStack::InsertPtr(T* mPtr){
   Iterator* it=new Iterator(mPtr,cBack);
   if (!cFront) cFront=it;
   cBack=it;
   return mPtr;}
//---------------------------------------------------------------
template<typename T>
T* CStack::Pop(){
   Iterator* it=Remove();
   if (!it) return NULL;
   T* ptr=it.Get();
   it.Erase();
   return ptr;}
//----------------------------------------------------------------
template<typename T>
T* CStack::Delete(){
   Iterator* it=Remove();
   if (!it) return NULL;
   it.Delete();
   return !cBack?NULL:cBack.Get();}
//-----------------------------------------------------------------
template<typename T>
T* CStack::Erase(){
   Iterator* it=Remove();
   if (!it) return NULL;
   it.Erase();
   return !cBack?NULL:cBack.Get();}
//---------------------------------------------------------------------
template<typename T>
Iterator* CStack::Remove(){
   if (!cSize) return NULL;
   else --cSize;
   Iterator* it=cBack;
   cBack=cBack.Prev();
   if (!cBack) cFront=NULL;
   return it;}

#undef Iterator

#endif