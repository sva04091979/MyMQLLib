#ifndef _I_CONTAINER_
#define _I_CONTAINER_

class IContainer
  {
   uint              cSize;
public:
                     IContainer():cSize(0){}
                     IContainer(uint mSize):cSize(mSize){}
   uint              GetSize();
  };

#endif