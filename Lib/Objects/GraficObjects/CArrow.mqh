#ifndef _MY_MQL_LIB_C_ARROW_
#define _MY_MQL_LIB_C_ARROW_

#include "CGraficObject.mqh"

class CArrow:public CGraficObject{
public:
   CArrow(string name,datetime time,double price,int arrowCode,color arrowColor);
};
//--------------------------------------------------------------
CArrow::CArrow(string name,datetime time,double price,int arrowCode,color arrowColor):
   CGraficObject(name,OBJ_ARROW,0,0,time,price,0){
   ObjectSetInteger(cChartId,cName,OBJPROP_ARROWCODE,arrowCode);
   SetColor(arrowColor);
}


#endif