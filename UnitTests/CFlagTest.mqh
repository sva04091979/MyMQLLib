#ifndef USING_STD
   #define USING_STD
#endif

#include <STD\CFlag.mqh>

class CFlag:public _tFlag{
public:
   _declFlag a;
   _declFlag b;
   _declFlag c;
   _declFlag d;
};

_tFlagType CFlag::a=0x1,
           CFlag::b=0x2,
           CFlag::c=0x4,
           CFlag::d=0x8;

void TestCFlag(){
   CFlag flag;
   CFlag _flag;
   flag+=CFlag::b;
   flag>>_flag;
   PrintFormat("%i, %i",_(flag),_(_flag));
}