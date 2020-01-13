#ifndef _I_CONTAINER_
#define _I_CONTAINER_

#ifndef USING_STD
   namespace STD{
#endif

#include "IAllocator.mqh"

class IContainer
  {
   STD::IAllocator*  cAllocator;
   uint              cSize;
public:
                     IContainer():cAllocator(NULL),cSize(0){}
                     IContainer(uint mSize,STD::IAllocator* mAllocator):cAllocator(mAllocator),cSize(mSize){}
   uint              GetSize();
   uint              GetMemSize()   {return !cAllocator?cSize:cAllocator.GetSize();}
  };

#ifndef USING_STD
   }
#endif 

#endif