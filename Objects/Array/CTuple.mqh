#ifndef _C_TUPLE_
#define _C_TUPLE_

#define tuple(dCount) CTuple##dCount
#define tuple_value(dCount) STuple##dCount

#define TEMP_LIST2 T1,T2
#define TEMP_LIST3 TEMP_LIST2,T3
#define TEMP_LIST4 TEMP_LIST3,T4
#define TEMP_LIST5 TEMP_LIST4,T5
#define TEMP_LIST6 TEMP_LIST5,T6
#define TEMP_LIST7 TEMP_LIST6,T7
#define TEMP_LIST8 TEMP_LIST7,T8

#define PARAM_DECL2 typename T1,typename T2
#define PARAM_DECL3 PARAM_DECL2,typename T3
#define PARAM_DECL4 PARAM_DECL3,typename T4
#define PARAM_DECL5 PARAM_DECL4,typename T5
#define PARAM_DECL6 PARAM_DECL5,typename T6
#define PARAM_DECL7 PARAM_DECL6,typename T7
#define PARAM_DECL8 PARAM_DECL7,typename T8

#define PARAM_LIST2 T1 mValue1, T2 mValue2
#define PARAM_LIST3 PARAM_LIST2, T3 mValue3
#define PARAM_LIST4 PARAM_LIST3, T4 mValue4
#define PARAM_LIST5 PARAM_LIST4, T5 mValue5
#define PARAM_LIST6 PARAM_LIST5, T6 mValue6
#define PARAM_LIST7 PARAM_LIST6, T7 mValue7
#define PARAM_LIST8 PARAM_LIST7, T8 mValue8

#define TEMPLATE_DECL(dCount) template<PARAM_DECL##dCount>

#define FIELD_DECL2(dC) T1 dC##tem1; T2 dC##tem2;
#define FIELD_DECL3(dC) FIELD_DECL2(dC) T3 dC##tem3;
#define FIELD_DECL4(dC) FIELD_DECL3(dC) T4 dC##tem4;
#define FIELD_DECL5(dC) FIELD_DECL4(dC) T5 dC##tem5;
#define FIELD_DECL6(dC) FIELD_DECL5(dC) T6 dC##tem6;
#define FIELD_DECL7(dC) FIELD_DECL6(dC) T7 dC##tem7;
#define FIELD_DECL8(dC) FIELD_DECL7(dC) T8 dC##tem8;

#define GET_FUNC(dCount) T##dCount Item##dCount() {return cItem##dCount;}

#define GET_DECL_LIST2 GET_FUNC(1) GET_FUNC(2)
#define GET_DECL_LIST3 GET_DECL_LIST2 GET_FUNC(3)
#define GET_DECL_LIST4 GET_DECL_LIST3 GET_FUNC(4)
#define GET_DECL_LIST5 GET_DECL_LIST4 GET_FUNC(5)
#define GET_DECL_LIST6 GET_DECL_LIST5 GET_FUNC(6)
#define GET_DECL_LIST7 GET_DECL_LIST6 GET_FUNC(7)
#define GET_DECL_LIST8 GET_DECL_LIST7 GET_FUNC(8)

#define GET_OUT(dCount) res.Item##dCount=cItem##dCount

#define GET_OUT2 GET_OUT(1);GET_OUT(2);
#define GET_OUT3 GET_OUT2 GET_OUT(3);
#define GET_OUT4 GET_OUT3 GET_OUT(4);
#define GET_OUT5 GET_OUT4 GET_OUT(5);
#define GET_OUT6 GET_OUT5 GET_OUT(6);
#define GET_OUT7 GET_OUT6 GET_OUT(7);
#define GET_OUT8 GET_OUT7 GET_OUT(8);

#define SET_FUNC(dCount) void Set##dCount(T##dCount mValue){cItem##dCount=mValue;}

#define SET_DECL_LIST2 SET_FUNC(1) SET_FUNC(2)
#define SET_DECL_LIST3 SET_DECL_LIST2 SET_FUNC(3)
#define SET_DECL_LIST4 SET_DECL_LIST3 SET_FUNC(4)
#define SET_DECL_LIST5 SET_DECL_LIST4 SET_FUNC(5)
#define SET_DECL_LIST6 SET_DECL_LIST5 SET_FUNC(6)
#define SET_DECL_LIST7 SET_DECL_LIST6 SET_FUNC(7)
#define SET_DECL_LIST8 SET_DECL_LIST7 SET_FUNC(8)

#define DEFAULT_INIT2 cItem1(NULL),cItem2(NULL)
#define DEFAULT_INIT3 DEFAULT_INIT2,cItem3(NULL)
#define DEFAULT_INIT4 DEFAULT_INIT3,cItem4(NULL)
#define DEFAULT_INIT5 DEFAULT_INIT4,cItem5(NULL)
#define DEFAULT_INIT6 DEFAULT_INIT5,cItem6(NULL)
#define DEFAULT_INIT7 DEFAULT_INIT6,cItem7(NULL)
#define DEFAULT_INIT8 DEFAULT_INIT7,cItem8(NULL)

