#ifndef _C_FLAG_
#define _C_FLAG_

class CFlag
  {
   long              cFlag;
public:
                     CFlag(void):cFlag(0) {}
                     CFlag(long mFlag):cFlag(mFlag) {}
   inline long Get() {return cFlag;}
   inline bool Check(long mFlag) {return bool(cFlag&mFlag);}
   inline bool CheckStrong(long mFlag) {return (cFlag&mFlag)==mFlag;}
   inline bool CheckRemove(long mFlag) {bool res=bool(cFlag&mFlag); cFlag&=~mFlag; return res;}
   inline bool CheckAdd(long mFlag)    {bool res=bool(cFlag&mFlag); cFlag|=mFlag; return res;}
   inline bool CheckStrongRemove(long mFlag) {bool res=(cFlag&mFlag)==mFlag; cFlag&=~mFlag; return res;}
   inline bool CheckStrongAdd(long mFlag)    {bool res=(cFlag&mFlag)==mFlag; cFlag|=mFlag; return res;}
   inline void operator =(long mFlag) {cFlag=mFlag;}
   inline void operator |=(long mFlag) {cFlag|=mFlag;}
   inline void operator &=(long mFlag) {cFlag&=mFlag;}
   inline void operator +=(long mFlag) {cFlag|=mFlag;}
   inline void operator -=(long mFlag) {cFlag&=~mFlag;}
   inline long operator |(long mFlag)  {return cFlag|mFlag;}
   inline long operator &(long mFlag)  {return cFlag&mFlag;}
  };
//--------------------------------------------------------------------------  
#endif