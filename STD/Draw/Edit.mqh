#ifndef _ND_EDIT_
#define _ND_EDIT_

#include "Rectangle.mqh"
#include "BaseObject.mqh"
#include "BackColor.mqh"
#include "BorderColor.mqh"
#include "TextObject.mqh"
#include "XYObject.mqh"
#include "Color.mqh"

#define __tBase TRectangleObject<TBackColor<TBorderColor<TXYObject<TTextObject<TBaseObject>>>>>

class TEdit:public __tBase{
   ENUM_ALIGN_MODE cAlignMode;
public:
   ENUM_ALIGN_MODE Align() const {return cAlignMode;}
   bool Align(ENUM_ALIGN_MODE align);
   bool Init(string name);
   bool Show() override;
protected:
   void Init() override;
};
//----------------------------------------------------------
bool TEdit::Init(string name){
   bool ret=TBaseObject::Init(name,OBJ_EDIT,true);
   return ret;
}
//----------------------------------------------------------
void TEdit::Init(){
   __tBase::Init();
   cAlignMode=(ENUM_ALIGN_MODE)Get(OBJPROP_ALIGN);
}
//------------------------------------------------------
bool TEdit::Show(void){
   bool ret=__tBase::Show();
   if(ret){
      Align(cAlignMode);
   }
   return ret;
}
//---------------------------------------------------------
bool TEdit::Align(ENUM_ALIGN_MODE align){
   bool ret=Set(OBJPROP_ALIGN,align);
   if (ret){
      cAlignMode=align;
   }
   return ret;
}

#undef __tBase

#endif 