#ifndef _C_WRAPE_
#define _C_WRAPE_

template<typename T>
class CWrape{
public:
   T     cValue;
         CWrape():cValue(NULL){}
         CWrape(T mValue):cValue(mValue){}
};

#endif