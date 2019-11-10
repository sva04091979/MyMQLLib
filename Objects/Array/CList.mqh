#ifndef _C_LIST_
#define _C_LIST_

#include "CIterator.mqh"

#define INIT cIterator(NULL),cBegine(NULL),cEnd(NULL),cPos(-1),cSize(0),cIsDeletable(true)
#define INSERT_ITERATOR(dPtr) InsertIterator(new CIterator<T>(dPtr,IsFirst()?NULL:cIterator.Prev(),IsEmpty()?NULL:cIterator))
//---------------------------------------------------------------------------------------------------   
#define CHECK_LAST_END                    \
   do{                                    \
      if (!(cPos>0)) cBegine=cIterator;   \
      if (cPos+1==cSize) cEnd=cIterator;} \
   while(false)
//---------------------------------------------------------------------------------------------------
#define RETURN_DELETE(dSet)                                  \
   if (--cSize==cPos) --cPos;                               \
   CIterator<T>* iterator=cIterator;                        \
   bool isLast=IsLast();                                    \
   cIterator=isLast?cIterator.Prev():cIterator.Next();      \
   CHECK_LAST_END;                                          \
   iterator.dSet();                                          \
   return isLast||cIterator==NULL?NULL:cIterator.Get()

template<typename T>
class CList
  {
   CIterator<T>*     cIterator;
   CIterator<T>*     cBegine;
   CIterator<T>*     cEnd;
   int               cPos;
   int               cSize;
   bool              cIsDeletable;
protected:
   inline T*         Get(int mPos);
public:
                     CList():INIT{}
                    ~CList()  {if (cIsDeletable) DeleteAll(); else EraceAll();}
   inline int        GetPos()       {return cPos;}
   inline int        GetSize()      {return cSize;}
   inline bool       IsEmpty()      {return !cSize;}
   inline bool       IsFirst()      {return cIterator==NULL||cIterator.IsFirst();}
   inline bool       IsLast()       {return cIterator==NULL||cIterator.IsLast();}
   bool              IsDeletable()  {return cIsDeletable;}
   inline T*         Push(T* mPtr,int mPos=INT_MIN);
   inline T*         PushBack(T* mPtr);
   T*                PushBack(CList<T>* mList,bool mIsDelete=true);
   inline T*         PushFirst(T* mPtr)   {return !cSize?PushBack(mPtr):Push(mPtr,0);}
   inline T*         PushNext(T* mPtr)    {return !cSize||IsLast()?PushBack(mPtr):Push(mPtr,cPos+1);}
   T*                Swap(T* mPtr,int mPos=INT_MIN);
   inline T*         Insert(T* mPtr, int mPos=INT_MIN);
   inline T*         Erace(int mPos=INT_MIN);
   inline T*         PopFirst()  {return Move(0);}
   inline T*         PopBack()   {return Move(cSize-1);}
   inline T*         It()     {return cIterator==NULL?NULL:cIterator.Get();}
   inline T*         End()    {if (cSize) cPos=cSize-1; cIterator=cEnd; return cIterator==NULL?NULL:cIterator.Get();}
   inline T*         Begine() {if (cSize) cPos=0; cIterator=cBegine; return cIterator==NULL?NULL:cIterator.Get();}
   inline T*         Next(int mCount=1);
   inline T*         Prev(int mCount=1);
   inline T*         Move(int mPos=INT_MIN);
   inline T*         Delete(int mPos=INT_MIN);
   inline T*         DeleteRevers(int mPos=INT_MIN);
   void              EraceAll() {while (Erace()!=NULL||Begine()!=NULL);}
   void              DeleteAll() {while (Delete()!=NULL||Begine()!=NULL);}
   void              SetDestructMode (bool mIsDeletable)    {cIsDeletable=mIsDeletable;}
   T* operator [](int mPos)   {return Get(mPos);}
private:
   void              InsertIterator(CIterator<T>* mPtr);
  };
//-----------------------------------------------------
template<typename T>
void CList::InsertIterator(CIterator<T>* mPtr){
   if (!IsFirst()) cIterator.Prev().SetNext(mPtr);
   if (cIterator!=NULL) cIterator.SetPrev(mPtr);
   cIterator=mPtr;}
//-----------------------------------------------------
template<typename T>
T* CList::Push(T* mPtr,int mPos=INT_MIN){
   if (mPos==INT_MIN) mPos=cPos;
   else if (Get(mPos)==NULL) return NULL;
   INSERT_ITERATOR(mPtr);
   if (cPos<0) ++cPos;
   ++cSize;
   CHECK_LAST_END;
   return cIterator.Get();}