#define INIT2 cItem1(mValue1),cItem2(mValue2)
#define INIT3 INIT2,cItem3(mValue3)
#define INIT4 INIT3,cItem4(mValue4)
#define INIT5 INIT4,cItem5(mValue5)
#define INIT6 INIT5,cItem6(mValue6)
#define INIT7 INIT6,cItem7(mValue7)
#define INIT8 INIT7,cItem8(mValue8)

#define PRI(dI) mTuple.Item##dI
#define PRcI(dI) mTuple.Item##dI()

#define COPY_TUPLE2(dPref,dI) dPref##tem1=PR##dI(1);dPref##tem2=PR##dI(2);
#define COPY_TUPLE3(dPref,dI) COPY_TUPLE2(dPref,dI) dPref##tem3=PR##dI(3);
#define COPY_TUPLE4(dPref,dI) COPY_TUPLE3(dPref,dI) dPref##tem4=PR##dI(4);
#define COPY_TUPLE5(dPref,dI) COPY_TUPLE4(dPref,dI) dPref##tem5=PR##dI(5);
#define COPY_TUPLE6(dPref,dI) COPY_TUPLE5(dPref,dI) dPref##tem6=PR##dI(6);
#define COPY_TUPLE7(dPref,dI) COPY_TUPLE6(dPref,dI) dPref##tem7=PR##dI(7);
#define COPY_TUPLE8(dPref,dI) COPY_TUPLE7(dPref,dI) dPref##tem8=PR##dI(8);

#define TUPLE_DECL(dCount) \
   TEMPLATE_DECL(dCount)   \
   struct STuple##dCount{   \
      FIELD_DECL##dCount(I)   \
      void operator =(tuple(##dCount)<TEMP_LIST##dCount> &mTuple){COPY_TUPLE##dCount(I,cI)}   \
   }; \
   TEMPLATE_DECL(dCount)   \
   class CTuple##dCount{   \
      FIELD_DECL##dCount(cI)   \
   public:  \
      CTuple##dCount():DEFAULT_INIT##dCount{}   \
      CTuple##dCount(PARAM_LIST##dCount):INIT##dCount{}  \
      GET_DECL_LIST##dCount  \
      SET_DECL_LIST##dCount  \
      tuple_value(dCount)<TEMP_LIST##dCount> GetTuple(){ \
         tuple_value(dCount)<TEMP_LIST##dCount> res;  \
         GET_OUT##dCount   \
         return res;}   \
      void operator=(STuple##dCount<TEMP_LIST##dCount> &mTuple){COPY_TUPLE##dCount(cI,I)}   \
      void operator=(CTuple##dCount<TEMP_LIST##dCount> &mTuple){COPY_TUPLE##dCount(cI,cI)}   \
   }; 
   
TUPLE_DECL(2)
TUPLE_DECL(3)
TUPLE_DECL(4)
TUPLE_DECL(5)
TUPLE_DECL(6)
TUPLE_DECL(7)
TUPLE_DECL(8)

#undef TEMP_LIST2
#undef TEMP_LIST3
#undef TEMP_LIST4
#undef TEMP_LIST5
#undef TEMP_LIST6
#undef TEMP_LIST7
#undef TEMP_LIST8

#undef PARAM_DECL2
#undef PARAM_DECL3
#undef PARAM_DECL4
#undef PARAM_DECL5
#undef PARAM_DECL6
#undef PARAM_DECL7
#undef PARAM_DECL8

#undef PARAM_LIST2
#undef PARAM_LIST3
#undef PARAM_LIST4
#undef PARAM_LIST5
#undef PARAM_LIST6
#undef PARAM_LIST7
#undef PARAM_LIST8

#undef TEMPLATE_DECL

#undef FIELD_DECL2
#undef FIELD_DECL3
#undef FIELD_DECL4
#undef FIELD_DECL5
#undef FIELD_DECL6
#undef FIELD_DECL7
#undef FIELD_DECL8

#undef GET_FUNC

#undef GET_DECL_LIST2
#undef GET_DECL_LIST3
#undef GET_DECL_LIST4
#undef GET_DECL_LIST5
#undef GET_DECL_LIST6
#undef GET_DECL_LIST7
#undef GET_DECL_LIST8

#undef GET_OUT

#undef GET_OUT2
#undef GET_OUT3
#undef GET_OUT4
#undef GET_OUT5
#undef GET_OUT6
#undef GET_OUT7
#undef GET_OUT8

#undef SET_FUNC

#undef SET_DECL_LIST2
#undef SET_DECL_LIST3
#undef SET_DECL_LIST4
#undef SET_DECL_LIST5
#undef SET_DECL_LIST6
#undef SET_DECL_LIST7
#undef SET_DECL_LIST8

#undef DEFAULT_INIT2
#undef DEFAULT_INIT3
#undef DEFAULT_INIT4
#undef DEFAULT_INIT5
#undef DEFAULT_INIT6
#undef DEFAULT_INIT7
#undef DEFAULT_INIT8

#undef INIT2
#undef INIT3
#undef INIT4
#undef INIT5
#undef INIT6
#undef INIT7
#undef INIT8

#undef PRI
#undef PRcI

#undef COPY_TUPLE2
#undef COPY_TUPLE3
#undef COPY_TUPLE4
#undef COPY_TUPLE5
#undef COPY_TUPLE6
#undef COPY_TUPLE7
#undef COPY_TUPLE8

#undef TUPLE_DECL

#endif