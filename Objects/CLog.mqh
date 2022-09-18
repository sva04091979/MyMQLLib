#ifndef _C_LOG_
#define _C_LOG_

#define LOG(dText) CLog::Ptr().Log((string)__LINE__,__FUNCSIG__,dText)

class CLog{
   int cHndl;
   CLog():cHndl(FileOpen(MQLInfoString(MQL_PROGRAM_NAME)+_Symbol+(string)(ulong)TimeCurrent()+".log",FILE_TXT|FILE_WRITE)){}
  ~CLog() {FileClose(cHndl);}
public:
   static CLog* Ptr() {static CLog _log; return &_log;}
   void Log(string line,string sig,string text){
      string _text=StringFormat("Line: %s. Signature: %s. %s",line,sig,text);
      PrintFormat(_text);
      FileWrite(cHndl,_text);}
};

#endif