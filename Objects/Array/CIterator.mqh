#ifndef _C_ITERATOR_
#define _C_ITERATOR_

template<typename T>
class CIterator
  {
   T*                cPtr;
   CIterator<T>*     cNext;
   CIterator<T>*     cPrev;
public:
                     CIterator(T* mPtr,CIterator<T>* mPrev,CIterator<T>* mNext):
                        cPtr(mPtr),cNext(mNext),cPrev(mPrev){}
                    ~CIterator();
   T*                Get()                               {return cPtr;}
   void              Set(T* mPtr)                        {cPtr=mPtr;}
   void              SetNext(CIterator<T>* mPtr)         {cNext=mPtr;}
   void              SetPrev(CIterator<T>* mPtr)         {cPrev=mPtr;}
   inline CIterator<T>*     Next()                              {return cNext;}
   inline CIterator<T>*     Prev()                              {return cPrev;}
   bool              IsFirst()                           {return cPrev==NULL;}
   bool              IsLast()                            {return cNext==NULL;}
   T*                Swap(T* mPtr);
   T*                Move();
   void operator =(T* mPtr)   {cPtr=mPtr;}
   void              Erace();
   void              Delete() {delete GetPointer(this);}
private:
   void              ReBind();
  };
//--------------------------------------------------------------------------
template<typename T>
CIterator::~CIterator(){
   ReBind();
   if (cPtr!=NULL) delete cPtr;}
//-------------------------------------------------------------------------
template<typename T>
void CIterator::ReBind(){
   if (cNext!=NULL) cNext.SetPrev(cPrev);
   if (cPrev!=NULL) cPrev.SetNext(cNext);
   cNext=cPrev=NULL;}
//--------------------------------------------------------------------------
template<typename T>
T* CIterator::Swap(T* mPtr){
   T* ptr=cPtr;
   cPtr=mPtr;
   return ptr;}
//--------------------------------------------------------------------------
template<typename T>
T* CIterator::Move(){
   T* ptr=cPtr;
   cPtr=NULL;
   delete GetPointer(this);
   return ptr;}
//--------------------------------------------------------------------------
template<typename T>
void CIterator::Erace(){
   cPtr=NULL;
   delete GetPointer(this);}
//--------------------------------------------------------------------------
template<typename T>
T* operator =(CIterator<T>* mPtr) {return mPtr.Get();}

#endif