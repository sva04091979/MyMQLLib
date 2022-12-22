#include "BaseObject.mqh"
#include "Color.mqh"
#include "Price.mqh"
#include "Width.mqh"

#define __tBase TColor<TPrice<TWidth<TBaseObject>>>

class TLine:public __tBase{
public:
   bool Create(long chartId,int subWindow,string name);
   bool Create(string name);
   bool Show(int subW=0) override;
protected:
   void Init() override;
};
//----------------------------------------------------------
bool TLine::Create(string name){
   bool ret=Create(0,0,name,OBJ_HLINE,true);
   return ret;
}
//----------------------------------------------------------
bool TLine::Create(long chartId,int subWindow,string name){
   return TBaseObject::Create(chartId,subWindow,name,OBJ_HLINE,true);
}
//----------------------------------------------------------
void TLine::Init(){
   __tBase::Init();
}
//------------------------------------------------------
bool TLine::Show(int subW){
   bool ret=__tBase::Show(subW);
   return ret;
}

#undef __tBase
