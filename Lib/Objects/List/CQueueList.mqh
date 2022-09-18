#ifndef _C_QUEUE_
#define _C_QUEUE_

#include "CListBase.mqh"

#define Iterator CIteratorForward<T>

template<typename T>
class CQueueList:public CListBase<T,Iterator>
  {
   Iterator* cEnd;
public:
             CQueueList();
            ~CQueueList() {if (cFlag.Check(_LIST_NO_DELETABLE_)) while(cFront.Kill(false)); else while(cFront.Kill(true));}
   inline T* Peek()  {return cFront.Get();}
   inline T* Pop();
   inline T* Delete();
   inline T* Erase();
protected:
   inline T* InsertPtr(T* mPtr);
  };
//--------------------------------------------------------
template<typename T>
CQueueList::CQueueList():
   CListBase(),
   cEnd(new Iterator(NULL,NULL,cSize)){
   cFront=cBack=cEnd;}
//--------------------------------------------------------
template<typename T>
T* CQueueList::InsertPtr(T* mPtr){
   cEnd.Push(mPtr);
   cEnd.SetNext(new Iterator(NULL,NULL,cSize));
   cBack=cEnd;
   cEnd=cEnd.Next();
   return mPtr;}
//---------------------------------------------------------------
template<typename T>
T* CQueueList::Pop(){
   if (!cSize) return NULL;
   Iterator* it=cFront;
   cFront=cFront.Next();
   return it.Move();}
//----------------------------------------------------------------
template<typename T>
T* CQueueList::Delete(){
   if (!cSize) return NULL;
   Iterator* it=cFront;
   cFront=cFront.Next();
   it.Delete();
   return cFront.Get();}
//-----------------------------------------------------------------
template<typename T>
T* CQueueList::Erase(){
   if (!cSize) return NULL;
   Iterator* it=cFront;
   cFront=cFront.Next();
   it.Erase();
   return cFront.Get();}

#undef Iterator

#endif