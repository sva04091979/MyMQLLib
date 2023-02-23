enum EInitState{
   IS_Nothing,
   IS_Start,
   IS_ChangeChart,
   IS_ChangeParam
};

class IInit{
public:
   virtual ENUM_INIT_RETCODE Start() {return INIT_SUCCEEDED;}
   virtual ENUM_INIT_RETCODE ChangeSymbol() {return INIT_SUCCEEDED;}
   virtual ENUM_INIT_RETCODE ChangeFrame() {return INIT_SUCCEEDED;}
   virtual ENUM_INIT_RETCODE ChangeParam() {return INIT_SUCCEEDED;}
   virtual void Stop() {}
};

template<typename InitType>
class TOnInit{
   string m_symbol;
   ENUM_TIMEFRAMES m_timeFrame;
   EInitState m_state;
   IInit* m_init;
   TOnInit();
   static TOnInit* Inst();
public:
   ~TOnInit() {delete m_init;}
   static ENUM_INIT_RETCODE Init() {return Inst()._Init();}
   static void Deinit(const int reason) {Inst()._Deinit(reason);}
private:
   ENUM_INIT_RETCODE _Init();
   void _Deinit(const int reason);
};
//-------------------------------------
template<typename InitType>
TOnInit::TOnInit(void):m_symbol(_Symbol),m_timeFrame(_Period),m_state(IS_Start),m_init(new InitType()){}
//-------------------------------------
template<typename InitType>
TOnInit* TOnInit::Inst(){
   static TOnInit inst;
   return &inst;
}
//------------------------------------------
template<typename InitType>
ENUM_INIT_RETCODE TOnInit::_Init(){
   ENUM_INIT_RETCODE ret=INIT_SUCCEEDED;
   switch (m_state){
      case IS_Start:
         ret=m_init.Start();
         break;
      case IS_ChangeChart:
         if (m_symbol!=_Symbol)
            ret=m_init.ChangeSymbol();
         if (m_timeFrame!=_Period)
            ret=ret!=INIT_SUCCEEDED?ret:m_init.ChangeFrame();
         m_symbol=_Symbol;
         m_timeFrame=_Period;
         break;
      case IS_ChangeParam:
         m_init.ChangeParam();
         break;
   }
   m_state=IS_Nothing;
   return ret;
}
//---------------------------------------------
template<typename InitType>
void TOnInit::_Deinit(const int reason){
   switch(reason){
      case REASON_PARAMETERS:    m_state=IS_ChangeParam; break;
      case REASON_PROGRAM:
      case REASON_REMOVE:
      case REASON_INITFAILED:
      case REASON_CLOSE:
      case REASON_CHARTCLOSE:    m_init.Stop();
                                 break;
      case REASON_TEMPLATE:
      case REASON_RECOMPILE:
      case REASON_ACCOUNT:       m_init.Stop();
                                 m_state=IS_Start;
                                 break;
      case REASON_CHARTCHANGE:   m_state=IS_ChangeChart; break;
   }
}
