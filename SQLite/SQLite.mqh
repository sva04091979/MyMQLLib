#ifndef _STD_SQLLITE_
#define _STD_SQLLITE_
#ifdef __MQL5__
   #define DBBind(request,index,value) bool DatabaseBind(request,index,value)
#else

#define SQLITE_OK 0
#define SQLITE_ROW 100
#define SQLITE_DONE 101

#define SQLITE_TRANSIENT -1

#define DATABASE_OPEN_READONLY 0x1
#define DATABASE_OPEN_READWRITE 0x2
#define DATABASE_OPEN_CREATE 0x4
#define DATABASE_OPEN_MEMORY 0x80
#define DATABASE_OPEN_COMMON 0x1000

#ifdef DB_NO_ERROR_CONTROL
   #define ErrorSet(dErr) do while(false)
#else
   #define ErrorSet(dErr) do SQLiteError=dErr; while(false)
#endif

#import "sqlite3.dll"
   int sqlite3_open_v2(uchar &filename[], /* Database filename (UTF-8) */
                       int &ppDb,      /* OUT: SQLite db handle */
                       uint flags,         /* Flags */
                       int zVfs);      /* Name of VFS module to use */
   int sqlite3_close_v2(int database);
   int sqlite3_exec(int database,                                  /* An open database */
                    uchar &sql[],                           /* SQL to be evaluated */
                    int, /* (*callback)(void*,int,char**,char**),*/  /* Callback function */
                    int, /*void *,*/        /* 1st argument to callback */
                    int); /*char **errmsg);*/                              /* Error msg written here */
int sqlite3_prepare16_v2(
     int db,/*sqlite3 *db,          */  /* Database handle */
     string query,/*const void *zSql,     */  /* SQL statement, UTF-16 encoded */
     int,/*int nByte,            */  /* Maximum length of zSql in bytes. */
     int& pStmt,/*sqlite3_stmt **ppStmt,*/  /* OUT: Statement handle */
     int/*const void **pzTail   */  /* OUT: Pointer to unused portion of zSql */
   );   
int sqlite3_finalize(int request);
void sqlite3_free(int);
int sqlite3_errcode(int db);
string sqlite3_errmsg16(int db);
int sqlite3_db_handle(int request);
int sqlite3_column_count(int request);
int sqlite3_step(int request);
string sqlite3_column_origin_name16(int request,int columNumber);
int sqlite3_column_type(int request,int iCol);
string sqlite3_column_text16(int stmt,int iCol);
int sqlite3_column_int(int stmt, int iCol);
long sqlite3_column_int64(int stmt, int iCol);
double sqlite3_column_double(int stmt, int iCol);
int sqlite3_bind_double(int stmt,int index,double value);
int sqlite3_bind_int(int stmt,int index,int value);
int sqlite3_bind_int64(int stmt,int index,long value);
int sqlite3_bind_text16(int stmt,int index,string value,int,int);
int sqlite3_reset(int stmt);
#import

enum ENUM_DATABASE_FIELD_TYPE{
   DATABASE_FIELD_TYPE_INVALID,
   DATABASE_FIELD_TYPE_INTEGER,
   DATABASE_FIELD_TYPE_FLOAT,
   DATABASE_FIELD_TYPE_TEXT,
   DATABASE_FIELD_TYPE_BLOB,
   DATABASE_FIELD_TYPE_NULL
};

//---------------------------------------------------------------------------------------
int DatabaseLastError(int database){
   return database==INVALID_HANDLE?-1:sqlite3_errcode(database);
}
//---------------------------------------------------------------------------------------
int DatabaseOpen(string filename,uint flags){
   static string filesPath=TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL4\\Files\\";
   static string commonFilesPath=TerminalInfoString(TERMINAL_COMMONDATA_PATH)+"\\Files\\";
   bool isCommon=bool(flags&DATABASE_OPEN_COMMON);
   flags&=~DATABASE_OPEN_COMMON;
   filename=isCommon?commonFilesPath+filename:filesPath+filename;
   uchar fname[];
   StringToCharArray(filename,fname,0,WHOLE_ARRAY,CP_UTF8);
   int ret;
   if (SQLITE_OK!=sqlite3_open_v2(fname,ret,flags,NULL)){
      PrintFormat("DB open error: %s",sqlite3_errmsg16(ret));
      DatabaseClose(ret);
      return INVALID_HANDLE;}
   else return ret;
}
//-----------------------------------------------------------------------------------------
void DatabaseClose(int database){
   if (database!=INVALID_HANDLE&&SQLITE_OK!=sqlite3_close_v2(database))
      PrintFormat("DB close error: %s",sqlite3_errmsg16(database));
}
//-----------------------------------------------------------------------------------------
bool DatabaseExecute(int database,string sql){
   if (database==INVALID_HANDLE) return false;
   uchar query[];
   StringToCharArray(sql,query,0,WHOLE_ARRAY,CP_UTF8);
   int ret=sqlite3_exec(database,query,NULL,NULL,NULL);
   if (ret!=SQLITE_OK){
      PrintFormat("DB execute error: %s",sqlite3_errmsg16(database));
      }
   return !ret;
}
//----------------------------------------------------------------------------------------
int DatabasePrepare(int database,string  sql){
   if (database==INVALID_HANDLE) return INVALID_HANDLE;
   int ret;
   int errCode=sqlite3_prepare16_v2(database,sql,-1,ret,NULL);
   if (errCode!=0)
      PrintFormat("DB prepare error: %s",sqlite3_errmsg16(database));
   return !errCode?ret:INVALID_HANDLE;
}

