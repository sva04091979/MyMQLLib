#ifndef _C_SINCHRO_BY_OBJ_
#define _C_SINCHRO_BY_OBJ_

#define SINCHRO_OBJECT_NAME(dName) ("Sinchronization object "+dName)

class CSinchroByObj
  {
   string            cName;
   long              cChartId;
   bool              cIsLock;
public:
                     CSinchroByObj(string mId=NULL);
                    ~CSinchroByObj(void) {if (cIsLock) ObjectDelete(0,cName);}
   bool              Check(int mMaxCount=0);
   bool              Lock()   {if (!cIsLock) cIsLock=ObjectCreate(0,cName,OBJ_HLINE,0,0,0); return cIsLock;}
   bool              Unlock() {if (cIsLock) cIsLock=!(ObjectDelete(0,cName)||ObjectFind(0,cName)<0); return !cIsLock;}
   bool              IsLocked()  {return cIsLock;}
  };
//-----------------------------------------------------------------
void CSinchroByObj::CSinchroByObj(string mId=NULL):
   cName(SINCHRO_OBJECT_NAME(mId)),cChartId(ChartID()),cIsLock(false){}
//-----------------------------------------------------------------
bool CSinchroByObj::Check(int mMaxCount=0){
   int count=0;
   long id=ChartFirst();
   if (id!=cChartId&&ObjectFind(id,cName)>=0) ++count;
   if (count>mMaxCount) return false;
   while ((id=ChartNext(id))>=0){
      if (id!=cChartId&&ObjectFind(id,cName)>=0) ++count;
      if (count>mMaxCount) return false;}
   return true;}

#endif