#ifndef _ND_COLOR_OBJECT_
#define _ND_COLOR_OBJECT_

template<typename Type>
class TColor:public Type{
   color cColor;
public:
   color Color() const {return cColor;}
   bool Color(color _color);
   bool Show(int subW) override;
protected:
   void Init() override; 
};
//----------------------------------------------------
template<typename Type>
void TColor::Init(){
   Type::Init();
   cColor=(color)Get(OBJPROP_COLOR);
}
//----------------------------------------------------
template<typename Type>
bool TColor::Color(color _color){
   bool ret=Set(OBJPROP_COLOR,_color);
   if (ret)
      cColor=_color;
   return ret;
}
//----------------------------------------------------
template<typename Type>
bool TColor::Show(int subW){
   bool ret=Type::Show(subW);
   if (ret){
      Color(cColor);
   }
   return ret;
}

#endif