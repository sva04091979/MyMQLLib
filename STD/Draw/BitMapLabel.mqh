#ifndef _ND_BITMAP_LABEL_
#define _ND_BITMAP_LABEL_

#include "Rectangle.mqh"
#include "BaseObject.mqh"
#include "BackColor.mqh"
#include "XYObject.mqh"

#define __tBase TXYObject<TRectangleReadOnlyObject<TBaseObject>>

class TBitMapLabel:public __tBase{
   string cFile;
public:
   bool Init(string name);
   bool Show() override;
   bool File(string file);
protected:
   void Init() override;
};
//----------------------------------------------------------
bool TBitMapLabel::Init(string name){
   bool ret=TBaseObject::Init(name,OBJ_BITMAP_LABEL,true);
   return ret;
}
//----------------------------------------------------------
void TBitMapLabel::Init(){
   __tBase::Init();
}
//------------------------------------------------------
bool TBitMapLabel::Show(void){
   bool ret=__tBase::Show();
   if (ret)
      File(cFile);
   return ret;
}
//----------------------------------------------------
bool TBitMapLabel::File(string file){
   bool ret=Set(OBJPROP_BMPFILE,file);
   if (ret){
      cFile=file;
      cXSize=(int)Get(OBJPROP_XSIZE);
      cYSize=(int)Get(OBJPROP_YSIZE);
   }
   return ret;
}

#undef __tBase

#endif