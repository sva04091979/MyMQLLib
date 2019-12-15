#ifndef _C_QUEUE_
#define _C_QUEUE_

#include "CListBase.mqh"

#define Iterator CIteratorForward<T>

template<typename T>
class CQueue:public CListBase<T,Iterator>
  {
public:
            ~CQueue() {while(NULL!=(cFlag.Check(_LIST_NO_DELETABLE_)?Erase():Delete()));}
   inline T* Peek()  {return !cFront?NULL:cFront.Get();}
   inline T* Pop();
   inline T* Delete();
   inline T* Erase();
protected:
   inline T* InsertPtr(T* mPtr);
   inline Iterator* Remove();
  };
//--------------------------------------------------------
template<typename T>
T* CQueue::InsertPtr(T* mPtr){
   Iterator* it=new Iterator(mPtr,NULL);
   if (!cFront) cFront=it;
   if (cBack!=NULL) cBack.SetNext(it);
   cBack=it;
   return mPtr;}
//---------------------------------------------------------------
template<typename T>
T* CQueue::Pop(){
   Iterator* it=Remove();
   if (!it) return NULL;
   T* ptr=it.Get();
   it.Erase();
   return ptr;}
//----------------------------------------------------------------
template<typename T>
T* CQueue::Delete(){
   Iterator* it=Remove();
   if (!it) return NULL;
   it.Delete();
   return !cFront?NULL:cFront.Get();}
//-----------------------------------------------------------------
template<typename T>
T* CQueue::Erase(){
   Iterator* it=Remove();
   if (!it) return NULL;
   it.Erase();
   return !cFront?NULL:cFront.Get();}
//---------------------------------------------------------------------
template<typename T>
Iterator* CQueue::Remove(){
   if (!cSize) return NULL;
   else --cSize;
   Iterator* it=cFront;
   cFront=cFront.Next();
   if (!cFront) cBack=NULL;
   return it;}

#undef Iterator

#endif