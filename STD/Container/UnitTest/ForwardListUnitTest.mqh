#ifndef _STD_FORWARD_LIST_UNIT_TEST_
#define _STD_FORWARD_LIST_UNIT_TEST_

#include <STD\Container\ForwardList.mqh>

struct SUnitTestForwardList{
   int a;
   SUnitTestForwardList(){}
   SUnitTestForwardList(int _a):a(_a){}
   SUnitTestForwardList(SUnitTestForwardList &mOther){this=mOther;}
   bool operator ==(SUnitTestForwardList &mOther) {return a==mOther.a;}
};

class CUnitTestForwardList{
public:
   int a;
   CUnitTestForwardList(){}
   CUnitTestForwardList(int _a):a(_a){}
   CUnitTestForwardList(const CUnitTestForwardList &mOther){this=mOther;}
   bool operator ==(CUnitTestForwardList &mOther) {return a==mOther.a;}
};

void ForwardListUnitTest(void){
   int arr[]={0,1,2,3,4,5,6,7,8,9};
   int backArr[];
   int size=ArrayResize(backArr,ArraySize(arr));
   for(int i=0,ii=size-1;i<size;backArr[ii--]=arr[i++]);
   _tForwardList<int> test(arr);
   _tForwardList<int> testCopy(test);
   _tForwardList<SUnitTestForwardList> testStruct;
   _tForwardList<CUnitTestForwardList> testClass;
   _tForwardList<CUnitTestForwardList*> testPtr;
   for(int i=0;i<size;++i){
      testStruct.PushFront(SUnitTestForwardList(backArr[i]));
      testClass.PushFront(CUnitTestForwardList(backArr[i]));
      testPtr.PushFront(_rv(new CUnitTestForwardList(backArr[i])));
   }
   _tForwardIterator(int) it=test.Begin(),itCopy=testCopy.Begin();
   ASSERT(test.Size()==size&&test.Size()==testCopy.Size(),"Initialise error");
   for (int i=0;i<size;++i){
      ASSERT(arr[i]==_(it)&&
            _(it)==_(itCopy),"Copy error");
      ++it;
      ++itCopy;
   }
   while(!testPtr.IsEmpty()) delete testPtr.PopFront();
/*
   _tForwardIterator(int) it=test.Begin();
   ++it;
   it=test.InsertAfter(++it,_rv(777));
   PrintFormat("Size=%u",test.Size());
   PrintFormat("It=%i",_(it));
   for (it=test.Begin();!it.IsEnd();++it)
      Print(_(it));
   _tForwardList<SUnitTestForwardList> test1();
   for (int i=0;i<ArraySize(x);++i){
      test1.PushFront(SUnitTestForwardList(i));
   }
   _tForwardIterator(SUnitTestForwardList) _it=test1.Begin();
   ++_it;
   _it=test1.InsertAfter(++_it,SUnitTestForwardList(777));
   PrintFormat("Size=%u",test1.Size());
   PrintFormat("It=%i",_(_it).a);
   test1.EraceAfter(_it);
   for (_it=test1.Begin();!_it.IsEnd();++_it)
      Print(_(_it).a);
*/
   Print("ForwardList ok");
}

#endif