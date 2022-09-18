#ifndef _C_ARRAY_
#define _C_ARRAY_

template<typename T>
class CArray
  {
   T                 cArray[];
   int               cSize;
public:
                     CArray(int mSize):cSize(ArrayResize(cArray)){}
   int               GetSize()   {return cSize;}
   T                 Get(int mPos)  {return cArray[i];}
   void              Set(int mPos,T mVal) {cArray[i]=mVal;}
   bool              Copy(T &mArray[])   {return ArrayCopy(mArray,cArray,0,0,cSize)==cSize;}
   T operator [](int mPos) {return cArray[I];}
  };

#endif