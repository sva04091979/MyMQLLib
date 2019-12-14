#ifndef _C_QUEUE_
#define _C_QUEUE_

#include "CListBase.mqh"

template<typename T>
class CQueue:public CListBase<T,CIteratorQueue<T>>
  {
public:
   inline T* Peek()  {return cFront.Get();}
   inline T* Pop();
   inline T* Delete();
   inline T* Erace();
protected:
   inline T* InsertPtr(T* mPtr);
  };
//--------------------------------------------------------
template<typename T>
T* CQueue::InsertPtr(T* mPtr){
   CIteratorQueue<T>* it=new CIteratorQueue<T>(mPtr);
   if (cLast!=NULL) cLast.SetNext(it);
   cLast=it;
   return mPtr;}
//---------------------------------------------------------------
template<typename T>
T* CQueue::Pop(){
   T* ptr=cFront.Get();
   CIteratorQueue<T>* it=cFront;
   cFront=cFront.Next();
   it.Erace();
   return ptr;}
//----------------------------------------------------------------
template<typename T>
T* CQueue::Delete(){
   CIteratorQueue<T>* it=cFront;
   cFront=cFront.Next();
   it.Delete();
   return cFront.Get();}
//-----------------------------------------------------------------
template<typename T>
T* CQueue::Erace(){
   CIteratorQueue<T>* it=cFront;
   cFront=cFront.Next();
   it.Erace();
   return cFront.Get();}

#endif