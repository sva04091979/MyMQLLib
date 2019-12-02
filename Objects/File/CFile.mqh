#ifndef _C_FILE_
#define _C_FILE_

#define FLAG_MUST_CREATE   0x1
#define FLAG_FILE_EXIST    0x2
#define FLAG_FILE_OPEN     0x4

#define FLAG_OPEN_SUCCES   (FLAG_FILE_EXIST|FLAG_FILE_OPEN)

#define FILE_FULL_ACCESS (FILE_READ|FILE_WRITE|FILE_SHARE_READ|FILE_SHARE_WRITE)

#define IS_FILE_OPEN    bool(cFlag&FLAG_FILE_OPEN)
#define IS_FILE_EXIST   CheckExist()

class CFile
  {
   string            cName;
   string            cShortName;
   string            cPath;
   string            cFullName;
   string            cFullPath;
   long              cSeek;
   int               cHndl;
   int               cFlag;
   int               cOpenFlag;
public:
                     CFile(string mName,int mOpenFlag,bool mIsCreate=true,bool mIsOpen=true);
                    ~CFile()  {if (IS_FILE_OPEN) FileClose(cHndl);}
   string            GetName()      {return cName;}
   string            GetShortName() {return cShortName;}
   string            GetPath()      {return cPath;}
   string            GetFullName()  {return cFullName;}
   string            GetFullPath()  {return cFullPath;}
   int               GetHandle()    {return cHndl;}
   bool              IsExist()      {return IS_FILE_OPEN||CheckExist();}
   bool              OpenFile(bool nIsCreate=true);
   void              CloseFile();
   void              DeleteFile();
   bool              CheckExist();
   uint              Write(string mData,long mSeek=0,ENUM_FILE_POSITION mPosType=SEEK_CUR);
   void              Flush()        {if (IS_FILE_OPEN) FileFlush(cHndl);}
private:
   string            GetPath(string mName);
   string            GetFullPath(int mOpenFlag);
  };
//---------------------------------------------------------------------------
void CFile::CFile(string mName,int mOpenFlag,bool mIsCreate=true,bool mIsOpen=true):
   cName(mName),cHndl(INVALID_HANDLE),cFlag(mIsCreate?FLAG_MUST_CREATE:0),cOpenFlag(mOpenFlag){
   cPath=GetPath(mName);
   string fullPath=GetFullPath(mOpenFlag);
   cFullPath=fullPath+cPath;
   cFullName=fullPath+cName;
   if (mIsCreate||!CheckExist()) OpenFile();}
//----------------------------------------------------------------------------
string CFile::GetPath(string mName){
   string data[];
   int count=StringSplit(mName,'\\',data)-1;
   cShortName=data[count];
   string path=NULL;
   for (int i=0;i<count;path+=data[i++]+"\\");
   return path;}
//----------------------------------------------------------------------------
string CFile::GetFullPath(int mOpenFlag){
   bool isTester=MQLInfoInteger(MQL_TESTER);
   bool isTester=MQLInfoInteger(MQL_TESTER);
   string data[];
   int size=StringSplit(__PATH__,'\\',data);
   st||isTesterring stopDirectory=bool(mOpenFlag&FILE_COMMON)||isTester?"Terminal":#ifdef __MQL5__ "MQL5" #else "MQL4" #endif;
   string path=NULL;
   for (int i=0;i<size;++i){
    {
         if (isTester) path+=data[i+1]+"\\";
         break;}}
   path+=bool(mOpenFlag&FILE_COMMON)?"Common\\Files\\":isTester?"tester\\files\\":"isTester) path+=data[i+1]+"\\";
         break;}}
   path+=bool(mOpenFlag&FILE_COMMON)?"Common\\Files\\":isTester?"tester\\files\\":"Files\\";
   return path;}
//---------------------------------------------------------------------------
bool CFile::CheckExist(){
   if (FileIsExist(cName,cOpenFlag&FILE_COMMON)) cFlag|=FLAG_FILE_EXIST;
   else cFlag&=~FLAG_FILE_EXIST;
   return bool(cFlag&FLAG_FILE_EXIST);}
//----------------------------------------------------------------------------
bool CFile::OpenFile(bool mIsCreate=true){
   if (IS_FILE_OPEN) return true;
   if (!CheckExist()&&!(cFlag&FLAG_MUST_CREATE)&&!mIsCreate) return false;
   if ((cHndl=FileOpen(cName,cOpenFlag))!=INVALID_HANDLE) cFlag|=FLAG_OPEN_SUCCES;
   return cHndl!=INVALID_HANDLE;}
//---------------------------------------------------------------------------
void CFile::CloseFile(void){
   if (!IS_FILE_OPEN) return;
   else FileClose(cHndl);
   cHndl=INVALID_HANDLE;
   cFlag&=~FLAG_FILE_OPEN;}
//-----------------------------------------------------------------------------
void CFile::DeleteFile(void){
   if (!IS_FILE_OPEN&&!CheckExist()) return;
   if (IS_FILE_OPEN) CloseFile();
   if (FileDelete(cName,cOpenFlag&FILE_COMMON)) cFlag&=~FLAG_FILE_EXIST;}
//-----------------------------------------------------------------------------
uint CFile::Write(string mData,long mSeek=0,ENUM_FILE_POSITION mPosType=SEEK_CUR){
   bool isOpen=IS_FILE_OPEN;
   if (!IS_FILE_EXIST   ||
       (!isOpen&&!OpenFile())) return 0;
   if (!