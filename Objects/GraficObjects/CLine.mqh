#ifndef _C_LINE_
#define _C_LINE_

#include "CGraficObject.mqh"

class CLine:public CGraficObject
  {
   ENUM_LINE_STYLE   cStyle;
   int               cWidth;
protected:
                     CLine(string mName,ENUM_OBJECT mType,int mWidth,ENUM_LINE_STYLE mStyle,long mChartId,int mSubWindow,datetime mTime,double mPrice);
public:
   bool              SetWidth(int mWidth);
   bool              SetStyle(ENUM_LINE_STYLE mStyle) {return ObjectSetInteger(cChartId,cName,OBJPROP_STYLE,cStyle=mStyle);}
  };
//----------------------------------------------------------
void CLine::CLine(string mName,ENUM_OBJECT mType,int mWidth,ENUM_LINE_STYLE mStyle,long mChartId,int mSubWindow,datetime mTime,double mPrice):
   CGraficObject(mName,mType,mChartId,mSubWindow,mTime,mPrice,0),
   cWidth(0),cStyle(mStyle){
   SetWidth(mWidth);
   SetStyle(mStyle);}
//----------------------------------------------------------------
bool CLine::SetWidth(int mWidth){
   if (mWidth==cWidth) return true;
   else if (!ObjectSetInteger(cChartId,cName,OBJPROP_WIDTH,mWidth)) return false;
   cWidth=mWidth;
   return true;}

#endif