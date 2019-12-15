#ifndef _C_FORWARD_LIST_
#define _C_FORWARD_LIST_

#include "CDeQueue.mqh"

template<typename T>
class CForwardList:public CQueue<T>
  {
   Iterator*   cPtr;
   Iterator*   cEnd;
   uint        cPos;
public:
             CForwardList():CListBase(),cPtr(NULL),cEnd(new Iterator(NULL,NULL)),cPos(0){}
            ~CForwardList() {while(NULL!=(cFlag.Check(_LIST_NO_DELETABLE_)?EraseFront():DeleteFront()));}
   inline T* It()    {return !cPtr?NULL:cPtr.Get();}
   inline T* Next() {return cPos<cSize?_Next():NULL;}
   inline T* Insert(T* mPtr) {return InsertNext(mPtr,cPos);}
   inline T* PushFront(T* mPtr);
   inline T* PushBack(T* mPtr);
   inline T* InsertNext(T* mPtr,uint mPos);
   inline T* Pop();
   inline T* Extract()  {return ExtractNext(cPtr);}
   inline T* ExtractNext(uint mPtr);
   
   inline T* EraseFront();
protected:
   inline T* _Next();
   inline void GoTo(uint mPos);
/*   
   T* Delete()=delete;
   T* Pop()=delete;
   T* Erase()=delete;
   Iterator* Remove()=delete;
   inline uint GetPos() {return cPos;}
   inline T* It()      {return cPtr.Get();}
   inline T* Front()   {cPos=0; cPtr=cFront; return cPtr.Get();}
   inline T* Back()    {if (cSize>0) cPos=cSize-1; cPtr=cBack; return cPtr.Get();}
   inline T* PushFront(T* mPtr);
   inline T* Push(T* mPtr,uint cPos);
   inline T* PushBack(T* mPtr);
   inline T* Next();
   inline T* Peek()  {return Peek(cPos);}
   inline T* Peek(uint mPos);
   inline T* PopNext()   {return PopNext(cPos);}
   inline T* PopNext(uint mPos);
   inline T* DeleteNext()   {return cPos==cSize?DeleteFront():DeleteNext(cPos);}
   inline T* EraseNext() {return cPos==cSize?DeleteFront():Delete(cPos);}
protected:
   inline T* Get(uint mPos);
   inline void GoTo(uint mPos);
   inline void GoBack() {cPos=!cSize?0:cSize-1; cPtr=cBack;}
   inline void GoFront() {cPos=0; cPtr=cFront;}
   inline T* InsertPtr(T* mPtr);
   inline Iterator* RemoveNext();
*/
  };
//-------------------------------------------------------
template<typename T>
T* CForwardList::Next(){
   if (cPos<cSize) return _Next();
   else return NULL;}
//-------------------------------------------------------
template<typename T>
T* CForwardList::_Next(){
   ++cPos;
   cPtr=cPtr.Next();
   return cPtr.Get();}
//-------------------------------------------------------
template<typename T>
T* CForwardList::PushFront(T* mPtr){
   if (cSize==UINT_MAX) return NULL;
   else if (!cSize) return PushBack(mPtr);}
   else ++cSize;
   cPos=0;
   cPtr=cFront=new Iterator(mPtr,cFront);
   return mPtr;}
//-------------------------------------------------------
template<typename T>
T* CForwardList::PushBack(T* mPtr){
   if (!CListBase::Push(mPtr)) return NULL;
   else cPos=cSize-1;
   cPtr=cBack;
   cPtr.SetNext(cEnd);
   return mPtr();}
//-------------------------------------------------------
template<typename T>
T* CForwardList::InsertNext(T* mPtr,uint mPos){
   if (mPos>=cSize) return NULL;
   else if (mPos==cSize-1) return PushBack();
   else GoTo(mPos);
   ++cSize;
   cPtr.SetNext(new Iterator(mPos,cPtr.Next()));
   return _Next();}
//-------------------------------------------------------
template<typename T>
T* CForwardList::Pop(){
   T* ptr=CQueue::Pop();
   cPos=0;
   cPtr=cFront;
   return ptr;}
//-------------------------------------------------------
template<typename T>
T* CForwardList::ExtractNext(uint mPos){
   if (mPos>=cSize-1) return NULL;
   else if (!mPos) return Pop();
   else GoTo(mPos);
   --cSize;
   Iterator* it=cPos.Next();
   cPos.SetNext(it);
   if (it==cBack) cBack=cPos;
   T* ptr=it.Get();
   it.Erase();
   return ptr;}
//--------------------------------------------------------------
template<typename T>
void CForwardList::GoTo(uint mPos){
   if (mPos==cPos) return;
   else if (mPos==cSize-1) {cPos=cSize-1; cPtr=cBack; return;}
   else if (mPos<cPos) {cPos=0; cPtr=cFront;}
   while(cPos<mPos) {cPtr=cPtr.Next();++cPos;}}
//-------------------------------------------------------
template<typename T>
T* CForwardList::EraseFront(){
   T* it=CDeQueue::EraseFront();
   if (!it) return NULL;
   }
/*
//-------------------------------------------------------
template<typename T>
T* CForwardList::PushBack(uint mPos){
   if (cSize==UINT_MAX) return NULL; else ++cSize;
   Iterator* it=new Iterator(mPos,!cFront?cEnd:cFront);

//--------------------------------------------------------
template<typename T>
T* CForwardList::Peek(uint mPos){
   if (mPos<cSize) return Get(mPos);
   else return NULL;}
//----------------------------------------------------------
template<typename T>
T* CForwardList::Get(uint mPos){
   GoTo(mPos);
   return cPtr.Get();}
//----------------------------------------------------------
template<typename T>
T* CForwardList::Next(){
   if (cPos==cSize) return NULL;
   ++cPos;
   cPtr=cPtr.Next();
   return cPtr.Get();}
//--------------------------------------------------------------
template<typename T>
T* CForwardList::PopNext(uint mPos){
   if (mPos>=cSize) return NULL;
   else if (cPtr==cLast) return PopBack();
   GoTo(mPos);
   Iterator* it=RemoveNext();
   if (!it) return NULL;
   T* ptr=it.Get();
   it.Erase();
   return ptr;}   
//--------------------------------------------------------
template<typename T>
T* CQueue::InsertPtr(T* mPtr){
   Iterator* it=new Iterator(mPtr,NULL);
   if (!cFront) cFront=it;
   if (cLast!=NULL) cLast.SetNext(it);
   cLast=it;
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
Iterator* CQueue::RemoveNext(){
   if (!cSize) return NULL;
   else --cSize;
   Iterator* it=cFront;
   cFront=cFront.Next();
   if (!cFront) cLast=NULL;
   return it;}
*/
#undef Iterator

#endif