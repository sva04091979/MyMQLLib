#ifndef _C_RING_ARRAY_
#define _C_RING_ARRAY_

#include <MyMQLLib\Define\MQLDefine.mqh>

template<typename T,typename Type>
class CRingBase
{
protected:
   T     cArray[];
   uint  cSize;
   uint  cCount;
   uint  cStartPos;
   uint  cLastPos;
   int   cPos;
protected:
         CRingBase(uint mSize);
public:
   T operator [](int mPos) {uint pos=(cStartPos+mPos)%cSize; return cArray[pos];}
   Type* const OverloadPtr(int mPos) {cPos=mPos<(int)cCount?mPos:-1; return &this;}
   T Back() {return cArray[cLastPos];}
   T Front() {return cArray[cStartPos];}
   uint Count() {return cCount;}
   uint Size() {return cSize;}
};
//----------------------------------------------------------------------------------
template<typename T,typename Type>
CRingBase::CRingBase(uint mSize):cSize(ArrayResize(cArray,mSize)),cCount(0),cStartPos(0),cLastPos(0),cPos(-1){}
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
template<typename T>
class CRingNumeric:public CRingBase<T,CRingNumeric>
{
   double   cAvrg;
   T        cSumm;
public:
         CRingNumeric(uint mSize):CRingBase<T,CRingNumeric>(mSize),cAvrg(0.0),cSumm(0){}
   CRingNumeric* const  Push(T mValue) {return cCount<cSize?_PushStart(mValue):_Push(mValue);}
//   T     Summ()   {return cSumm;}
//   double Avrg()  {return cAvrg;}
   T operator=(T mValue);
   T Back(T mValue) {return _p(cLastPos)=mValue;}
   T Front(T mValue) {return _p(cStartPos)=mValue;}
   T Max() {return cArray[ArrayMaximum(cArray)];}
   T Min() {return cArray[ArrayMinimum(cArray)];}
private:
   CRingNumeric<T>* const _PushStart(T mValue);
   CRingNumeric<T>* const _Push(T mValue);
};
//---------------------------------------------------
template<typename T>
CRingNumeric* const CRingNumeric::_PushStart(T mValue){
   cLastPos=cCount++;
   cArray[cLastPos]=mValue;
//   cSumm+=mValue;
//   cAvrg=(double)cSumm/cCount;
   return &this;}
//---------------------------------------------------
template<typename T>
CRingNumeric* const CRingNumeric::_Push(T mValue){
//   cSumm+=mValue-cArray[cStartPos];
//   cAvrg=(double)cSumm/cCount;
   cArray[cStartPos]=mValue;
   ++cStartPos;
   ++cLastPos;
   cStartPos%=cSize;
   cLastPos%=cSize;
   return &this;}
//---------------------------------------------------
template<typename T>
T CRingNumeric::operator=(T mValue){
//   cSumm+=mValue-cArray[cPos];
//   cAvrg=(double)cSumm/cCount;   
   cArray[cPos]=mValue;
   cPos=-1;
   return mValue;}

#endif