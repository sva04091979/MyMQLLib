#ifndef _I_CONTAINER_
#define _I_CONTAINER_

#ifndef USING_STD
   namespace STD{
#endif

#include <MyMQLLib\Objects\Wrapers\CWrape.mqh>
#include "IAllocator.mqh"

class IContainer
  {
   STD::IAllocator*  cAllocator;
   STD::IIterator*   cIt;
   STD::IIterator*   cBegine;
   STD::IIterator*   cFirst;
   STD::IIterator*   cLast;
   STD::IIterator*   cEnd;
   STD::CWrape<uint> cSize;
public:
                     IContainer():cAllocator(NULL),cIt(NULL),cBegine(NULL),cFirst(NULL),cLast(NULL),cEnd(NULL),cSize(0){}
                     IContainer(uint mSize,STD::IAllocator* mAllocator):cAllocator(mAllocator),cSize(mSize){}
   uint              GetSize();
   uint              GetMemSize()   {return !cAllocator?cSize.Get():cAllocator.GetSize();}
  };

#ifndef USING_STD
   }
#endif 

#endif