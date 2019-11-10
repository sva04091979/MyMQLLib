#ifndef _C_ARRAY_
#define _C_ARRAY_

#define I (mPos<cSize?mPos:-1)

template<typename T>
class CArray
  {
   T                 cArray[];
   int               cSize;
   int               cMemSize;
public:
                     CArray(void):cSize(0),cMemSize(0){}
   int               GetSize()   {return cSize;}
   T                 Get(int mPos)  {return cArray[I];}
   void              Set(T mVal,int mPos) {cArray[I]=mVal;}
   bool              IsEmpty()   {return cSize==0;}
   bool              PushBack(T mVal);
   bool              Push(T mVal,int mPos);
   bool              Copy(T &mArray[])   {return ArrayCopy(mArray,cArray,0,0,cSize)==cSize;}
   void              Delete(int mPos)  {ShiftLeft(mPos,1);}
   int               Resize(int mNewSize);
   T operator [](int mPos) {return Get(mPos);}
private:
   bool              Alloc(int mNewSize);
   void              ShiftRight(int mPos,uint mShift);
   void              ShiftLeft(int mPos,uint mShift);
  };
//-----------------------------------------------------------------
template<typename T>
int CArray::Resize(int mNewSize){
   if (mNewSize<cMemSize) return cSize=mNewSize;
   else if (!Alloc(mNewSize)) return -1;
   else return cSize=mNewSize;}
//---------------------------------------------------------------------
template<typename T>
bool CArray::Alloc(int mNewSize){
   if (!cMemSize) cMemSize=1;
   while(cMemSize<mNewSize){
      if (cMemSize<0x40000000) cMemSize<<=1;
      else cMemSize=INT_MAX;}
   return (cMemSize=ArrayResize(cArray,cMemSize))>=mNewSize;}
//---------------------------------------------------------------------
template<typename T>
bool CArray::PushBack(T mVal){
   if (cSize==INT_MAX) return false;
   else ++cSize;
   if (cSize>cMemSize&&!Alloc(cSize)) {--cSize; return false;}
   cArray[cSize-1]=mVal;
   return true;}
//----------------------------------------------------------------------
template<typename T>
bool CArray::Push(T mVal,int mPos){
   if (cSize==INT_MAX) return false;
   else ++cSize;
   if (cSize>cMemSize&&!Alloc(cSize)) {--cSize; return false;}
   ShiftRight(mPos,1);
   cArray[mPos]=mVal;
   return true;}
//----------------------------------------------------------------------------
template<typename T>
void CArray::ShiftRight(int mPos,uint mShift){
   int end=mPos+(int)mShift;
   for (int i=cSize-1;i>=end;--i) cArray[i]=cArray[i-mShift];}
//----------------------------------------------------------------------------
template<typename T>
void CArray::ShiftLeft(int mPos,uint mShift){
   cSize-=(int)mShift;
   for (int i=mPos;i<cSize;++i) cArray[i]=cArray[i+mShift];}

#endif