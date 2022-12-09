#ifndef _ND_RECTANGLE_READ_ONLY_OBJECT_
#define _ND_RECTANGLE_READ_ONLY_OBJECT_

template<typename Type>
class TRectangleReadOnlyObject:public Type{
protected:
   int cXSize;
   int cYSize;
public:
   int XSize() const {return cXSize;}
   int YSize() const {return cYSize;}
   bool Show() override;
protected:
   void Init() override;
};
//----------------------------------------------------
template<typename Type>
void TRectangleReadOnlyObject::Init(){
   Type::Init();
   cXSize=(int)Get(OBJPROP_XSIZE);
   cYSize=(int)Get(OBJPROP_YSIZE);
}
//----------------------------------------------------
template<typename Type>
bool TRectangleReadOnlyObject::Show(){
   return Type::Show();
}


#endif
