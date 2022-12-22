#ifndef _ND_RECTANGLE_OBJECT_
#define _ND_RECTANGLE_OBJECT_

#include "RectangleReadOnly.mqh"

template<typename Type>
class TRectangleObject:public Type{
protected:
   int cXSize;
   int cYSize;
public:
   bool XSize(int xSize);
   bool YSize(int ySize);
   int XSize() const {return cXSize;}
   int YSize() const {return cYSize;}
   bool Show(int subW) override;
protected:
   void Init() override;
};
//----------------------------------------------------
template<typename Type>
void TRectangleObject::Init(){
   Type::Init();
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
bool TRectangleObject::Show(int subW){
   bool ret=Type::Show(subW);
   if (ret){
      XSize(cXSize);
      YSize(cYSize);
   }
   return ret;
}


#endif
