#ifndef _C_MULTISIZE_ARRAY_
#define _C_MULTISIZE_ARRAY_

#include <MyMQLLib\Objects\CUniquePtr.mqh>
#include "CArray.mqh"

#define D__NULL

#define D_ARRAY(dCount) CArray<
#define D_CLOSE(dCount) >>
#define D_DELIM CUniquePtr<

#define LIST1(d1) D_##d1(1)
#define LIST2(d1,dD) LIST1(d1)    D_##dD D_##d1(2)
#define LIST3(d1,dD) LIST2(d1,dD) D_##dD D_##d1(3)
#define LIST4(d1,dD) LIST3(d1,dD) D_##dD D_##d1(4)
#define LIST5(d1,dD) LIST4(d1,dD) D_##dD D_##d1(5)
#define LIST6(d1,dD) LIST5(d1,dD) D_##dD D_##d1(6)
#define LIST7(d1,dD) LIST6(d1,dD) D_##dD D_##d1(7)
#define LIST8(d1,dD) LIST7(d1,dD) D_##dD D_##d1(8)

#define CMultiRangeArray(dCount,T) LIST##dCount(ARRAY,DELIM) T LIST##dCount(CLOSE,_NULL)

#endif