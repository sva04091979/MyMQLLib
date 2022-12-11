#ifndef _ND_BASE_OBJECT_
#define _ND_BASE_OBJECT_

class TBaseObject{
   string cName;
   long cChartId;
   long cZorder;
   int cSubWindow;
   ENUM_OBJECT cType;
   bool cIsDeletable;
   bool cIsHidden;
   bool cIsBack;
public:
   TBaseObject():cName(NULL){}
   TBaseObject(const TBaseObject& other) {this=other;}
   void operator =(const TBaseObject& other) {this=other;}
  ~TBaseObject();
   void Free() {Hide(); cName=NULL;}
   bool IsInit() const {return cName!=NULL;}
   bool IsHidden() const {return cIsHidden;}
   bool Zorder(long zorder);
   long Zorder() const {return cZorder;}
   bool Back() const {return cIsBack;}
   bool Back(bool isBack);
   ENUM_OBJECT Type() const {return cType;}
   string Name() const {return cName;}
   template<typename Type>
   bool Set(ENUM_OBJECT_PROPERTY_INTEGER prop,Type val) {return ObjectSetInteger(cChartId,cName,prop,val);}
   template<typename Type>
   bool Set(ENUM_OBJECT_PROPERTY_DOUBLE prop,Type val) {return ObjectSetDouble(cChartId,cName,prop,val);}
   template<typename Type>
   bool Set(ENUM_OBJECT_PROPERTY_STRING prop,Type val) {return ObjectSetString(cChartId,cName,prop,val);}
   long Get(ENUM_OBJECT_PROPERTY_INTEGER prop) {return ObjectGetInteger(cChartId,cName,prop);}
   double Get(ENUM_OBJECT_PROPERTY_DOUBLE prop) {return ObjectGetDouble(cChartId,cName,prop);}
   string Get(ENUM_OBJECT_PROPERTY_STRING prop) {return ObjectGetString(cChartId,cName,prop);}
   bool Hide();
   virtual bool Show();
protected:
   bool Create(long chartId,int subWindow,string name,ENUM_OBJECT type,bool isDeletable);
   bool Create(string name,ENUM_OBJECT type,bool isDeletable=true);
   virtual void Init();
};
//-----------------------------------------------------
TBaseObject::~TBaseObject(void){
   if (cName!=NULL&&cIsDeletable){
      ObjectDelete(0,cName);
   }
}
//----------------------------------------------------
bool TBaseObject::Create(long chartId,int subWindow,string name,ENUM_OBJECT type,bool isDeletable){
   cChartId=chartId;
   cSubWindow=subWindow;
   bool ret=ObjectCreate(cChartId,name,type,cSubWindow,0,0.0);
   if (ret){
      cName=name;
      cType=type;
      cIsDeletable=isDeletable;
      Init();
   }
   cIsHidden=!ret;
   return ret;
}
//----------------------------------------------------
bool TBaseObject::Create(string name,ENUM_OBJECT type,bool isDeletable){
   return Create(0,0,name,type,isDeletable);
}
//----------------------------------------------------
void TBaseObject::Init(){
   cZorder=Get(OBJPROP_ZORDER);
   cIsBack=Get(OBJPROP_BACK);
}
//----------------------------------------------------
bool TBaseObject::Zorder(long zorder){
   bool ret=Set(OBJPROP_ZORDER,zorder);
   if (ret)
      cZorder=zorder;
   return ret;
}
//----------------------------------------------------
bool TBaseObject::Back(bool isBack){
   bool ret=Set(OBJPROP_BACK,isBack);
   if (ret)
      cIsBack=isBack;
   return ret;
}
//----------------------------------------------------
bool TBaseObject::Hide(){
   bool ret=cName!=NULL;
   if (ret){
      cIsHidden=true;
      ObjectDelete(0,cName);
   }
   return ret;
}
//----------------------------------------------------
bool TBaseObject::Show(){
   bool ret=cName!=NULL&&ObjectCreate(0,cName,cType,0,0,0.0);
   if (ret){
      cIsHidden=false;
      Zorder(cZorder);
      Back(cIsBack);
   }
   return ret;
}

#endif