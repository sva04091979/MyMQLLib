template<typename Type>
class TStyle:public Type{
   ENUM_LINE_STYLE cStyle;
public:
   ENUM_LINE_STYLE Style() const {return cStyle;}
   bool Style(ENUM_LINE_STYLE style);
   bool Show(int subW) override;
protected:
   void Init() override; 
};
//----------------------------------------------------
template<typename Type>
void TStyle::Init(){
   Type::Init();
   cStyle=(ENUM_LINE_STYLE)Get(OBJPROP_STYLE);
}
//----------------------------------------------------
template<typename Type>
bool TStyle::Style(ENUM_LINE_STYLE style){
   bool ret=Set(OBJPROP_COLOR,style);
   if (ret)
      cStyle=style;
   return ret;
}
//----------------------------------------------------
template<typename Type>
bool TStyle::Show(int subW){
   bool ret=Type::Show(subW);
   if (ret){
      Style(cStyle);
   }
   return ret;
}
