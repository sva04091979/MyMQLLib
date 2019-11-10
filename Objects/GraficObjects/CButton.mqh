#ifndef _C_BUTTON_
#define _C_BUTTON_

#include "CPointObject.mqh"

class CButton:public CPointObject
  {
   string            cText;
   long              cXSize;
   long              cYSize;
public:
                     CButton(string mName,
                             long mChartId,
                             int mSubWindow,
                             long mX,
                             long mY,
                             long mXSize,
                             long mYSize,
                             int mFlag=0);
   bool              SetText(string mText) {if (SET_STRING(OBJPROP_TEXT,cText=mText)) return true; else {cText=GET_STRING(OBJPROP_TEXT); return false;}}
   bool              IsPress()   {return bool(cFlag&BUTTON_FLAG_PRESS);}
   bool              SetState(bool mIsPress);
   bool              SetXSize(long mXSize) {if (SET_INTEGER(OBJPROP_XSIZE,cXSize=mXSize)) return true; else {cXSize=GET_INTEGER(OBJPROP_XSIZE); return false;}}
   bool              SetYSize(long mYSize) {if (SET_INTEGER(OBJPROP_YSIZE,cYSize=mYSize)) return true; else {cYSize=GET_INTEGER(OBJPROP_YSIZE); return false;}}
   bool              SetXYSize(long mXSize,long mYSize)  {return (int)SetXSize(mXSize)+(int)SetYSize(mYSize)==2;}
   bool              Press();
   bool              ChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
private:
   void              CheckPress() {if (bool(GET_INTEGER(OBJPROP_STATE))) cFlag|=BUTTON_FLAG_PRESS; else cFlag&=~BUTTON_FLAG_PRESS;}
  };
//------------------------------------------------------------
CButton::CButton(string mName,long mChartId,int mSubWindow,long mX,long mY,long mXSize,long mYSize,int mFlag):
   CPointObject(mName,OBJ_BUTTON,mChartId,mSubWindow,mX,mY,mFlag),
   cText(NULL){
   if (!SET_INTEGER(OBJPROP_STATE,bool(cFlag&BUTTON_FLAG_PRESS))) CheckPress();
   SetXYSize(mXSize,mYSize);}
//---------------------------------------------------------------------------------------------------------------
bool CButton::SetState(bool mIsPress){
   bool res=SET_INTEGER(OBJPROP_STATE,mIsPress);
   if (res)
      if (mIsPress) cFlag|=BUTTON_FLAG_PRESS; else CheckPress();
   return res;}
//----------------------------------------------------------------------------------------------------------------
bool CButton::Press(){
   cFlag^=BUTTON_FLAG_PRESS;
   if (!SET_INTEGER(OBJPROP_STATE,bool(cFlag&BUTTON_FLAG_PRESS))) cFlag^=BUTTON_FLAG_PRESS;
   return bool(cFlag&BUTTON_FLAG_PRESS);}
//-----------------------------------------------------------------------------------------------------------------
bool CButton::ChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam){
   if (!Equal(sparam)) return false;
   switch (id){
      case CHARTEVENT_OBJECT_CLICK: Press(); break;
   }
   return true;}

#endif