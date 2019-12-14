#ifndef _C_DE_QUEUE_
#define _C_DE_QUEUE_

#include "CListBase.mqh"

#define Iterator CIterator<T>

template<typename T>
class CDeQueue:public CListBase<T,Iterator>
  {
public:
            ~CDeQueue() {if (cSize>0) for (T* it=cFront.Get();it!=NULL;it=cFlag.Check(_LIST_NO_DELETABLE_)?EraseFront():DeleteFront());}
   T*        Peek()=delete;
   T*        Push(T* mPtr)=delete;
   T*        Pop()=delete;
   T*        Delete()=delete;
   T*        Erase()=delete;
   inline T* PeekFront()   {return !cFront?NULL:cFront.Get();}
   inline T* PeekBack()    {return !cLast?NULL:cLast.Get();}   
   inline T* PushFront(T* mPtr);
   inline T* PushBack(T* mPtr);
   inline T* PopFront();
   inline T* PopBack();
   inline T* DeleteFront();
   inline T* DeleteBack();
   inline T* EraseFront();
   inline T* EraseBack();
protected:
   T*        InsertPtr(T* mPtr)=delete;
   Iterator* Remove()=delete;
   inline Iterator* RemoveFront();
   inline Iterator* RemoveBack();
  };
//--------------------------------------------------------
template<typename T>
T* CDeQueue::PushFront(T* mPtr){
   if (cSize==UINT_MAX) return NULL;
   else ++cSize;
   Iterator* it=new Iterator(mPtr,cFront,NULL);
   if (!cLast) cLast=it;
   if (cFront!=NULL) cFront.SetPrev(it);
   cFront=it;
   return mPtr;}
//---------------------------------------------------------
template<typename T>
T* CDeQueue::PushBack(T* mPtr){
   if (cSize==UINT_MAX) return NULL;
   else ++cSize;
   Iterator* it=new Iterator(mPtr,NULL,cLast);
   if (!cFront) cFront=it;
   if (cLast!=NULL) cLast.SetNext(it);
   cLast=it;
   return mPtr;}
//---------------------------------------------------------------
template<typename T>
T* CDeQueue::PopFront(){
   Iterator* it=RemoveFront();
   if (!it) return NULL;
   T* ptr=it.Get();
   it.Erase();
   return ptr;}
//---------------------------------------------------------------
template<typename T>
T* CDeQueue::PopBack(){
   Iterator* it=RemoveBack();
   if (!it) return NULL;
   T* ptr=it.Get();
   it.Erase();
   return ptr;}
//----------------------------------------------------------------
template<typename T>
T* CDeQueue::DeleteFront(){
   Iterator* it=RemoveFront();
   if (!it) return NULL;
   it.Delete();
   return !cFront?NULL:cFront.Get();}
//----------------------------------------------------------------
template<typename T>
T* CDeQueue::DeleteBack(){
   Iterator* it=RemoveBack();
   if (!it) return NULL;
   it.Delete();
   return !cLast?NULL:cLast.Get();}
//----------------------------------------------------------------
template<typename T>
T* CDeQueue::EraseFront(){
   Iterator* it=RemoveFront();
   if (!it) return NULL;
   it.Erase();
   return !cFront?NULL:cFront.Get();}
//----------------------------------------------------------------
template<typename T>
T* CDeQueue::EraseBack(){
   Iterator* it=RemoveBack();
   if (!it) return NULL;
   it.Erase();
   return !cLast?NULL:cLast.Get();}
//---------------------------------------------------------------
template<typename T>
Iterator* CDeQueue::RemoveFront(){
   if (!cSize) return NULL;
   else --cSize;
   Iterator* it=cFront;
   cFront=cFront.Next();
   if (!cFront) cLast=NULL;
   else cFront.SetPrev(NULL);
   return it;}
//---------------------------------------------------------------
template<typename T>
Iterator* CDeQueue::RemoveBack(){
   if (!cSize) return NULL;
   else --cSize;
   Iterator* it=cLast;
   cLast=cLast.Prev();
   if (!cLast) cFront=NULL;
   else cLast.SetNext(NULL);
   return it;}
   
#undef Iterator

#endif