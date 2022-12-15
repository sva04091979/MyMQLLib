#ifndef _ND_RECTANGLE_LABEL_
#define _ND_RECTANGLE_LABEL_

#include "Rectangle.mqh"
#include "BaseObject.mqh"
#include "BackColor.mqh"
#include "XYObject.mqh"

#define __tBase TRectangleObject<TXYObject<TBackColor<TBorderColor<TBaseObject>>>>

class TRectangleLabel:public __tBase{
public:
   bool Create(long chartId,int subWindow,string name);
   bool Create(string name);
   bool Show() override;
protected:
   void Init() override;
};
//----------------------------------------------------------
bool TRectangleLabel::Create(long chartId,int subWindow,string name){
   return TBaseObject::Create(chartId,subWindow,name,OBJ_RECTANGLE_LABEL,true);
}
//----------------------------------------------------------
bool TRectangleLabel::Create(string name){
   return Create(0,0,name);
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