#ifndef USING_STD
   #define USING_STD
#endif

#include <STD\Define\StdDefine.mqh>

void TestSwap(){
   int d=1;
   int i=6;
   _fSwap(d,i);
   Print(__sf("%i, %i",d,i));
}