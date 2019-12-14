#ifndef _C_ITERATOR_
#define _C_ITERATOR_

template<typename T>
class CIterator
  {
   T*                cPtr;
public:
                           CIterator(T* mPtr):cPtr(mPtr){}
   virtual                ~CIterator();
   inline T*               Get()                               {return cPtr;}
   inline void             Set(T* mPtr)                        {cPtr=mPtr;}
   inline T*               Swap(T* mPtr);
   inline T*               Move();
   inline void operator =(T* mPtr)   {cPtr=mPtr;}
   inline void             Erace();
   inline void             Delete() {delete GetPointer(this);}
  };
//--------------------------------------------------------------------------
template<typename T>
CIterator::~CIterator(){
   if (cPtr!=NULL) delete cPtr;}
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
/////////////////////////////////////////////////////////////////////////
template<typename T>
class CIteratorQueue:public CIterator<T>
{
   CIteratorQueue<T>*   cNext;
public:
                              CIteratorQueue(T* mPtr):CIterator<T>(mPtr){}
   inline void                SetNext(CIteratorQueue<T>* mPtr)   {cNext=mPtr;}
   inline CIteratorQueue<T>*  Next()  {return cNext;}
};
//--------------------------------------------------------------------------
/////////////////////////////////////////////////////////////////////////
template<typename T>
class CIteratorStack:public CIterator<T>
{
   CIteratorStack<T>*   cPrev;
public:
                              CIteratorQueue(T* mPtr):CIterator<T>(mPtr){}
   inline void                SetPrev(CIteratorStack<T>* mPtr)   {cPrev=mPtr;}
   inline CIteratorStack<T>*  Prev();  {return cPrev;}
};
//--------------------------------------------------------------------------
/////////////////////////////////////////////////////////////////////////
template<typename T>
class CIteratorList:public CIterator<T>
{
   CIteratorList<T>*   cNext;
   CIteratorList<T>*   cPrev;
public:
                              CIteratorQueue(T* mPtr):CIterator<T>(mPtr){}
   inline void                SetNext(CIteratorList<T>* mPtr)   {cNext=mPtr;}
   inline void                SetPrev(CIteratorList<T>* mPtr)   {cPrev=mPtr;}
   inline CIteratorList<T>*   Next();  {return cNext;}
   inline CIteratorList<T>*   Prev();  {return cPrev;}
private:
   void                       ReBind();
};
//-------------------------------------------------------------------------------
template<typename T>
void CIteratorList::ReBind(){
   if (cNext!=NULL) cNext.SetPrev(cPrev);
   if (cPrev!=NULL) cPrev.SetNext(cNext);}

#endif