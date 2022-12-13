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
   bool Create(long chartId,int subWindow,string name);
   bool Create(string name);
   bool Press(bool isPress);
   bool Press();
   bool IsPress() {return cState=Get(OBJPROP_STATE);}
   bool Show() override;
protected:
   void Init() override;
};
//----------------------------------------------------------
bool TButton::Create(string name){
   bool ret=Create(0,0,name,OBJ_BUTTON,true);
   return ret;
}
//----------------------------------------------------------
bool TButton::Create(long chartId,int subWindow,string name){
   return TBaseObject::Create(chartId,subWindow,name,OBJ_BUTTON,true);
}
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
   cState=Get(OBJPROP_STATE);
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