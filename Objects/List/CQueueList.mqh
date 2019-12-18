#ifndef _C_QUEUE_
#define _C_QUEUE_

#include "CListBase.mqh"
#include <MyMQLLib\Objects\Array\CArray.mqh>

#define Iterator CIteratorForward<T>
#define Block CArray<Iterator>

template<typename T>
class CQueueList:public CListBase<T,Iterator>
  {
   CQueueList<Block>  cArray;
   Iterator* cEnd;
public:
             CQueueList():CQueueList(256);
             CQueueList(int mBlockSize);
            ~CQueueList();
   inline T* Peek()  {return cFront.Get();}
   inline T* Pop();
   inline T* Delete();
   inline T* Erase();
protected:
   inline T* InsertPtr(T* mPtr);
  };
//--------------------------------------------------------
template<typename T>
CQueueList::CQueueList(int mBlockSize):
   CListBase(mBlockSize),
   cEnd(new Iterator(NULL,NULL)){
   cFront=cBack=cEnd;}
//--------------------------------------------------------
template<typename T>
CQueueList::~CQueueList(){
   while(NULL!=(cFlag.Check(_LIST_NO_DELETABLE_)?Erase():Delete()));
   delete cEnd;}
//--------------------------------------------------------
template<typename T>
T* CQueueList::InsertPtr(T* mPtr){
   cEnd.Set(mPtr);
   cEnd.SetNext(new Iterator(NULL,NULL));
   cBack=cEnd;
   cEnd=cEnd.Next();
   return mPtr;}
//---------------------------------------------------------------
template<typename T>
T* CQueueList::Pop(){
   if (cFront==cEnd) return NULL; else --cSize;
   Iterator* it=cFront;
   cFront=cFront.Next();
   return it.Move();}
//----------------------------------------------------------------
template<typename T>
T* CQueueList::Delete(){
   if (cFront==cEnd) return NULL; else --cSize;
   Iterator* it=cFront;
   cFront=cFront.Next();
   it.Delete();
   return cFront.Get();}
//-----------------------------------------------------------------
template<typename T>
T* CQueueList::Erase(){
   if (cFront==cEnd) return NULL; else --cSize;
   Iterator* it=cFront;
   cFront=cFront.Next();
   it.Erase();
   return cFront.Get();}

#undef Iterator

#endif