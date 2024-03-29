#ifndef _C_H_LINE_
#define _C_H_LINE_

#include "CLine.mqh"

class CHLine:public CLine
  {
protected:
   double            cPrice;
public:
                     CHLine(string mName,double mPrice,color mClr,int mWidth,ENUM_LINE_STYLE mStyle=STYLE_SOLID,long mChartId=0,int mSubWindow=0);
   double            GetPrice()  {return cPrice;}
   bool              SetPrice(double mPrice) {return ObjectSetDouble(cChartId,cName,OBJPROP_PRICE,0,cPrice=mPrice);}
  };
//--------------------------------------------------------
void CHLine::CHLine(string mName,double mPrice,color mClr,int mWidth=1,ENUM_LINE_STYLE mStyle=STYLE_SOLID,long mChartId=0,int mSubWindow=0):
   CLine(mName,OBJ_HLINE,mWidth,mStyle,mChartId,mSubWindow,0,mPrice),
   cPrice(mPrice){
   SetColor(mClr);
   }
//---------------------------------------------------------


#endif