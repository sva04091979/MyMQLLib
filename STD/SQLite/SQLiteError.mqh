#ifndef _STD_SQLITE_ERROR_
#define _STD_SQLITE_ERROR_

#define SQLiteError STD_SQLiteError::Instance()

class STD_SQLiteError{
   int cLast;
   STD_SQLiteError():cLast(0){}
public:
   static STD_SQLiteError* Instance();
   int Last() {int ret=cLast; cLast=0; return ret;}
   string Text() {return Text(Last());}
   string Text(int err);
   void operator=(int errCode) {cLast=errCode;}
};
//----------------------------------------
STD_SQLiteError* STD_SQLiteError::Instance(void){
   static STD_SQLiteError instance;
   return &instance;
}
//-----------------------------------------
string STD_SQLiteError::Text(int err){
   switch(err){
      default: return (string)err;
   }
}

#endif