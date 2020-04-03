#ifndef _C_FLAG_
#define _C_FLAG_

class CFlag
  {
   ulong             cFlag;
public:
                     CFlag(void):cFlag(0) {}
                     CFlag(long mFlag):cFlag(mFlag) {}
   inline ulong Get() {return cFlag;}
   inline bool Check(long mFlag) {return bool(cFlag&mFlag);}
   inline bool CheckStrong(long mFlag) {return (cFlag&mFlag)==mFlag;}
   inline bool CheckRemove(long mFlag) {bool res=bool(cFlag&mFlag); cFlag&=~mFlag; return res;}
   inline bool CheckAdd(long mFlag)    {bool res=bool(cFlag&mFlag); cFlag|=mFlag; return res;}
   inline bool CheckSwitch(long mFlag) {bool res=bool(cFlag&mFlag); cFlag^=mFlag; return res;}
   inline bool CheckStrongRemove(long mFlag) {bool res=(cFlag&mFlag)==mFlag; cFlag&=~mFlag; return res;}
   inline bool CheckStrongAdd(long mFlag)    {bool res=(cFlag&mFlag)==mFlag; cFlag|=mFlag; return res;}
   inline bool CheckStrongSwitch(long mFlag) {bool res=bool(cFlag&mFlag)==mFlag; cFlag^=mFlag; return res;}
   inline bool operator !() {return !cFlag;}
   inline bool operator ==(long mFlag) {return cFlag==mFlag;}
   inline void operator =(long mFlag) {cFlag=mFlag;}
   inline void operator |=(long mFlag) {cFlag|=mFlag;}
   inline void operator &=(long mFlag) {cFlag&=mFlag;}
   inline void operator ^=(long mFlag) {cFlag^=mFlag;}
   inline void operator +=(long mFlag) {cFlag|=mFlag;}
   inline void operator -=(long mFlag) {cFlag&=~mFlag;}
   inline ulong operator |(long mFlag)  {return cFlag|mFlag;}
   inline ulong operator &(long mFlag)  {return cFlag&mFlag;}
  };
//--------------------------------------------------------------------------  
#endif