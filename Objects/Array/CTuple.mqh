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

#define FIELD_DECL2 T1 Item1; T2 Item2;
#define FIELD_DECL3 FIELD_DECL2 T3 Item3;
#define FIELD_DECL4 FIELD_DECL3 T4 Item4;
#define FIELD_DECL5 FIELD_DECL4 T5 Item5;
#define FIELD_DECL6 FIELD_DECL5 T6 Item6;
#define FIELD_DECL7 FIELD_DECL6 T7 Item7;
#define FIELD_DECL8 FIELD_DECL7 T8 Item8;

#define GET_FUNC(dCount) T##dCount Get_##dCount() {return Item##dCount;}

#define GET_DECL_LIST2 GET_FUNC(1) GET_FUNC(2)
#define GET_DECL_LIST3 GET_DECL_LIST2 GET_FUNC(3)
#define GET_DECL_LIST4 GET_DECL_LIST3 GET_FUNC(4)
#define GET_DECL_LIST5 GET_DECL_LIST4 GET_FUNC(5)
#define GET_DECL_LIST6 GET_DECL_LIST5 GET_FUNC(6)
#define GET_DECL_LIST7 GET_DECL_LIST6 GET_FUNC(7)
#define GET_DECL_LIST8 GET_DECL_LIST7 GET_FUNC(8)

#define SET_FUNC(dCount) void Set_##dCount(T##dCount mValue){Item##dCount=mValue;}

#define SET_DECL_LIST2 SET_FUNC(1) SET_FUNC(2)
#define SET_DECL_LIST3 SET_DECL_LIST2 SET_FUNC(3)
#define SET_DECL_LIST4 SET_DECL_LIST3 SET_FUNC(4)
#define SET_DECL_LIST5 SET_DECL_LIST4 SET_FUNC(5)
#define SET_DECL_LIST6 SET_DECL_LIST5 SET_FUNC(6)
#define SET_DECL_LIST7 SET_DECL_LIST6 SET_FUNC(7)
#define SET_DECL_LIST8 SET_DECL_LIST7 SET_FUNC(8)

#define DEFAULT_INIT2 Item1(NULL),Item2(NULL)
#define DEFAULT_INIT3 DEFAULT_INIT2,Item3(NULL)
#define DEFAULT_INIT4 DEFAULT_INIT3,Item4(NULL)
#define DEFAULT_INIT5 DEFAULT_INIT4,Item5(NULL)
#define DEFAULT_INIT6 DEFAULT_INIT5,Item6(NULL)
#define DEFAULT_INIT7 DEFAULT_INIT6,Item7(NULL)
#define DEFAULT_INIT8 DEFAULT_INIT7,Item8(NULL)

#define INIT2 Item1(mValue1),Item2(mValue2)
#define INIT3 INIT2,Item3(mValue3)
#define INIT4 INIT3,Item4(mValue4)
#define INIT5 INIT4,Item5(mValue5)
#define INIT6 INIT5,Item6(mValue6)
#define INIT7 INIT6,Item7(mValue7)
#define INIT8 INIT7,Item8(mValue8)

#define PRS(dI) mTuple.Item##dI
#define PRC(dI) mTuple.Get_##dI()

#define COPY_TUPLE2(dI) Item1=PR##dI(1);Item2=PR##dI(2);
#define COPY_TUPLE3(dI) COPY_TUPLE2(dI) Item3=PR##dI(3);
#define COPY_TUPLE4(dI) COPY_TUPLE3(dI) Item4=PR##dI(4);
#define COPY_TUPLE5(dI) COPY_TUPLE4(dI) Item5=PR##dI(5);
#define COPY_TUPLE6(dI) COPY_TUPLE5(dI) Item6=PR##dI(6);
#define COPY_TUPLE7(dI) COPY_TUPLE6(dI) Item7=PR##dI(7);
#define COPY_TUPLE8(dI) COPY_TUPLE7(dI) Item8=PR##dI(8);

#define TUPLE_DECL(dCount) \
   TEMPLATE_DECL(dCount)   \
   struct STuple##dCount{   \
      FIELD_DECL##dCount   \
   }; \
   TEMPLATE_DECL(dCount)   \
   class CTuple##dCount{   \
      FIELD_DECL##dCount   \
   public:  \
      CTuple##dCount():DEFAULT_INIT##dCount{}   \
      CTuple##dCount(PARAM_LIST##dCount):INIT##dCount{}  \
      GET_DECL_LIST##dCount  \
      SET_DECL_LIST##dCount  \
      tuple_value<TEMP_LIST##dCount> GetTuple() {return tuple_value<TEMP_LIST##dCount>={GET_LIST##dCount};}
      void operator=(STuple##dCount<TEMP_LIST##dCount> &mTuple){COPY_TUPLE##dCount(S)}   \
      void operator=(CTuple##dCount<TEMP_LIST##dCount> &mTuple){COPY_TUPLE##dCount(C)}   \
   }; \
   TEMPLATE_DECL(dCount)   \
   tuple_value(##dCount)<TEMP_LIST##dCount> operator =(tuple(##dCount)<TEMP_LIST##dCount> &mTuple){ \
      return mTuple.GetTuple();}
   
TUPLE_DECL(2)
TUPLE_DECL(3)
TUPLE_DECL(4)
TUPLE_DECL(5)
TUPLE_DECL(6)
TUPLE_DECL(7)
TUPLE_DECL(8)

#endif