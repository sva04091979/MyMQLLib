#include "BaseObject.mqh"
#include "Color.mqh"
#include "Price.mqh"
#include "Width.mqh"
#include "Style.mqh"

#define __tBase TColor<TPrice<TWidth<TStyle<TBaseObject>>>>

class TLine:public __tBase{
public:
   bool Create(long chartId,int subWindow,string name,bool isDeletable=true);
   bool Create(string name,bool isDeletable=true);
   bool Show(int subW=0) override;
protected:
   void Init() override;
};
//----------------------------------------------------------
bool TLine::Create(string name,bool isDeletable=true){
   bool ret=Create(0,0,name,OBJ_HLINE,isDeletable);
   return ret;
}
//----------------------------------------------------------
bool TLine::Create(long chartId,int subWindow,string name,bool isDeletable=true){
   return TBaseObject::Create(chartId,subWindow,name,OBJ_HLINE,isDeletable);
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
