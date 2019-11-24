#ifndef _C_RING_ARRAY_
#define _C_RING_ARRAY_

#define ARRAY_FLAG_FULL 0x1

template<typename T>
class CRingArray
{
   T     cArray[];
   int   cSize;
   int   cStartPos;
   int   cLastPos;
   int   cFlag;
public:
         CRingArray(int mSize);
   virtual inline void  Push(T mValue);
   inline bool   IsFull()  {return bool(cFlag&ARRAY_FLAG_FULL);}
   virtual inline void   SetLast(T mValue) {cArray[cLastPos]=mValue;}
   inline T operator [](int mPos) {int pos=cStartPos+mPos; return cArray[pos<cSize?pos:pos-cSize];}
protected:
   inline void  Write(T mValue);
   inline void  Step();
};
//-------------------------------------------------
template<typename T>
CRingArray::CRingArray(int mSize):
   cSize(ArrayResize(cArray,mSize)),cStartPos(0),cLastPos(0),cFlag(0){}
//---------------------------------------------------
template<typename T>
void CRingArray::Push(T mValue){
   Write(mValue);
   Step();}
//---------------------------------------------------
template<typename T>
void CRingArray::Write(T mValue){
   if (bool(cFlag&ARRAY_FLAG_FULL))
      cArray[cStartPos]=mValue;
   else{
      cArray[cLastPos]=mValue;
      if (cLastPos==cSize-1) cFlag|=ARRAY_FLAG_FULL;
      else ++cLastPos;}}
//---------------------------------------------------
template<typename T>
void CRingArray::Step(){
   if (bool(cFlag&ARRAY_FLAG_FULL)){
      if (++cStartPos==cSize) cStartPos=0;
      if (++cLastPos==cSize) cLastPos=0;}}

#endif