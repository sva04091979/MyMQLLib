#include "..\..\Define\MQLDefine.mqh"

#ifndef _MY_MQLLIB_LINKED_LIST_
#define _MY_MQLLIB_LINKED_LIST_

template<typename Type>
class CLinkedList;

template<typename Type>
class CLinkedListNode{
   CLinkedList<Type>* cList;
   CLinkedListNode<Type>* cPrev;
   CLinkedListNode<Type>* cNext;
   Type* cPtr;
public:
   CLinkedListNode():cList(NULL),cPrev(NULL),cNext(NULL),cPtr(NULL){}
   void List(CLinkedList<Type>* list) {cList=list;}
   void Prev(CLinkedListNode<Type>* prev) {cPrev=prev;}
   void Next(CLinkedListNode<Type>* next) {cNext=next;}
   CLinkedList<Type>* List() {return cList;}
   CLinkedListNode<Type>* Prev() {return cPrev;}
   CLinkedListNode<Type>* Next() {return cNext;}
   bool IsLast() {return !cNext;}
   bool IsFirst() {return !cPrev;}
   Type* Get() {return cPtr;}
   void Reset(Type* newPtr=NULL) {cPtr=newPtr;}
   void Kill(Type* newPtr=NULL) {DEL(cPtr); Reset(newPtr);}
   Type* Swap(Type* newPtr=NULL) {Type* ret=cPtr; cPtr=newPtr; return ret;}
};

template<typename Type>
class CLinkedList{
   CLinkedListNode<Type>* cFront;
   CLinkedListNode<Type>* cBack;
   uint cSize;
public:
   CLinkedList():cFront(NULL),cBack(NULL),cSize(0){}
   bool IsEmpty() {return !cSize;}
   uint Size() {return cSize;}
   CLinkedListNode<Type>* FrontIt() {return cFront;}
   CLinkedListNode<Type>* BackIt() {return cBack;}   
   Type* Front() {return !cFront?NULL:cFront.Get();}
   Type* Back() {return !cBack?NULL:cBack.Get();}
   void PushFront(Type* it);
   void PushBack(Type* it);
private:
   CLinkedListNode<Type>* Make(Type* it);
};
//--------------------------------------------------
template<typename Type>
CLinkedListNode<Type>* CLinkedList::Make(Type* it){
   CLinkedListNode<Type>* ret=new CLinkedListNode<Type>();
   ret.List(&this);
   ret.Reset(it);
   return ret;
}
//--------------------------------------------------
template<typename Type>
void CLinkedList::PushFront(Type* it){
   ++cSize;
   CLinkedListNode<Type>* node=Make(it);
   node.Next(cFront);
   if(cFront){
      cFront.Prev(node);
   }
   else{
      cBack=node;
   }
   cFront=node;
}

#endif