#ifndef _C_DELEGATE_
#define _C_DELEGATE_

#include "CVector.mqh"

#define delegate(dType,dCount) C##dType##Delegate##dCount

#define VOID_PARAM_DECL0
#define VOID_PARAM_DECL1 typename T1
#define VOID_PARAM_DECL2 VOID_PARAM_DECL1,typename T2
#define VOID_PARAM_DECL3 VOID_PARAM_DECL2,typename T3
#define VOID_PARAM_DECL4 VOID_PARAM_DECL3,typename T4
#define VOID_PARAM_DECL5 VOID_PARAM_DECL4,typename T5
#define VOID_PARAM_DECL6 VOID_PARAM_DECL5,typename T6
#define VOID_PARAM_DECL7 VOID_PARAM_DECL6,typename T7
#define VOID_PARAM_DECL8 VOID_PARAM_DECL7,typename T8

#define OUT_PARAM_DECL0 typename T
#define OUT_PARAM_DECL1 typename T,VOID_PARAM_DECL1
#define OUT_PARAM_DECL2 typename T,VOID_PARAM_DECL2
#define OUT_PARAM_DECL3 typename T,VOID_PARAM_DECL3
#define OUT_PARAM_DECL4 typename T,VOID_PARAM_DECL4
#define OUT_PARAM_DECL5 typename T,VOID_PARAM_DECL5
#define OUT_PARAM_DECL6 typename T,VOID_PARAM_DECL6
#define OUT_PARAM_DECL7 typename T,VOID_PARAM_DECL7

#define PARAM_LIST0
#define PARAM_LIST1 mParam1
#define PARAM_LIST2 PARAM_LIST1,mParam2
#define PARAM_LIST3 PARAM_LIST2,mParam3
#define PARAM_LIST4 PARAM_LIST3,mParam4
#define PARAM_LIST5 PARAM_LIST4,mParam5
#define PARAM_LIST6 PARAM_LIST5,mParam6
#define PARAM_LIST7 PARAM_LIST6,mParam7
#define PARAM_LIST8 PARAM_LIST7,mParam8

#define PARAM_INPUT0
#define PARAM_INPUT1 T1 mParam1
#define PARAM_INPUT2 PARAM_INPUT1,T2 mParam2
#define PARAM_INPUT3 PARAM_INPUT2,T3 mParam3
#define PARAM_INPUT4 PARAM_INPUT3,T4 mParam4
#define PARAM_INPUT5 PARAM_INPUT4,T5 mParam5
#define PARAM_INPUT6 PARAM_INPUT5,T6 mParam6
#define PARAM_INPUT7 PARAM_INPUT6,T7 mParam7
#define PARAM_INPUT8 PARAM_INPUT7,T8 mParam8

#define VOID_TEMPLATE_DECL(dCount) template<VOID_PARAM_DECL##dCount>
#define VOID_TEMPLATE_DECL0
#define VOID_TEMPLATE_DECL1 VOID_TEMPLATE_DECL(1)
#define VOID_TEMPLATE_DECL2 VOID_TEMPLATE_DECL(2)
#define VOID_TEMPLATE_DECL3 VOID_TEMPLATE_DECL(3)
#define VOID_TEMPLATE_DECL4 VOID_TEMPLATE_DECL(4)
#define VOID_TEMPLATE_DECL5 VOID_TEMPLATE_DECL(5)
#define VOID_TEMPLATE_DECL6 VOID_TEMPLATE_DECL(6)
#define VOID_TEMPLATE_DECL7 VOID_TEMPLATE_DECL(7)
#define VOID_TEMPLATE_DECL8 VOID_TEMPLATE_DECL(8)

#define OUT_TEMPLATE_DECL(dCount) template<OUT_PARAM_DECL##dCount>
#define OUT_TEMPLATE_DECL0 OUT_TEMPLATE_DECL(0)
#define OUT_TEMPLATE_DECL1 OUT_TEMPLATE_DECL(1)
#define OUT_TEMPLATE_DECL2 OUT_TEMPLATE_DECL(2)
#define OUT_TEMPLATE_DECL3 OUT_TEMPLATE_DECL(3)
#define OUT_TEMPLATE_DECL4 OUT_TEMPLATE_DECL(4)
#define OUT_TEMPLATE_DECL5 OUT_TEMPLATE_DECL(5)
#define OUT_TEMPLATE_DECL6 OUT_TEMPLATE_DECL(6)
#define OUT_TEMPLATE_DECL7 OUT_TEMPLATE_DECL(7)

#define OUT_TYPEOUT T
#define OUT_TYPEVOID void