//----------------------------------------------------
template<typename T>
T* CList::PushBack(T* mPtr){
   if (End()==NULL) return Push(mPtr);
   CIterator<T>* iterator=new CIterator<T>(mPtr,cIterator,NULL);
   cIterator.SetNext(iterator);
   cIterator=iterator;
   ++cPos;
   ++cSize;
   cEnd=iterator;
   if (!cPos) cBegine=iterator;
   return cIterator.Get();}
//----------------------------------------------------
template<typename T>
T* CList::PushBack(CList<T>* mList,bool mIsDelete=true){
   for (mList.Begine();!mList.IsEmpty();PushBack(mList.Move()));
   if (mIsDelete&&CheckPointer(mList)==POINTER_DYNAMIC) delete mList;
   return cIterator.Get();}
//----------------------------------------------------
template<typename T>
T* CList::Next(int mCount=1){
   if (mCount<0||!cSize||cSize-cPos<=mCount) return NULL;
   int stop=cPos+mCount;
   while (stop>cPos) {cIterator=cIterator.Next(); ++cPos;}
   return cIterator==NULL?NULL:cIterator.Get();}
//----------------------------------------------------
template<typename T>
T* CList::Prev(int mCount=1){
   if (mCount<0||cPos<mCount) return NULL;
   int stop=cPos-mCount;
   while (stop<cPos) {cIterator=cIterator.Prev(); --cPos;}
   return cIterator==NULL?NULL:cIterator.Get();}
//------------------------------------------------------
template<typename T>
T* CList::Move(int mPos=INT_MIN){
   if (mPos==INT_MIN) mPos=cPos;
   else if (Get(mPos)==NULL) return NULL;
   if (cIterator==NULL) return NULL;
   if (--cSize==cPos) --cPos;
   CIterator<T>* iterator=cIterator;
   cIterator=IsLast()?cIterator.Prev():cIterator.Next();
   CHECK_LAST_END;
   return iterator.Move();}
//------------------------------------------------------
template<typename T>
T* CList::Swap(T* mPtr,int mPos=INT_MIN){
   if (mPos==INT_MIN) mPos=cPos;
   else if (Get(mPos)==NULL) return NULL;
   if (cIterator==NULL) {PushBack(mPtr); return NULL;}
   return cIterator.Swap(mPtr);}
//------------------------------------------------------
template<typename T>
T* CList::Insert(T* mPtr,int mPos=INT_MIN){
   if (mPos==INT_MIN) mPos=cPos;
   else if (Get(mPos)==NULL) return NULL;
   if (cIterator==NULL) return PushBack(mPtr);
   INSERT_ITERATOR(mPtr);
   cIterator.Next().Delete();
   CHECK_LAST_END;
   return cIterator.Get();}
//------------------------------------------------------
template<typename T>
T* CList::Erace(int mPos=INT_MIN){
   if (mPos==INT_MIN) mPos=cPos;
   else if (Get(mPos)==NULL) return NULL;
   if (cIterator==NULL) return NULL;
   RETURN_DELETE(Erace);}
//------------------------------------------------------
template<typename T>
T* CList::Delete(int mPos=INT_MIN){
   if (mPos==INT_MIN) mPos=cPos;
   else if (Get(mPos)==NULL) return NULL;
   if (cIterator==NULL) return NULL;
   RETURN_DELETE(Delete);}
//------------------------------------------------------
template<typename T>
T* CList::DeleteRevers(int mPos=INT_MIN){
   if (mPos==INT_MIN) mPos=cPos;
   else if (Get(mPos)==NULL) return NULL;
   if (cIterator==NULL) return NULL;
   if (cSize--==1||cPos>0) --cPos;
   CIterator<T>* iterator=cIterator;
   bool isFirst=IsFirst();
   cIterator=isFirst?cIterator.Next():cIterator.Prev();
   CHECK_LAST_END;
   iterator.Delete();
   return isFirst||cIterator==NULL?NULL:cIterator.Get();}
//------------------------------------------------------
template<typename T>
T* CList::Get(int mPos){
   if (mPos<0||mPos>=cSize) return NULL;
   return mPos==cPos?cIterator.Get():mPos>cPos?Next(mPos-cPos):Prev(cPos-mPos);}
//------------------------------------------------------

#undef INIT
#undef INSERT_ITERATOR
#undef CHECK_LAST_END
#undef RETURN_DELETE

#define LIST_DO_SOMETHING(dList,dMethod)              \
   do{                                                \
      dList.Begine().dMethod;                         \
      while (!dList.IsLast()) dList.Next().dMethod;}  \
   while(false)

#endif 