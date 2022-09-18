#include "../Define/StdDefine.mqh"

#ifndef _STD_MATH_
#define _STD_MATH_

_tECompare Compare(double l,double r,int digits){
   double x=NormalizeDouble(l-r,digits);
   return x==0.0?_eEqual:x>0.0?_eMore:_eLess;
}

_tECompare Compare(double l,double r,_tEDirect direct,int digits){
   if  (direct==_eNoDirect)
      return _eEqual;
   _tECompare ret=Compare(l,r,digits);
   return direct==_eUp?ret:(_tECompare)-ret;
}

#endif 