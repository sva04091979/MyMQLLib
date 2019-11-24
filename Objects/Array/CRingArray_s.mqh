#ifndef _C_RING_ARRAY_S_
#define _C_RING_ARRAY_S_

#include "CRingArray.mqh"

template<typename T>
class CRingArray_S:public CRingArray<T>{
   T     cSumm;
   int   cMax;
   int   cMin;
public:
                  CRingArray_S(int mSize);
   inline void    Push(T mValue);
   inline T Max()  {return cArray[cMax];}
   inline T Min()  {return cArray[cMin];}
   inline T Med()  {return cSumm/cSize;}
   inline void    SetLast(T mValue) {cSumm+=mValue-cArray[cLastPos]; CRingArray<T>::SetLast(mValue);}
private:
   inline void    CheckMax(const T &mValue);
   inline void    CheckMin(const T &mValue);         
};
//--------------------------------------------------
template<typename T>
CRingArray_S::CRingArray_S(int mSize):
   CRingArray<T>(mSize),cSumm(0),cMax(0),cMin(0){}
//--------------------------------------------------
template<typename T>
void CRingArray_S::Push(T mValue){
   Write(mValue);
   cSumm+=bool(cFlag&ARRAY_FLAG_FULL)?mValue-cArray[cStartPos]:mValue;
   CheckMax(mValue);
   CheckMin(mValue);
   Step();}
//-----------------------------------------------------
template<typename T>
void CRingArray_S::CheckMax(const T &mValue){
   if (cStartPos==cMax) cMax=bool(cFlag&ARRAY_FLAG_FULL)?ArrayMaximum(cArray,#ifdef __MQL5__ 0,#endif !(cFlag&ARRAY_FLAG_FULL)?cLastPos:-1):
                             mValue>cArray[cMax]?cLastPos:cMax;
   else if (mValue>cArray[cMax]) cMax=cStartPos;}
//-----------------------------------------------------
template<typename T>
void CRingArray_S::CheckMin(const T &mValue){
   if (cStartPos==cMin) cMin=bool(cFlag&ARRAY_FLAG_FULL)?ArrayMinimum(cArray,#ifdef __MQL5__ 0,#endif !(cFlag&ARRAY_FLAG_FULL)?cLastPos:-1):
                             mValue<cArray[cMin]?cLastPos:cMin;
   else if (mValue<cArray[cMin]) cMin=cStartPos;}
   
#endif