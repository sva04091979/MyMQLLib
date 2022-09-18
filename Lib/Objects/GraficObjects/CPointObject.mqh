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
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
class CField:public CPointObject{
protected:
   string            cText;
   long              cXSize;
   long              cYSize;
public:
                     CField(string mName,
                            ENUM_OBJECT mType,
                            long mChartId,
                            int mSubWindow,
                            long mX,
                            long mY,
                            long mXSize,
                            long mYSize,
                            int mFlag);
   bool              SetText(string mText) {if (SET_STRING(OBJPROP_TEXT,cText=mText)) return true; else {cText=GET_STRING(OBJPROP_TEXT); return false;}}
   bool              SetXSize(long mXSize) {if (SetInt(OBJPROP_XSIZE,cXSize=mXSize)) return true; else {cXSize=GetInt(OBJPROP_XSIZE); return false;}}
   bool              SetYSize(long mYSize) {if (SetInt(OBJPROP_YSIZE,cYSize=mYSize)) return true; else {cYSize=GetInt(OBJPROP_YSIZE); return false;}}
   bool              SetXYSize(long mXSize,long mYSize)  {return (int)SetXSize(mXSize)+(int)SetYSize(mYSize)==2;}
};
//-----------------------------------------------------------------------
CField::CField(string mName,ENUM_OBJECT mType,long mChartId,int mSubWindow,long mX,long mY,long mXSize,long mYSize,int mFlag):
   CPointObject(mName,mType,mChartId,mSubWindow,mX,mY,mFlag),
   cText(mName),
   cXSize(mXSize),
   cYSize(mYSize){
   SetText(cText);
   SetXYSize(mXSize,mYSize);   
   }
#endif