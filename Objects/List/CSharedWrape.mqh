#ifndef _C_SHARED_WRAPE_
#define _C_SHARED_WRAPE_

#include <MyMQLLib\Objects\Wrapers\CWrape.mqh>

template<typename T>
class CSharedWrape
  {
   CWrape<T>*        cPtr;
   uint              cCount;
public:
                     CSharedWrape():cPtr(new CWrape<T>),cCount(0){}
                    ~CSharedWrape()
  };

#endif