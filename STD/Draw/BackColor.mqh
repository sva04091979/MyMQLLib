#ifndef _ND_BACK_COLOR_OBJECT_
#define _ND_BACK_COLOR_OBJECT_

template<typename Type>
class TBackColor:public Type{
   color cBackColor;
public:
   color BackColor() const {return cBackColor;}
   bool BackColor(color _color);
   bool Show() override;
protected:
   void Init() override; 
};
//----------------------------------------------------
template<typename Type>
void TBackColor::Init(){
   Type::Init();
   cBackColor=(color)Get(OBJPROP_BGCOLOR);
}
//----------------------------------------------------
template<typename Type>
bool TBackColor::BackColor(color _color){
   bool ret=Set(OBJPROP_BGCOLOR,_color);
   if (ret)
      cBackColor=_color;
   return ret;
}
//----------------------------------------------------
template<typename Type>
bool TBackColor::Show(){
   bool ret=Type::Show();
   if (ret){
      BackColor(cBackColor);
   }
   return ret;
}

#endif