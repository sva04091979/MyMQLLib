#ifndef _C_GRAFIC_OBJECT_
#define _C_GRAFIC_OBJECT_

#define OBJECT_FLAG_CREATE 0x1
#define BUTTON_FLAG_PRESS  0x2

#define SET_INTEGER(dOBJPROP,dValue) ObjectSetInteger(cChartId,cName,dOBJPROP,dValue)
#define SET_STRING(dOBJPROP,dValue) ObjectSetString(cChartId,cName,dOBJPROP,dValue)
#define GET_INTEGER(dOBJPROP) ObjectGetInteger(cChartId,cName,dOBJPROP)
#define GET_STRING(dOBJPROP) ObjectGetString(cChartId,cName,dOBJPROP)

class CGraficObject
  {
protected:
   string            cName;
   ENUM_OBJECT       cType;
   long              cChartId;
   int               cSubWindow;
   color             cColor;
   int               cFlag;
                     CGraficObject(string mName,
                                   ENUM_OBJECT mType,
                                   long mChartId,
                                   int mSubWindow,
                                   datetime mTime,
                                   double mPrice,
                                   int mFlag);
                    ~CGraficObject(void)  {if (bool(cFlag&OBJECT_FLAG_CREATE)) ObjectDelete(cChartId,cName);}
public:
   bool              SetColor(color mColor) {if (SET_INTEGER(OBJPROP_COLOR,cColor=mColor)) return true; else {cColor=(color)GET_INTEGER(OBJPROP_COLOR); return false;}}
   bool              Equal(string mName) {return mName==cName;}
  };
//----------------------------------------------------------------
void CGraficObject::CGraficObject(string mName,ENUM_OBJECT mType,long mChartId,int mSubWindow,datetime mTime,double mPrice,int mFlag):
   cName(mName),cType(mType),cChartId(mChartId),cSubWindow(mSubWindow),
   cFlag(mFlag){
   if (ObjectCreate(mChartId,mName,mType,mSubWindow,mTime,mPrice)) cFlag|=OBJECT_FLAG_CREATE;
   ObjectSetInteger(cChartId,cName,OBJPROP_SELECTABLE,true);
   cColor=(color)GET_INTEGER(OBJPROP_COLOR);}


#endif 