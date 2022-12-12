#ifndef _ND_READONLY_OBJECT_
#define _ND_READONLY_OBJECT_

template<typename Type>
class TReadOnly:public Type{
   bool cReadOnly;
public:
   bool ReadOnly() const {return cReadOnly;}
   bool ReadOnly(bool readOnly);
   bool Show() override;
protected:
   void Init() override; 
};
//----------------------------------------------------
template<typename Type>
void TReadOnly::Init(){
   Type::Init();
   cReadOnly=(bool)Get(OBJPROP_READONLY);
}
//----------------------------------------------------
template<typename Type>
bool TReadOnly::ReadOnly(bool readOnly){
   bool ret=Set(OBJPROP_READONLY,readOnly);
   if (ret)
      cReadOnly=readOnly;
   return ret;
}
//----------------------------------------------------
template<typename Type>
bool TReadOnly::Show(){
   bool ret=Type::Show();
   if (ret){
      ReadOnly(cReadOnly);
   }
   return ret;
}

#endif