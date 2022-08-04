#ifndef _C_GRAFIC_OBJECT_
#define _C_GRAFIC_OBJECT_

#include "..\..\Objects\CFlag.mqh"

#define OBJECT_FLAG_CREATE 0x1
#define OBJECT_FLAG_SELECTABLE 0x2
#define BUTTON_FLAG_PRESS  0x4
#define OBJECT_FLAG_NOT_DELETABLE 0x8

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
                    ~CGraficObject(void)  {if (_Flag.Check(OBJECT_FLAG_CREATE)&&!_Flag.Check(OBJECT_FLAG_NOT_DELETABLE)) ObjectDelete(cChartId,cName);}
public:
   inline bool       SetInt(ENUM_OBJECT_PROPERTY_INTEGER mSet,long mVal) {return ObjectSetInteger(cChartId,cName,mSet,mVal);}
   bool              SetColor(color mColor) {if (SetInt(OBJPROP_COLOR,cColor=mColor)) return true; else {cColor=(color)GetInt(OBJPROP_COLOR); return false;}}
   inline bool       SetSelectable(bool isSelectable);
   inline long       GetInt(ENUM_OBJECT_PROPERTY_INTEGER mSet)     {return ObjectGetInteger(cChartId,cName,mSet);}
   inline string     GetString(ENUM_OBJECT_PROPERTY_STRING mSet)   {return ObjectGetString(cChartId,cName,mSet);}
   string Name() const {return cName;}
   bool              Equal(string mName)  {return mName==cName;}
   void              Deletable(bool key) {if (key) _Flag-=OBJECT_FLAG_NOT_DELETABLE; else _Flag+=OBJECT_FLAG_NOT_DELETABLE;}
   virtual bool      ChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam) {return sparam==cName;}
  };
//----------------------------------------------------------------
void CGraficObject::CGraficObject(string mName,ENUM_OBJECT mType,long mChartId,int mSubWindow,datetime mTime,double mPrice,int mFlag):
   cName(mName),cType(mType),cChartId(mChartId),cSubWindow(mSubWindow),
   _Flag(mFlag){
   if (ObjectCreate(mChartId,mName,mType,mSubWindow,mTime,mPrice)) _Flag+=OBJECT_FLAG_CREATE;
   ObjectSetInteger(cChartId,cName,OBJPROP_SELECTABLE,_Flag.Check(OBJECT_FLAG_SELECTABLE));
   cColor=(color)GetInt(OBJPROP_COLOR);}
//-----------------------------------------------------------------
bool CGraficObject::SetSelectable(bool isSelectable){
   bool res=SetInt(OBJPROP_SELECTABLE,isSelectable);
   if (!res) isSelectable=(bool)GetInt(OBJPROP_SELECTABLE);
   if (isSelectable) _Flag+=OBJECT_FLAG_SELECTABLE; else _Flag-=OBJECT_FLAG_SELECTABLE;
   return res;}

#endif 