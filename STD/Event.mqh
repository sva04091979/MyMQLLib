#ifndef _STD_EVENT_
#define _STD_EVENT_

template<typename __Func>
class STD_EventStruct{
public:
   STD_EventStruct* cNext;
   STD_EventStruct* cPrev;
   void* it;
   __Func func;
   STD_EventStruct():cNext(NULL){}
   STD_EventStruct(void* _it,__Func _func):cNext(NULL),cPrev(NULL),it(_it),func(_func){}
   void Next(STD_EventStruct* _it) {cNext=_it;}
   void Prev(STD_EventStruct* _it) {cPrev=_it;}
   STD_EventStruct* Next() const {return cNext;}
   STD_EventStruct* Prev() const {return cPrev;}
};

template<typename __Func>
class STD_EventBase{
protected:
   STD_EventStruct<__Func>* cFront;
   STD_EventStruct<__Func>* cBack;
public:
   STD_EventBase():cFront(NULL),cBack(NULL){}
  ~STD_EventBase(){
      STD_EventStruct<__Func>* it=cFront;
      while (it!=NULL){
         void* forDelete=it;
         it=it.Next();
         delete forDelete;
      }
  }
   void Add(void* it,__Func func){
      if (it!=NULL&&!Find(it)){
         PushBack(new STD_EventStruct<__Func>(it,func));
      }
   }
protected:  
   STD_EventStruct<__Func>* Next(STD_EventStruct<__Func>* it){
      it=!it?cFront:it.Next();
      if(!it)
         return NULL;
      STD_EventStruct<__Func>* prev=it.Prev();
      while(it!=NULL&&CheckPointer(it.it)==POINTER_INVALID){
         STD_EventStruct<__Func>* next=it.Next();
         if (!prev) cFront=next;
         else prev.Next(next);
         if(!next) cBack=prev;
         else next.Prev(prev);
         delete it;
         it=next;
      }
      return it;
   }
private:
   void PushBack(STD_EventStruct<__Func>* it){
      if (!cFront){
         cFront=cBack=it;
      }
      else{
         cBack.Next(it);
         it.Prev(cBack);
         cBack=it;
      }
   }
   bool Find(void* ptr){
      STD_EventStruct<__Func>* it=cFront;
      while (it!=NULL){
         if (ptr==it.it)
            return true;
         it=it.Next();
      }
      return false;
   }
};


#define _tEvent0(name) \
typedef void(*__##name##_func)(void*);\
class Event##name:public STD_EventBase<__##name##_func>{\
public:\
   void Invoke(){\
      STD_EventStruct<__##name##_func>* it=NULL;\
      while((it=Next(it))!=NULL)\
         it.func(it.it);\
   }\
} name;

#define _tEvent1(name,t1) \
typedef void(*__##name##_func)(void*,t1);\
class Event##name:public STD_EventBase<__##name##_func>{\
public:\
   void Invoke(t1 p1){\
      STD_EventStruct<__##name##_func>* it=NULL;\
      while((it=Next(it))!=NULL)\
         it.func(it.it,p1);\
   }\
} name;

#define _tEvent2(name,t1,t2) \
typedef void(*__##name##_func)(void*,t1,t2);\
class Event##name:public STD_EventBase<__##name##_func>{\
public:\
   void Invoke(t1 p1,t2 p2){\
      STD_EventStruct<__##name##_func>* it=NULL;\
      while((it=Next(it))!=NULL)\
         it.func(it.it,p1,p2);\
   }\
} name;

#define _tEvent3(name,t1,t2,t3) \
typedef void(*__##name##_func)(void*,t1,t2,t3);\
class Event##name:public STD_EventBase<__##name##_func>{\
public:\
   void Invoke(t1 p1,t2 p2,t3 p3){\
      STD_EventStruct<__##name##_func>* it=NULL;\
      while((it=Next(it))!=NULL)\
         it.func(it.it,p1,p2,p3);\
   }\
} name;


#endif