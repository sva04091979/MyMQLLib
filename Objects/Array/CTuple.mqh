#ifndef _C_TUPLE_
#define _C_TUPLE_

#define tuple(dCount) classTuple##dCount
#define tuple_value(dCount) structTuple##dCount
#define tuple_pack(dCount,dPack) class##dPack##Tuple##dCount
#define tuple_value_pack(dCount,dPack) struct##dPack##Tuple##dCount
#define GetTuple_pack(dPack) GetTuple##dPack()
#define GetTupleValue_pack(dPack) GetTupleValue##dPack()

#define D_T(dCount) T##dCount
#define D_TYPENAME(dCount) typename D_T(dCount)
#define D_VALUE(dCount) mValue##dCount
#define D_ITEM(dCount) Item##dCount
#define D_T_VALUE(dCount) D_T(dCount) D_VALUE(dCount)
#define D_T_ITEM(dCount) D_T(dCount) D_ITEM(dCount)
#define D__GET_OUT(dCount) res.Item##dCount=Item##dCount
#define D_INIT_NULL(dCount) Item##dCount(NULL)
#define D__INIT(dCount) Item##dCount(mValue##dCount)
#define D__SET(dCount) Item##dCount=mValue##dCount
#define D__COPY(dCount) Item##dCount=mTuple.Item##dCount
#define D_COMPARE(dCount) Item##dCount==mTuple.Item##dCount
#define D_COMMA ,
#define D_SEMICOLON ;
#define D_AND &&

#define LIST1(d1) D_##d1(1)
#define LIST2(d1,dD) LIST1(d1)    D_##dD D_##d1(2)
#define LIST3(d1,dD) LIST2(d1,dD) D_##dD D_##d1(3)
#define LIST4(d1,dD) LIST3(d1,dD) D_##dD D_##d1(4)
#define LIST5(d1,dD) LIST4(d1,dD) D_##dD D_##d1(5)
#define LIST6(d1,dD) LIST5(d1,dD) D_##dD D_##d1(6)
#define LIST7(d1,dD) LIST6(d1,dD) D_##dD D_##d1(7)
#define LIST8(d1,dD) LIST7(d1,dD) D_##dD D_##d1(8)

#define TEMP_LIST(dCount) LIST##dCount(T,COMMA)
#define PARAM_DECL(dCount) LIST##dCount(TYPENAME,COMMA)
#define PARAM_LIST(dCount) LIST##dCount(T_VALUE,COMMA)
#define FIELD_DECL(dCount) LIST##dCount(T_ITEM,SEMICOLON)
#define FIELD_LIST(dCount) LIST##dCount(ITEM,COMMA)
#define GET_OUT(dCount) LIST##dCount(_GET_OUT,SEMICOLON)
#define DEFAULT_INIT(dCount) LIST##dCount(INIT_NULL,COMMA)
#define INIT(dCount) LIST##dCount(_INIT,COMMA)
#define SET(dCount) LIST##dCount(_SET,SEMICOLON)
#define COPY(dCount) LIST##dCount(_COPY,SEMICOLON)
#define COMPARE_LIST(dCount) LIST##dCount(COMPARE,AND)

#define TEMPLATE_DECL(dCount) template<PARAM_DECL(dCount)>

#define INIT_FIELDSstruct(dCount,dPack)
#define INIT_FIELDSclass(dCount,dPack)  \
   class##dPack##Tuple##dCount():DEFAULT_INIT(dCount){}   \
   class##dPack##Tuple##dCount(PARAM_LIST(dCount)):INIT(dCount){}
#define COMPARE(dCount) return COMPARE_LIST(dCount)

#define _NULL

