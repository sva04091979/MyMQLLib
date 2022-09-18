#ifndef _STD_I_CONTAINER_
#define _STD_I_CONTAINER_

#include <STD\Define\StdDefine.mqh>

#define _tdeclContainer __decl(CContainer)

NAMESPACE(STD)

class _tdeclContainer{
protected:
   _tSizeT cSize;
   _tdeclContainer():cSize(0){}
   _tdeclContainer(_tSizeT _size):cSize(_size){}
public:
   _tSizeT Size() const {return cSize;}
   bool IsEmpty() const {return !cSize;}
};

END_SPACE

#endif