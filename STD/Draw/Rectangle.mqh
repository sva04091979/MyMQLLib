#ifndef _ND_RECTANGLE_OBJECT_
#define _ND_RECTANGLE_OBJECT_

#include "RectangleReadOnly.mqh"

template<typename Type>
class TRectangleObject:public TRectangleReadOnlyObject<Type>{
public:
   bool XSize(int xSize);
   bool YSize(int ySize);
   int XSize() const {return TRectangleReadOnlyObject<Type>::XSize();}
   int YSize() const {return TRectangleReadOnlyObject<Type>::YSize();}
   bool Show() override;
protected:
   void Init() override;
};
//----------------------------------------------------
template<typename Type>
void TRectangleObject::Init(){
   TRectangleReadOnlyObject<Type>::Init();
}
//----------------------------------------------------
template<typename Type>
bool TRectangleObject::XSize(int xSize){
   bool ret=Set(OBJPROP_XSIZE,xSize);
   if (ret)
      cXSize=xSize;
   return ret;
}
//----------------------------------------------------
template<typename Type>
bool TRectangleObject::YSize(int ySize){
   bool ret=Set(OBJPROP_YSIZE,ySize);
   if (ret)
      cYSize=ySize;
   return ret;
}
//----------------------------------------------------
template<typename Type>
bool TRectangleObject::Show(){
   bool ret=TRectangleReadOnlyObject<Type>::Show();
   if (ret){
      XSize(TRectangleReadOnlyObject<Type>::XSize());
      YSize(TRectangleReadOnlyObject<Type>::YSize());
   }
   return ret;
}


#endif
