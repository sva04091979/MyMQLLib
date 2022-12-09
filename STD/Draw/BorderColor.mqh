#ifndef _ND_BORDER_COLOR_OBJECT_
#define _ND_BORDER_COLOR_OBJECT_

template<typename Type>
class TBorderColor:public Type{
   color cBorderColor;
public:
   color BorderColor() const {return cBorderColor;}
   bool BorderColor(color _color);
   bool Show() override;
protected:
   void Init() override; 
};
//----------------------------------------------------
template<typename Type>
void TBorderColor::Init(){
   Type::Init();
   cBorderColor=(color)Get(OBJPROP_BGCOLOR);
}
//----------------------------------------------------
template<typename Type>
bool TBorderColor::BorderColor(color _color){
   bool ret=Set(OBJPROP_BORDER_COLOR,_color);
   if (ret)
      cBorderColor=_color;
   return ret;
}
//----------------------------------------------------
template<typename Type>
bool TBorderColor::Show(){
   bool ret=Type::Show();
   if (ret){
      BorderColor(cBorderColor);
   }
   return ret;
}

#endif