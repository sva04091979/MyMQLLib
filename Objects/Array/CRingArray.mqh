#ifndef _C_RING_ARRAY_
#define _C_RING_ARRAY_

#define ARRAY_FLAG_FULL 0x1

template<typename T>
class CRingArray
{
   T     cArray[];
   T     cSumm;
   int   cSize;
   int   cStartPos;
   int   cLastPos;
   int   cMax;
   int   cMin;
   int   cFlag;
public:
         CRingArray(int mSize);
   inline void  Push(T mValue);
   inline T Max()  {return cArray[cMax];}
   inline T Min()  {return cArray[cMin];}
   inline T Med()  {return cSumm/cSize;}
   inline bool   IsFull()  {return bool(cFlag&ARRAY_FLAG_FULL);}
   inline void   SetLast(T mValue) {cSumm+=mValue-cArray[cLastPos]; cArray[cLastPos]=mValue;}
   inline T operator [](int mPos) {int pos=cStartPos+mPos; return cArray[pos<cSize?pos:pos-cSize];}
private:
   inline void CheckExtreme(const T &mValue);
   inline void CheckMax(const T &mValue);
   inline void CheckMin(const T &mValue);
};
//-------------------------------------------------
template<typename T>
CRingArray::CRingArray(int mSize):
   cSumm(0.0),cSize(ArrayResize(cArray,mSize)),cStartPos(0),cLastPos(0),cMax(0),cMin(0),cFlag(0){}
//---------------------------------------------------
template<typename T>
void CRingArray::Push(T mValue){
   if (bool(cFlag&ARRAY_FLAG_FULL)){
      cSumm+=mValue-cArray[cStartPos];
      cArray[cStartPos]=mValue;}
   else{
      cSumm+=mValue;
      cArray[cLastPos++]=mValue;
      if (cLastPos==cSize){
         --cLastPos;
         cFlag|=ARRAY_FLAG_FULL;}}
   CheckExtreme(mValue);}
//-----------------------------------------------------
template<typename T>
void CRingArray::CheckExtreme(const T &mValue){
   CheckMax(mValue);
   CheckMin(mValue);
   if (bool(cFlag&ARRAY_FLAG_FULL)){
      if (++cStartPos==cSize) cStartPos=0;
      if (++cLastPos==cSize) cLastPos=0;}}
//-----------------------------------------------------
template<typename T>
void CRingArray::CheckMax(const T &mValue){
   if (cStartPos==cMax) cMax=ArrayMaximum(cArray,#ifdef __MQL5__ 0,#endif !(cFlag&ARRAY_FLAG_FULL)?cLastPos:-1);
   else if (mValue>cArray[cMax]) cMax=cStartPos;}
//-----------------------------------------------------
template<typename T>
void CRingArray::CheckMin(const T &mValue){
   if (cStartPos==cMin) cMin=ArrayMinimum(cArray,#ifdef __MQL5__ 0,#endif !(cFlag&ARRAY_FLAG_FULL)?cLastPos:-1);
   else if (mValue<cArray[cMin]) cMin=cStartPos;}


#undef ARRAY_FLAG_FULL

#endif