#define METHODS_DECL_(dCount,dPack)  \
   class##dPack##Tuple##dCount<TEMP_LIST(dCount)>* GetTuple##dPack() {return new class##dPack##Tuple##dCount<TEMP_LIST(dCount)>(FIELD_LIST(dCount));}   \
   struct##dPack##Tuple##dCount<TEMP_LIST(dCount)> GetTupleValue##dPack(){ \
      struct##dPack##Tuple##dCount<TEMP_LIST(dCount)> res;  \
      GET_OUT(dCount);   \
      return res;}   \
   void operator =(class##dPack##Tuple##dCount<TEMP_LIST(dCount)> &mTuple){COPY(dCount);}   \
   void operator =(struct##dPack##Tuple##dCount<TEMP_LIST(dCount)> &mTuple){COPY(dCount);}  \
   bool operator ==(class##dPack##Tuple##dCount<TEMP_LIST(dCount)> &mTuple){COMPARE(dCount);}  \
   bool operator ==(struct##dPack##Tuple##dCount<TEMP_LIST(dCount)> &mTuple){COMPARE(dCount);}

#define METHODS_DECL(dCount)   \
   METHODS_DECL_(dCount,_NULL)   \
   METHODS_DECL_(dCount,2) \
   METHODS_DECL_(dCount,4) \
   METHODS_DECL_(dCount,8) \
   METHODS_DECL_(dCount,16) 

#define DECL(dType,dCount,dPack,dPackDecl) \
   TEMPLATE_DECL(dCount)   \
   dType dPackDecl dType##dPack##Tuple##dCount{   \
   public:  \
      FIELD_DECL(dCount);   \
      INIT_FIELDS##dType(dCount,dPack) \
      void Set(PARAM_LIST(dCount)) {SET(dCount);}  \
      METHODS_DECL(dCount)  \
   };
   
#define TUPLE_DECL(dCount,dPack,dPackDecl) \
   DECL(struct,dCount,dPack,dPackDecl)   \
   DECL(class,dCount,dPack,dPackDecl)

#define BLOCK_DECL(dCount) \
   TUPLE_DECL(dCount,_NULL,_NULL)   \
   TUPLE_DECL(dCount,1,pack(1)) \
   TUPLE_DECL(dCount,2,pack(2)) \
   TUPLE_DECL(dCount,4,pack(4)) \
   TUPLE_DECL(dCount,8,pack(8)) \
   TUPLE_DECL(dCount,16,pack(16)) 

#define TYPES_DECL_OF(dWich,dCount)   \
   TEMPLATE_DECL(dCount) dWich dWich##Tuple##dCount;    \
   TEMPLATE_DECL(dCount) dWich dWich##1##Tuple##dCount; \
   TEMPLATE_DECL(dCount) dWich dWich##2##Tuple##dCount; \
   TEMPLATE_DECL(dCount) dWich dWich##4##Tuple##dCount; \
   TEMPLATE_DECL(dCount) dWich dWich##8##Tuple##dCount; \
   TEMPLATE_DECL(dCount) dWich dWich##16##Tuple##dCount;
   
#define TYPES_DECL(dCount)   \
   TYPES_DECL_OF(struct,dCount)   \
   TYPES_DECL_OF(class,dCount)   

TYPES_DECL(2)
TYPES_DECL(3)
TYPES_DECL(4)
TYPES_DECL(5)
TYPES_DECL(6)
TYPES_DECL(7)
TYPES_DECL(8)

BLOCK_DECL(2)
BLOCK_DECL(3)
BLOCK_DECL(4)
BLOCK_DECL(5)
BLOCK_DECL(6)
BLOCK_DECL(7)
BLOCK_DECL(8)

#undef D_T
#undef D_TYPENAME
#undef D_VALUE
#undef D_ITEM
#undef D_T_VALUE
#undef D_T_ITEM
#undef D__GET_OUT
#undef D_INIT_NULL
#undef D__INIT
#undef D__SET
#undef D__COPY
#undef D_COMPARE
#undef D_COMMA
#undef D_SEMICOLON
#undef D_AND

#undef LIST1
#undef LIST2
#undef LIST3
#undef LIST4
#undef LIST5
#undef LIST6
#undef LIST7
#undef LIST8

#undef TEMP_LIST
#undef PARAM_DECL
#undef PARAM_LIST
#undef FIELD_DECL
#undef FIELD_LIST
#undef GET_OUT
#undef DEFAULT_INIT
#undef INIT
#undef SET
#undef COPY
#undef COMPARE_LIST
#undef TEMPLATE_DECL
#undef INIT_FIELDSstruct
#undef INIT_FIELDSclass
#undef COMPARE
#undef DECL
#undef TUPLE_DECL
#undef _NULL
#undef METHODS_DECL_
#undef METHODS_DECL
#undef DECL
#undef TUPLE_DECL
#undef BLOCK_DECL
#undef TYPES_DECL_OF
#undef TYPES_DECL

#endif