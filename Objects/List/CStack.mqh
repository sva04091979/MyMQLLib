#ifndef _C_STACK_
#define _C_STACK_

#include "CListBase.mqh"

#define Iterator CIteratorBack<T>

template<typename T>
class CStack:public CListBase<T,Iterator>
  {
public:
            ~CStack() {if (cSize>0) for (T* it=cLast.Get();it!=NULL;it=cFlag.Check(_LIST_NO_DELETABLE_)?Erase():Delete());}
   inline T* Peek()  {return !cLast?NULL:cLast.Get();}
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
   Iterator* it=new Iterator(mPtr,cLast);
   if (!cFront) cFront=it;
   cLast=it;
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
   return !cLast?NULL:cLast.Get();}
//-----------------------------------------------------------------
template<typename T>
T* CStack::Erase(){
   Iterator* it=Remove();
   if (!it) return NULL;
   it.Erase();
   return !cLast?NULL:cLast.Get();}
//---------------------------------------------------------------------
template<typename T>
Iterator* CStack::Remove(){
   if (!cSize) return NULL;
   else --cSize;
   Iterator* it=cLast;
   cLast=cLast.Prev();
   if (!cLast) cFront=NULL;
   return it;}

#undef Iterator

#endif