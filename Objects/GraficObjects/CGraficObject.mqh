#ifndef _C_GRAFIC_OBJECT_
#define _C_GRAFIC_OBJECT_

#include <MyMQLLib\Objects\CFlag.mqh>

#define OBJECT_FLAG_CREATE 0x1
#define OBJECT_FLAG_SELECTABLE 0x2
#define BUTTON_FLAG_PRESS  0x4

#define SET_STRING(dOBJPROP,dValue) ObjectSetString(cChartId,cName,dOBJPROP,dValue)
#define GET_STRING(dOBJPROP) ObjectGetString(cChartId,cName,dOBJPROP)

class CGraficObject
  {
protected:
   string            cName;
   ENUM_OBJECT       cType;
   long              cChartId;
   int               cSubWindow;
   color             cColor;
   CFlag             _Flag;
                     CGraficObject(string mName,
                                   ENUM_OBJECT mType,
                                   long mChartId,
                                   int mSubWindow,
                                   datetime mTime,
                                   double mPrice,
                                   int mFlag);
                    ~CGraficObject(void)  {if (_Flag.Check(OBJECT_FLAG_CREATE)) ObjectDelete(cChartId,cName);}
public:
   inline bool       SetInt(int mSet,long mVal) {return ObjectSetInteger(cChartId,cName,mSet,mVal);}
   bool              SetColor(color mColor) {if (SetInt(OBJPROP_COLOR,cColor=mColor)) return true; else {cColor=(color)GetInt(OBJPROP_COLOR); return false;}}
   inline bool       SetSelectable(bool isSelectable);
   inline long       GetInt(int mSet)     {return ObjectGetInteger(cChartId,cName,mSet);}
   bool              Equal(string mName)  {return mName==cName;}
  };
//----------------------------------------------------------------
void CGraficObject::CGraficObject(string mName,ENUM_OBJECT mType,long mChartId,int mSubWindow,datetime mTime,double mPrice,int mFlag):
   cName(mName),cType(mType),cChartId(mChartId),cSubWindow(mSubWindow),
   _Flag(mFlag){
   if (ObjectCreate(mChartId,mName,mType,mSubWindow,mTime,mPrice)) _Flag+=OBJECT_FLAG_CREATE;
   ObjectSetInteger(cChartId,cName,OBJPROP_SELECTABLE,false);
   cColor=(color)GetInt(OBJPROP_COLOR);}
//-----------------------------------------------------------------
bool CGraficObject::SetSelectable(bool isSelectable){
   bool res=SetInt(OBJPROP_COLOR,isSelectable);
   if (!res) isSelectable=(bool)GetInt(OBJPROP_COLOR);
   if (isSelectable) _Flag+=OBJECT_FLAG_SELECTABLE; else _Flag-=OBJECT_FLAG_SELECTABLE;
   return res;}

#endif 