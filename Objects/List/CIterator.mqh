#ifndef _C_ITERATOR_
#define _C_ITERATOR_

template<typename T>
class IIterator
  {
   T*                cPtr;
protected:
                           IIterator(T* mPtr):cPtr(mPtr){}
   virtual                ~IIterator();
public:
   inline T*               Get()                               {return cPtr;}
   inline void             Set(T* mPtr)                        {cPtr=mPtr;}
   inline T*               Swap(T* mPtr);
   inline T*               Move();
   inline void operator =(T* mPtr)   {cPtr=mPtr;}
   inline void             Erase();
   inline void             Delete() {delete GetPointer(this);}
  };
//--------------------------------------------------------------------------
template<typename T>
IIterator::~IIterator(){
   if (cPtr!=NULL) delete cPtr;}
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
   delete GetPointer(this);
   return ptr;}
//--------------------------------------------------------------------------
template<typename T>
void IIterator::Erase(){
   cPtr=NULL;
   delete GetPointer(this);}
//--------------------------------------------------------------------------
/////////////////////////////////////////////////////////////////////////
template<typename T>
class CIteratorForward:public IIterator<T>
{
   CIteratorForward<T>*   cNext;
public:
                              CIteratorForward(T* mPtr,CIteratorForward<T>* mNext):IIterator<T>(mPtr),cNext(mNext){}
   inline void                SetNext(CIteratorForward<T>* mPtr)   {cNext=mPtr;}
   inline CIteratorForward<T>*  Next()  {return cNext;}
};
//--------------------------------------------------------------------------
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

#endif