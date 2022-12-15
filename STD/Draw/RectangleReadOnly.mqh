#ifndef _ND_RECTANGLE_READ_ONLY_OBJECT_
#define _ND_RECTANGLE_READ_ONLY_OBJECT_

template<typename Type>
class TRectangleReadOnlyObject:public Type{
public:
   virtual int XSize() const {return (int)Get(OBJPROP_XSIZE);}
   int YSize() const {return (int)Get(OBJPROP_YSIZE);}
   bool Show() override;
protected:
   void Init() override;
};
//----------------------------------------------------
template<typename Type>
void TRectangleReadOnlyObject::Init(){
   Type::Init();
}
//----------------------------------------------------
template<typename Type>
bool TRectangleReadOnlyObject::Show(){
   return Type::Show();
}


#endif
