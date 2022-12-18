#ifndef _ND_TEXT_OBJECT_
#define _ND_TEXT_OBJECT_

#include "Color.mqh"

template<typename Type>
class TTextObject:public Type{
   string cText;
   string cFont;
   int cFontSize;
public:
   bool Text(string text);
   bool Font(string font);
   bool FontSize(int fontSize);
   string Text() {return cText=Get(OBJPROP_TEXT);}
   string Font() const {return cFont;}
   int FontSize() const {return cFontSize;}
   bool Show() override;
protected:
   void Init() override; 
};
//----------------------------------------------------
template<typename Type>
void TTextObject::Init(){
   Type::Init();
   cText=Get(OBJPROP_TEXT);
   cFont=Get(OBJPROP_FONT);
   cFontSize=(int)Get(OBJPROP_FONTSIZE);
}
//----------------------------------------------------
template<typename Type>
bool TTextObject::Text(string text){
   bool ret=Set(OBJPROP_TEXT,text);
   if (ret)
      cText=text;
   return ret;
}
//----------------------------------------------------
template<typename Type>
bool TTextObject::Font(string font){
   bool ret=Set(OBJPROP_FONT,font);
   if (ret)
      cFont=font;
   return ret;
}
//----------------------------------------------------
template<typename Type>
bool TTextObject::FontSize(int fontSize){
   bool ret=Set(OBJPROP_FONTSIZE,fontSize);
   if (ret)
      cFontSize=fontSize;
   return ret;
}
//----------------------------------------------------
template<typename Type>
bool TTextObject::Show(){
   bool ret=Type::Show();
   if (ret){
      Text(cText);
      Font(cFont);
      FontSize(cFontSize);
   }
   return ret;
}

#endif