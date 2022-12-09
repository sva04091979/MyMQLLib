#ifndef _ND_BUTTON_
#define _ND_BUTTON_

#include "Rectangle.mqh"
#include "BaseObject.mqh"
#include "BackColor.mqh"
#include "TextObject.mqh"
#include "XYObject.mqh"
#include "Color.mqh"

#define __tBase TRectangleObject<TBackColor<TColor<TXYObject<TTextObject<TBaseObject>>>>>

class TButton:public __tBase{
   bool cState;
public:
   bool Init(long chartId,int subWindow);
   bool Init(string name);
   bool Press(bool isPress);
   bool Press();
   bool IsPress() const {return cState;}
   bool Show() override;
protected:
   void Init() override;
};
//----------------------------------------------------------
bool TButton::Init(string name){
   bool ret=TBaseObject::Init(name,OBJ_BUTTON,true);
   return ret;
}
//----------------------------------------------------------
void TButton
//----------------------------------------------------------
void TButton::Init(){
   __tBase::Init();
   cState=Get(OBJPROP_STATE);
}
//---------------------------------------------------------
bool TButton::Press(bool isPress){
   bool ret=Set(OBJPROP_STATE,isPress);
   if (ret){
      cState=isPress;
   }
   return ret;
}
//---------------------------------------------------------
bool TButton::Press(void){
   Press(!cState);
   return cState;
}
//------------------------------------------------------
bool TButton::Show(void){
   bool ret=__tBase::Show();
   if (ret){
      Press(cState);
   }
   return ret;
}

#undef __tBase

#endif 