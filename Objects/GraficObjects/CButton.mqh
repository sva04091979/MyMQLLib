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
   bool              IsPress()   {return _Flag.Check(BUTTON_FLAG_PRESS);}
   bool              SetState(bool mIsPress);
   bool              SetXSize(long mXSize) {if (SetInt(OBJPROP_XSIZE,cXSize=mXSize)) return true; else {cXSize=GetInt(OBJPROP_XSIZE); return false;}}
   bool              SetYSize(long mYSize) {if (SetInt(OBJPROP_YSIZE,cYSize=mYSize)) return true; else {cYSize=GetInt(OBJPROP_YSIZE); return false;}}
   bool              SetXYSize(long mXSize,long mYSize)  {return (int)SetXSize(mXSize)+(int)SetYSize(mYSize)==2;}
   bool              Press();
   bool              ChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
private:
   void              CheckPress() {if (bool(GetInt(OBJPROP_STATE))) _Flag+=BUTTON_FLAG_PRESS; else _Flag-=BUTTON_FLAG_PRESS;}
  };
//------------------------------------------------------------
CButton::CButton(string mName,long mChartId,int mSubWindow,long mX,long mY,long mXSize,long mYSize,int mFlag):
   CPointObject(mName,OBJ_BUTTON,mChartId,mSubWindow,mX,mY,mFlag),
   cText(NULL){
   if (!SetInt(OBJPROP_STATE,_Flag.Check(BUTTON_FLAG_PRESS))) CheckPress();
   SetXYSize(mXSize,mYSize);}
//---------------------------------------------------------------------------------------------------------------
bool CButton::SetState(bool mIsPress){
   bool res=SetInt(OBJPROP_STATE,mIsPress);
   if (res){
      if (mIsPress) _Flag+=BUTTON_FLAG_PRESS; else _Flag-=BUTTON_FLAG_PRESS;}
   else CheckPress();
   return res;}
//----------------------------------------------------------------------------------------------------------------
bool CButton::Press(){
   if (!SetInt(OBJPROP_STATE,!_Flag.CheckSwitch(BUTTON_FLAG_PRESS))) _Flag^=BUTTON_FLAG_PRESS;
   return _Flag.Check(BUTTON_FLAG_PRESS);}
//-----------------------------------------------------------------------------------------------------------------
bool CButton::ChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam){
   if (!Equal(sparam)) return false;
   switch (id){
      case CHARTEVENT_OBJECT_CLICK: if (_Flag.Check(OBJECT_FLAG_SELECTABLE)) Press();
                                    else if ((bool)GetInt(OBJPROP_STATE)) _Flag+=BUTTON_FLAG_PRESS; else _Flag-=BUTTON_FLAG_PRESS;
                                    break;
   }
   return true;}

#endif