#ifndef _C_POINT_OBJECT_
#define _C_POINT_OBJECT_

#include "CGraficObject.mqh"

class CPointObject:public CGraficObject
  {
   long              cX;
   long              cY;
   ENUM_BASE_CORNER  cBaseCorner;
public:
                     CPointObject(string mName,
                                  ENUM_OBJECT mType,
                                  long mChartId,
                                  int mSubWindow,
                                  long mX,
                                  long mY,
                                  int mFlag);
   bool              SetX(long mX) {if (SetInt(OBJPROP_XDISTANCE,cX=mX)) return true; else {cX=GetInt(OBJPROP_XDISTANCE); return false;}}
   bool              SetY(long mY) {if (SetInt(OBJPROP_YDISTANCE,cY=mY)) return true; else {cY=GetInt(OBJPROP_YDISTANCE); return false;}}
   bool              Move(long mX,long mY) {return (int)SetX(mX)+(int)SetY(mY)==2;}
   bool              SetBaseCorner(ENUM_BASE_CORNER mBaseCorner) {if (SetInt(OBJPROP_CORNER,cBaseCorner=mBaseCorner)) return true;
                                                                  else {cBaseCorner=(ENUM_BASE_CORNER)GetInt(OBJPROP_CORNER); return false;}}
  };
//------------------------------------------------------------------------
CPointObject::CPointObject(string mName,ENUM_OBJECT mType,long mChartId,int mSubWindow,long mX,long mY,int mFlag):
   CGraficObject(mName,mType,mChartId,mSubWindow,0,0,mFlag){
   Move(mX,mY);}
   
#endif