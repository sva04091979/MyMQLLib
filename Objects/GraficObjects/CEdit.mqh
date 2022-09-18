#ifndef _C_EDIT_
#define _C_EDIT_

#include "CPointObject.mqh"

class CEdit:public CField{
public:
   CEdit(string mName,
         long mChartId,
         int mSubWindow,
         long mX,
         long mY,
         long mXSize,
         long mYSize,
         int mFlag=0);
};
//------------------------------------------------------------
CEdit::CEdit(string mName,long mChartId,int mSubWindow,long mX,long mY,long mXSize,long mYSize,int mFlag=0):
   CField(mName,OBJ_EDIT,mChartId,mSubWindow,mX,mY,mXSize,mYSize,mFlag){
   SetText(NULL);}

#endif