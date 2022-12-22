template<typename Type>
class TWidth:public Type{
   int cWidth;
public:
   int Width() const {return cWidth;}
   bool Width(int width);
   bool Show(int subW) override;
protected:
   void Init() override; 
};
//----------------------------------------------------
template<typename Type>
void TWidth::Init(){
   Type::Init();
   cWidth=(int)Get(OBJPROP_WIDTH);
}
//----------------------------------------------------
template<typename Type>
bool TWidth::Width(int width){
   bool ret=Set(OBJPROP_WIDTH,width);
   if (ret)
      cWidth=width;
   return ret;
}
//----------------------------------------------------
template<typename Type>
bool TWidth::Show(int subW){
   bool ret=Type::Show(subW);
   if (ret){
      Width(cWidth);
   }
   return ret;
}
