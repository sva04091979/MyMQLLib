#ifndef _C_CLICK_CONTROL_
#define _C_CLICK_CONTROL_

class CClickControl{
   class _CClickControl{
      _CClickControl* cPrev;
      _CClickControl* cNext;
      CClickControl* main;
      long x;
      double y;
   public:
      _CClickControl(const long &_x,const double &_y,_CClickControl* _prev,CClickControl* _main):cNext(NULL),cPrev(_prev),main(_main),x(_x),y(_y){}
     ~_CClickControl() {delete cNext;}
      void Push(const long &_x,const double &_y) {if (!cNext) cNext=new _CClickControl(_x,_y,&this,main); else cNext.Push(_x,_y);}
      bool Check(const long &_x,const double &_y){
         if(_x!=x||_y!=y) return !cNext||cNext.Check(_x,_y);
         if (cPrev!=NULL) cPrev.Next(cNext);
         else main.Next(cNext);
         if (cNext!=NULL){
            cNext.Prev(cPrev);
            cNext=NULL;}
         delete &this;
         return false;}
      void Prev(_CClickControl* _prev) {cPrev=_prev;}
      void Next(_CClickControl* _next) {cNext=_next;}
   };
   _CClickControl* cNext;
   CClickControl():cNext(NULL){}
public:
  ~CClickControl() {delete cNext;}
   static CClickControl* Ptr(){
      static CClickControl obj;
      return &obj;}
   void Push(const long &_x,const double &_y) {if (!cNext) cNext=new _CClickControl(_x,_y,NULL,&this); else cNext.Push(_x,_y);}
   bool Check(const long &_x,const double &_y) {return !cNext||cNext.Check(_x,_y);}
   void Next(_CClickControl* _next) {cNext=_next;}
};

#define PUSH_CLICK(x,y) CClickControl::Ptr().Push(x,y)
#define CHECK_CLICK(x,y) CClickControl::Ptr().Check(x,y)

#endif