#ifndef _C_VECTOR_
#define _C_VECTOR_

#ifndef __NO_INDEX_CONTROL__
   #define I (mPos<cSize?mPos:-1)
#else
   #define I mPos
#endif

#define MAX_SIZE INT_MAX
#define HALF_MAX 0x40000000

template<typename T>
class CVector
  {
   T                 CVector[];
   int               cSize;
   int               cMemSize;
public:
                     CVector(void):cSize(0),cMemSize(0){}
   int               GetSize()   {return cSize;}
   T                 Get(int mPos)  {return CVector[I];}
   void              Set(int mPos,T mVal) {CVector[I]=mVal;}
   bool              IsEmpty()   {return cSize==0;}
   bool              PushBack(T mVal);
   bool              PushFront(T mVal) {Push(mVal,0);}
   bool              Push(T mVal,int mPos);
   bool              Copy(T &mArray[])   {return ArrayCopy(mArray,CVector,0,0,cSize)==cSize;}
   void              Delete(int mPos)  {ShiftLeft(mPos,1);}
   int               Resize(int mNewSize);
   T                 Pop(int mPos)  {T out=CVector[I]; ShiftLeft(mPos); return out;}
   T                 PopFront()  {return Pop(0);}
   T                 PopBack()   {return Pop(cSize-1);}
   T operator [](int mPos) {return CVector[I];}
private:
   bool              Alloc(int mNewSize);
   void              ShiftRight(int mPos,uint mShift);
   void              ShiftLeft(int mPos,uint mShift);
  };
//-----------------------------------------------------------------
template<typename T>
int CVector::Resize(int mNewSize){
   if (mNewSize<cMemSize) return cSize=mNewSize;
   else if (!Alloc(mNewSize)) return -1;
   else return cSize=mNewSize;}
//---------------------------------------------------------------------
template<typename T>
bool CVector::Alloc(int mNewSize){
   if (!cMemSize) cMemSize=1;
   while(cMemSize<mNewSize){
      if (cMemSize<HALF_MAX) cMemSize<<=1;
      else cMemSize=MAX_SIZE;}
   return (cMemSize=ArrayResize(CVector,cMemSize))>=mNewSize;}
//---------------------------------------------------------------------
template<typename T>
bool CVector::PushBack(T mVal){
   if (cSize==MAX_SIZE) return false;
   else ++cSize;
   if (cSize>cMemSize&&!Alloc(cSize)) {--cSize; return false;}
   CVector[cSize-1]=mVal;
   return true;}
//----------------------------------------------------------------------
template<typename T>
bool CVector::Push(T mVal,int mPos){
   if (cSize==MAX_SIZE) return false;
   else ++cSize;
   if (cSize>cMemSize&&!Alloc(cSize)) {--cSize; return false;}
   ShiftRight(mPos,1);
   CVector[mPos]=mVal;
   return true;}
//----------------------------------------------------------------------------
template<typename T>
void CVector::ShiftRight(int mPos,uint mShift){
   int end=mPos+(int)mShift;
   for (int i=cSize-1;i>=end;--i) CVector[i]=CVector[i-mShift];}
//----------------------------------------------------------------------------
template<typename T>
void CVector::ShiftLeft(int mPos,uint mShift){
   cSize-=(int)mShift;
   for (int i=mPos;i<cSize;++i) CVector[i]=CVector[i+mShift];}

#endif