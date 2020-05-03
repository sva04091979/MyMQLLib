#ifndef _C_BUTTON_
#define _C_BUTTON_

#include "CPointObject.mqh"

class CButton:public CField
  {
public:
                     CButton(string mName,
                             long mChartId,
                             int mSubWindow,
                             long mX,
                             long mY,
                             long mXSize,
                             long mYSize,
                             int mFlag=0);
   bool              IsPress()   {CheckPress(); return _Flag.Check(BUTTON_FLAG_PRESS);}
   bool              SetState(bool mIsPress);
   bool              Press();
   bool              ChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam) override;
private:
   void              CheckPress() {if (bool(GetInt(OBJPROP_STATE))) _Flag+=BUTTON_FLAG_PRESS; else _Flag-=BUTTON_FLAG_PRESS;}
  };
//------------------------------------------------------------
CButton::CButton(string mName,long mChartId,int mSubWindow,long mX,long mY,long mXSize,long mYSize,int mFlag):
   CField(mName,OBJ_BUTTON,mChartId,mSubWindow,mX,mY,mXSize,mYSize,mFlag){
   if (!SetInt(OBJPROP_STATE,_Flag.Check(BUTTON_FLAG_PRESS))) CheckPress();}
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
   if (!CGraficObject::ChartEvent(id,lparam,dparam,sparam)) return false;
   switch (id){
      case CHARTEVENT_OBJECT_CLICK: if (_Flag.Check(OBJECT_FLAG_SELECTABLE)) Press();
                                    else if ((bool)GetInt(OBJPROP_STATE)) _Flag+=BUTTON_FLAG_PRESS; else _Flag-=BUTTON_FLAG_PRESS;
                                    break;
   }
   return true;}

#endif