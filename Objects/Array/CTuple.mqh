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

#define FIELD_LIST2 Item1, Item2
#define FIELD_LIST3 FIELD_LIST2, Item3
#define FIELD_LIST4 FIELD_LIST3, Item4
#define FIELD_LIST5 FIELD_LIST4, Item5
#define FIELD_LIST6 FIELD_LIST5, Item6
#define FIELD_LIST7 FIELD_LIST6, Item7
#define FIELD_LIST8 FIELD_LIST7, Item8

#define GET_OUT(dCount) res.Item##dCount=Item##dCount

#define GET_OUT2 GET_OUT(1);GET_OUT(2);
#define GET_OUT3 GET_OUT2 GET_OUT(3);
#define GET_OUT4 GET_OUT3 GET_OUT(4);
#define GET_OUT5 GET_OUT4 GET_OUT(5);
#define GET_OUT6 GET_OUT5 GET_OUT(6);
#define GET_OUT7 GET_OUT6 GET_OUT(7);
#define GET_OUT8 GET_OUT7 GET_OUT(8);

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

#define COPY_TUPLE2 Item1=mTuple.Item1; Item2=mTuple.Item2;
#define COPY_TUPLE3 COPY_TUPLE2 Item3=mTuple.Item3;
#define COPY_TUPLE4 COPY_TUPLE3 Item4=mTuple.Item4;
#define COPY_TUPLE5 COPY_TUPLE4 Item5=mTuple.Item5;
#define COPY_TUPLE6 COPY_TUPLE5 Item6=mTuple.Item6;
#define COPY_TUPLE7 COPY_TUPLE6 Item7=mTuple.Item7;
#define COPY_TUPLE8 COPY_TUPLE7 Item8=mTuple.Item8;

#define COMPARE2 return Item1==mTuple.Item1&&Item2==mTuple.Item2
#define COMPARE3 COMPARE2&&Item3==mTuple.Item3
#define COMPARE4 COMPARE3&&Item4==mTuple.Item4
#define COMPARE5 COMPARE4&&Item5==mTuple.Item5
#define COMPARE6 COMPARE5&&Item6==mTuple.Item6
#define COMPARE7 COMPARE6&&Item7==mTuple.Item7
#define COMPARE8 COMPARE7&&Item8==mTuple.Item8

#define TUPLE_DECL(dCount) \
   TEMPLATE_DECL(dCount)   \
   struct STuple##dCount{   \
      FIELD_DECL##dCount   \
      void operator =(tuple(##dCount)<TEMP_LIST##dCount> &mTuple){COPY_TUPLE##dCount}   \
      void operator =(tuple_value(##dCount)<TEMP_LIST##dCount> &mTuple){COPY_TUPLE##dCount}   \
      tuple(dCount)<TEMP_LIST##dCount>* GetTuple() {return new tuple(dCount)<TEMP_LIST##dCount>(FIELD_LIST##dCount);}   \
      tuple_value(dCount)<TEMP_LIST##dCount> GetTupleValue(){ \
         tuple_value(dCount)<TEMP_LIST##dCount> res;  \
         GET_OUT##dCount   \
         return res;}   \
      bool operator ==(tuple(##dCount)<TEMP_LIST##dCount> &mTuple){COMPARE##dCount;} \
      bool operator ==(tuple_value(##dCount)<TEMP_LIST##dCount> &mTuple){COMPARE##dCount;} \
   }; \
   TEMPLATE_DECL(dCount)   \
   class CTuple##dCount{   \
   public:  \
      FIELD_DECL##dCount   \
      CTuple##dCount():DEFAULT_INIT##dCount{}   \
      CTuple##dCount(PARAM_LIST##dCount):INIT##dCount{}  \
      tuple(dCount)<TEMP_LIST##dCount>* GetTuple() {return new tuple(dCount)<TEMP_LIST##dCount>(FIELD_LIST##dCount);}   \
      tuple_value(dCount)<TEMP_LIST##dCount> GetTupleValue(){ \
         tuple_value(dCount)<TEMP_LIST##dCount> res;  \
         GET_OUT##dCount   \
         return res;}   \
      void operator=(STuple##dCount<TEMP_LIST##dCount> &mTuple){COPY_TUPLE##dCount}   \
      void operator=(CTuple##dCount<TEMP_LIST##dCount> &mTuple){COPY_TUPLE##dCount}   \
      bool operator ==(tuple(##dCount)<TEMP_LIST##dCount> &mTuple){COMPARE##dCount;} \
      bool operator ==(tuple_value(##dCount)<TEMP_LIST##dCount> &mTuple){COMPARE##dCount;} \
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

#undef FIELD_LIST2
#undef FIELD_LIST3
#undef FIELD_LIST4
#undef FIELD_LIST5
#undef FIELD_LIST6
#undef FIELD_LIST7
#undef FIELD_LIST8

#undef GET_OUT

#undef GET_OUT2
#undef GET_OUT3
#undef GET_OUT4
#undef GET_OUT5
#undef GET_OUT6
#undef GET_OUT7
#undef GET_OUT8

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

#undef COPY_TUPLE2
#undef COPY_TUPLE3
#undef COPY_TUPLE4
#undef COPY_TUPLE5
#undef COPY_TUPLE6
#undef COPY_TUPLE7
#undef COPY_TUPLE8

#undef COMPARE2
#undef COMPARE3
#undef COMPARE4
#undef COMPARE5
#undef COMPARE6
#undef COMPARE7
#undef COMPARE8

#undef TUPLE_DECL

#endif