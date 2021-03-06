#ifndef _C_LIST_BASE_
#define _C_LIST_BASE_

#include <MyMQLLib\Objects\CFlag.mqh>
#include <MyMQLLib\Objects\Wrapers\CWrape.mqh>
#include "CIterator.mqh"

#define _LIST_NO_DELETABLE_   0x1

template<typename T,typename Iter>
class CListBase
  {
protected:
   CFlag             cFlag;
   CWrapeS<ulong>*   cSize;
//   ulong             cSize;
   Iter*             cFront;
   Iter*             cBack;
public:
   inline virtual T* Push(T* mPtr);
   inline virtual T* Delete()=0;
   inline virtual T* Erase()=0;
   inline virtual T* Pop()=0;
   inline virtual T* Peek()=0;
   inline virtual T* Front()  {return cFront.Get();}
   inline virtual T* Back()  {return cBack.Get();}
   ulong             GetSize()   {return cSize.Get();}
   inline bool       IsEmpty()   {return !cSize;}       
   bool              IsDeletable()  {return !cFlag.Check(_LIST_NO_DELETABLE_);}
   void              SetDestructMode(bool mIsDeletable) {if (mIsDeletable) cFlag-=_LIST_NO_DELETABLE_; else cFlag+=_LIST_NO_DELETABLE_;}
protected:
                     CListBase(int mBlockSize);
   inline virtual T* InsertPtr(T* mPtr)=0;
  };
//--------------------------------------------------
template<typename T,typename Iter>
CListBase::CListBase(void) {cSize=0;}
//--------------------------------------------------
template<typename T,typename Iter>
T* CListBase::Push(T* mPtr){
   if (cSize<ULONG_MAX) ++cSize; else return NULL;
   return InsertPtr(mPtr);}

#endif