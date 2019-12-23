#ifndef _C_ITERATOR_
#define _C_ITERATOR_

#include <MyMQLLib\Objects\Wrapers\CWrape.mqh>

#define _size CWrapeS<ulong>

template<typename T>
class IIterator
  {
protected:
   T*                      cPtr;
   _size*                  cSize;
                           IIterator(T* mPtr,_size* mSize):cPtr(mPtr),cSize(mSize){}
public:
   inline T*               Get()                               {return cPtr;}
   inline void             Push(T* mPtr)                       {cPtr=mPtr;++cSize;}
   inline T*               Swap(T* mPtr);
   inline T*               Move();
   inline void operator =(T* mPtr)   {cPtr=mPtr;}
  };
//--------------------------------------------------------------------------
template<typename T>
T* IIterator::Swap(T* mPtr){
   T* ptr=cPtr;
   cPtr=mPtr;
   return ptr;}
//--------------------------------------------------------------------------
template<typename T>
T* IIterator::Move(){
   T* ptr=cPtr;
   cPtr=NULL;
   --cSize;
   delete GetPointer(this);
   return ptr;}
//--------------------------------------------------------------------------
/////////////////////////////////////////////////////////////////////////
template<typename T>
class CIteratorForward:public IIterator<T>
{
   CIteratorForward<T>*   cNext;
public:
                              CIteratorForward(T* mPtr,CIteratorForward<T>* mNext,_size* mSize):IIterator<T>(mPtr,mSize),cNext(mNext){}
   inline void                SetNext(CIteratorForward<T>* mPtr)   {cNext=mPtr;}
   inline bool                   Kill(bool mIsDelete);
   inline bool                   Delete();  
   inline bool                   Erase();
   inline bool                   IsValid()   {return cNext!=NULL;}
   inline CIteratorForward<T>*   Next()  {return cNext;}
   inline CIteratorForward<T>*   operator ++() {&this=cNext; return &this;}
   inline CIteratorForward<T>*   operator ++(int);
};
//---------------------------------------------------------------------------
template<typename T>
bool CIteratorForward::Kill(bool mIsDelete){
   if (mIsDelete) delete cPtr;
   CIteratorForward<T>* it=&this;
   if (cNext!=NULL) --cSize;
   &this=cNext;
   delete it;
   return &this!=NULL;}
//---------------------------------------------------------------------------
template<typename T>
bool CIteratorForward::Delete(){
   delete cPtr;
   return Erase();}
//---------------------------------------------------------------------------
template<typename T>
bool CIteratorForward::Erase(){
   if (!cNext) return false;
   CIteratorForward<T>* it=&this;
   if (cNext!=NULL) --cSize;
   &this=cNext;
   delete it;
   return &this!=NULL;}
//--------------------------------------------------------------------------
template<typename T>
CIteratorForward<T>* CIteratorForward::operator ++(int){
   CIteratorForward<T>* it=&this;
   &this=cNext;
   return it;}
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
template<typename T>
class CIteratorBack:public IIterator<T>
{
   CIteratorBack<T>*   cPrev;
public:
                              CIteratorBack(T* mPtr,CIteratorBack<T>* mPrev):IIterator<T>(mPtr),cPrev(mPrev){}
   inline void                SetPrev(CIteratorBack<T>* mPtr)   {cPrev=mPtr;}
   inline CIteratorBack<T>*  Prev() {return cPrev;}
};
//--------------------------------------------------------------------------
/////////////////////////////////////////////////////////////////////////
template<typename T>
class CIterator:public IIterator<T>
{
   CIterator<T>*   cNext;
   CIterator<T>*   cPrev;
public:
                              CIterator(T* mPtr,CIterator<T>* mNext,CIterator<T>* mPrev);
                             ~CIterator() {ReBind();}
   inline void                SetNext(CIterator<T>* mPtr)   {cNext=mPtr;}
   inline void                SetPrev(CIterator<T>* mPtr)   {cPrev=mPtr;}
   inline CIterator<T>*   Next() {return cNext;}
   inline CIterator<T>*   Prev() {return cPrev;}
private:
   void                       ReBind();
};
//-------------------------------------------------------------------------------
template<typename T>
CIterator::CIterator(T* mPtr,CIterator<T>* mNext,CIterator<T>* mPrev):
   IIterator<T>(mPtr),cNext(mNext),cPrev(mPrev){}
//-------------------------------------------------------------------------------
template<typename T>
void CIterator::ReBind(){
   if (cNext!=NULL) cNext.SetPrev(cPrev);
   if (cPrev!=NULL) cPrev.SetNext(cNext);}

#undef _size;

#endif