//--------------------------------------------------------------------------------------------
void DatabaseFinalize(int request){
   if (request==INVALID_HANDLE) return;
   int errCode=sqlite3_finalize(request);
   if (errCode!=SQLITE_OK)
      PrintFormat("DB finalize error: %s",sqlite3_errmsg16(sqlite3_db_handle(request)));
}
//----------------------------------------------------------------------------
bool DatabaseRead(int request){
   if (request==INVALID_HANDLE) return false;
   int res=sqlite3_step(request);
   switch(res){
      case SQLITE_ROW:
         return true;
      case SQLITE_DONE:
         return false;
      default:
         PrintFormat("DB read error: %s",sqlite3_errmsg16(sqlite3_db_handle(request)));
         return false;
   }
}
//----------------------------------------------------------------------------
bool DatabaseReset(int request){
   if (request==INVALID_HANDLE) return false;
   int errCode=sqlite3_reset(request);
   if (errCode!=SQLITE_OK)
      PrintFormat("DB reset error: %s",sqlite3_errmsg16(sqlite3_db_handle(request)));
   return errCode==SQLITE_OK; 
}
//----------------------------------------------------------------------------
int DatabaseColumnsCount(int request){
   return request==INVALID_HANDLE?-1:sqlite3_column_count(request);
}
//-----------------------------------------------------------------------------
bool DatabaseColumnName(int request,int column,string& name){
   if (request==INVALID_HANDLE) return false;
   name=sqlite3_column_origin_name16(request,column);
   if (name==NULL)
         PrintFormat("DB column name error: %s",sqlite3_errmsg16(sqlite3_db_handle(request)));
   return name!=NULL;
}
//-----------------------------------------------------------------------------
ENUM_DATABASE_FIELD_TYPE DatabaseColumnType(int request,int column){
   if (request==INVALID_HANDLE) return DATABASE_FIELD_TYPE_INVALID;
   return (ENUM_DATABASE_FIELD_TYPE)sqlite3_column_type(request,column);
}
//-----------------------------------------------------------------------------
bool DatabaseColumnText(int request,int column,string& value){
   if (request==INVALID_HANDLE) return false;
   value=sqlite3_column_text16(request,column);
   return true;
}
//-----------------------------------------------------------------------------
bool DatabaseColumnInteger(int request,int column,int& value){
   if (request==INVALID_HANDLE) return false;
   value=sqlite3_column_int(request,column);
   return true;
}
//-----------------------------------------------------------------------------
bool DatabaseColumnLong(int request,int column,long& value){
   if (request==INVALID_HANDLE) return false;
   value=sqlite3_column_int64(request,column);
   return true;
}
//-----------------------------------------------------------------------------
bool DatabaseColumnDouble(int request,int column,double& value){
   if (request==INVALID_HANDLE) return false;
   value=sqlite3_column_double(request,column);
   return true;
}
//------------------------------------------------------------------------------
template<typename Type>
bool DBBind(int request,int index,Type value){
   if (request==INVALID_HANDLE) return false;
   int errCode=_DatabaseBind(request,index,value);
   switch(errCode){
      case -1: return false;
      case SQLITE_OK: return true;
      default:
         PrintFormat("DB bind error: %s",sqlite3_errmsg16(sqlite3_db_handle(request)));
         return false;
   }
}
//------------------------------------------------------------------------------
template<typename Type>
int _DatabaseBind(int request,int index,Type value){
   return -1;
}
//-----------------------------------------------------------------------------------
int _DatabaseBind(int request,int index,double value){
   return sqlite3_bind_double(request,index,value);
}
//-----------------------------------------------------------------------------------
int _DatabaseBind(int request,int index,float value){
   return sqlite3_bind_double(request,index,value);
}
//-----------------------------------------------------------------------------------
int _DatabaseBind(int request,int index,bool value){
   return sqlite3_bind_int(request,index,value);
}
//-----------------------------------------------------------------------------------
int _DatabaseBind(int request,int index,char value){
   return sqlite3_bind_int(request,index,value);
}
//-----------------------------------------------------------------------------------
int _DatabaseBind(int request,int index,uchar value){
   return sqlite3_bind_int(request,index,value);
}
//-----------------------------------------------------------------------------------
int _DatabaseBind(int request,int index,short value){
   return sqlite3_bind_int(request,index,value);
}
//-----------------------------------------------------------------------------------
int _DatabaseBind(int request,int index,ushort value){
   return sqlite3_bind_int(request,index,value);
}
//-----------------------------------------------------------------------------------
int _DatabaseBind(int request,int index,int value){
   return sqlite3_bind_int(request,index,value);
}
//-----------------------------------------------------------------------------------
int _DatabaseBind(int request,int index,uint value){
   return sqlite3_bind_int(request,index,value);
}
//-----------------------------------------------------------------------------------
int _DatabaseBind(int request,int index,color value){
   return sqlite3_bind_int(request,index,value);
}
//-----------------------------------------------------------------------------------
int _DatabaseBind(int request,int index,datetime value){
   return sqlite3_bind_int64(request,index,value);
}
//-----------------------------------------------------------------------------------
int _DatabaseBind(int request,int index,long value){
   return sqlite3_bind_int64(request,index,value);
}
//-----------------------------------------------------------------------------------
int _DatabaseBind(int request,int index,ulong value){
   return sqlite3_bind_int64(request,index,value);
}
//-----------------------------------------------------------------------------------
int _DatabaseBind(int request,int index,string value){
   return sqlite3_bind_text16(request,index,value,-1,SQLITE_TRANSIENT);
}

#endif
#endif