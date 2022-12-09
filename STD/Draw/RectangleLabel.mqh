#include "../pch.mqh"

#ifndef _ND_RECTANGLE_LABEL_
#define _ND_RECTANGLE_LABEL_

#include "Rectangle.mqh"
#include "BaseObject.mqh"
#include "BackColor.mqh"
#include "XYObject.mqh"

#define __tBase TRectangleObject<TXYObject<TBackColor<TBaseObject>>>

class TRectangleLabel:public __tBase{
public:
   bool Init(string name);
   bool Show() override;
protected:
   void Init() override;
};
//----------------------------------------------------------
bool TRectangleLabel::Init(string name){
   bool ret=TBaseObject::Init(name,OBJ_RECTANGLE_LABEL,true);
   return ret;
}
//----------------------------------------------------------
void TRectangleLabel::Init(){
   __tBase::Init();
}
//------------------------------------------------------
bool TRectangleLabel::Show(void){
   bool ret=__tBase::Show();
   return ret;
}

#undef __tBase

#endif 