#define INVOKEVOID(dCount) for (int i=0,count=cInvokeList.GetSize();i<count;cInvokeList[i++](PARAM_LIST##dCount));}
#define INVOKEOUT(dCount) \
      T res=NULL; \
      for (int i=0,count=cInvokeList.GetSize();i<count;res=cInvokeList[i++](PARAM_LIST##dCount));  \
      return res;}

#define DELEGATE_DECL(dType,dCount) \
   dType##_TEMPLATE_DECL##dCount   \
   class C##dType##Delegate##dCount{  \
      typedef OUT_TYPE##dType (*InvokeDelegateFunction)(PARAM_INPUT##dCount); \
      CVector<InvokeDelegateFunction>  cInvokeList; \
   public:  \
      void operator =(InvokeDelegateFunction mInvokeFunction) {if (cInvokeList.IsEmpty()) cInvokeList.PushBack(mInvokeFunction);    \
                                                               else {cInvokeList.Set(mInvokeFunction,0); cInvokeList.Resize(1);}} \
      void operator +=(InvokeDelegateFunction mInvokeFunction) {cInvokeList.PushBack(mInvokeFunction);}  \
      void operator -=(InvokeDelegateFunction mInvokeFunction);   \
      int Find(InvokeDelegateFunction mInvokeFunction){  \
        for (int i=0,count=cInvokeList.GetSize();i<count;++i) if (cInvokeList[i]==mInvokeFunction) return i;   \
        return -1;}  \
      OUT_TYPE##dType   Invoke(PARAM_INPUT##dCount);  \
   }; \
   dType##_##TEMPLATE_DECL##dCount   \
   void C##dType##Delegate##dCount::operator -=(InvokeDelegateFunction mInvokeFunction){ \
      for (int i=cInvokeList.GetSize()-1;i>=0;--i) \
         if (cInvokeList[i]==mInvokeFunction){  \
            cInvokeList.Delete(i);  \
            break;}} \
   dType##_##TEMPLATE_DECL##dCount   \
   OUT_TYPE##dType C##dType##Delegate##dCount::Invoke(PARAM_INPUT##dCount){   \
      INVOKE##dType(dCount)

DELEGATE_DECL(VOID,0)
DELEGATE_DECL(VOID,1)
DELEGATE_DECL(VOID,2)
DELEGATE_DECL(VOID,3)
DELEGATE_DECL(VOID,4)
DELEGATE_DECL(VOID,5)
DELEGATE_DECL(VOID,6)
DELEGATE_DECL(VOID,7)
DELEGATE_DECL(VOID,8)
DELEGATE_DECL(OUT,0)
DELEGATE_DECL(OUT,1)
DELEGATE_DECL(OUT,2)
DELEGATE_DECL(OUT,3)
DELEGATE_DECL(OUT,4)
DELEGATE_DECL(OUT,5)
DELEGATE_DECL(OUT,6)
DELEGATE_DECL(OUT,7)

#undef VOID_PARAM_DECL0
#undef VOID_PARAM_DECL1
#undef VOID_PARAM_DECL2
#undef VOID_PARAM_DECL3
#undef VOID_PARAM_DECL4
#undef VOID_PARAM_DECL5
#undef VOID_PARAM_DECL6
#undef VOID_PARAM_DECL7
#undef VOID_PARAM_DECL8

#undef OUT_PARAM_DECL0
#undef OUT_PARAM_DECL1
#undef OUT_PARAM_DECL2
#undef OUT_PARAM_DECL3
#undef OUT_PARAM_DECL4
#undef OUT_PARAM_DECL5
#undef OUT_PARAM_DECL6
#undef OUT_PARAM_DECL7

#undef PARAM_LIST0
#undef PARAM_LIST1
#undef PARAM_LIST2
#undef PARAM_LIST3
#undef PARAM_LIST4
#undef PARAM_LIST5
#undef PARAM_LIST6
#undef PARAM_LIST7
#undef PARAM_LIST8

#undef PARAM_INPUT0
#undef PARAM_INPUT1
#undef PARAM_INPUT2
#undef PARAM_INPUT3
#undef PARAM_INPUT4
#undef PARAM_INPUT5
#undef PARAM_INPUT6
#undef PARAM_INPUT7
#undef PARAM_INPUT8

#undef VOID_TEMPLATE_DECL
#undef VOID_TEMPLATE_DECL0
#undef VOID_TEMPLATE_DECL1
#undef VOID_TEMPLATE_DECL2
#undef VOID_TEMPLATE_DECL3
#undef VOID_TEMPLATE_DECL4
#undef VOID_TEMPLATE_DECL5
#undef VOID_TEMPLATE_DECL6
#undef VOID_TEMPLATE_DECL7
#undef VOID_TEMPLATE_DECL8

#undef OUT_TEMPLATE_DECL
#undef OUT_TEMPLATE_DECL0
#undef OUT_TEMPLATE_DECL1
#undef OUT_TEMPLATE_DECL2
#undef OUT_TEMPLATE_DECL3
#undef OUT_TEMPLATE_DECL4
#undef OUT_TEMPLATE_DECL5
#undef OUT_TEMPLATE_DECL6
#undef OUT_TEMPLATE_DECL7

#undef OUT_TYPEOUT
#undef OUT_TYPEVOID

#undef INVOKEVOID
#undef INVOKEOUT

#undef DELEGATE_DECL

#endif