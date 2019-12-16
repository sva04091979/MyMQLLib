#ifndef _C_WRAPERS_CONTROL_
#define _C_WRAPERS_CONTROL_

#include <MyMQLLib\Objects\Array\CArray.mqh>
#include "CSharedWrape.mqh"
#include <MyMQLLib\Objects\Array\CTuple.mqh>

#define Unit tuple<CWrape<T>*,uint>

template<typename T>
class CWrapersControl
  {
   CArray<Unit>      cArray;
   CArray<uint>      cFreeIndex;
   uint              cBlockSize;
public:
                     CWrapersControl():CWrapersControl(64){}
                     CWrapersControl(uint mBlockSize);
                    ~CWrapersControl();
   CWrape<T>*        Get();
private:
   bool              AddNewBlock();
  };
//--------------------------------------------------------
template<typename T>
CWrapersControl::CWrapersControl(uint mBlockSize):cBlockSize(mBlockSize){
   AddNewBlock();}
//----------------------------------------------------------
template<typename T>
CWrapersControl::AddNewBlock(){
   int size=cArray.GetSize(),
       newSize=cArray.Resize(size+mBlockSize);
   if (size>newSize) return false;
   for (int i=size;i<newSize;cArray[i++]=new CWrape<T>);
   size=cFreeIndex.GetSize();
   newSize=cFreeIndex.Resize(size+mBlockSize);
   if (size>newSize) return false;
   for (int i=size;i<newSize;++i) cFreeIndex.Set(i,i);
   return true;}
//----------------------------------------------------------
template<typename T>
CWrape<T>* CWrapersControl::Get(){
   if (cFreeIndex.IsEmpty()&&!AddNewBlock()) return NULL;
   else return cArray[PopIndex()].Get();}



#undef Unit

#endif