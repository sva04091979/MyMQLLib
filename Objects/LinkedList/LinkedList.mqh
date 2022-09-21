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
   bool Insert(CLinkedListNode<Type>* hint,Type* it);
   CLinkedListNode<Type>* Erase(CLinkedListNode<Type>* it);
   Type* PopFront();
   Type* PopBack();
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
   if(cFront!=NULL){
      cFront.Prev(node);
   }
   else{
      cBack=node;
   }
   cFront=node;
}
//---------------------------------------------------------
template<typename Type>
void CLinkedList::PushBack(Type* it){
   ++cSize;
   CLinkedListNode<Type>* node=Make(it);
   node.Prev(cBack);
   if(cBack!=NULL){
      cBack.Next(node);
   }
   else{
      cFront=node;
   }
   cBack=node;
}
//---------------------------------------------------------
template<typename Type>
bool CLinkedList::Insert(CLinkedListNode<Type>* hint,Type* it){
   if (!hint){
      PushBack(it);
      return true;
   }
   if (hint.List()!=&this)
      return false;
   if (hint==cFront){
      PushFront(it);
      return true;
   }
   ++cSize;
   CLinkedListNode<Type>* node=Make(it);
   CLinkedListNode<Type>* prev=hint.Prev();
   prev.Next(node);
   hint.Prev(node);
   node.Prev(prev);
   node.Next(hint);
   return true;
}
//---------------------------------------------------------
template<typename Type>
CLinkedListNode<Type>* Erase(CLinkedListNode<Type>* it){
   if (!it||it.List()!=&this)
      return NULL;
   if (it==cFront){
      PopFront();
      return FrontIt();
   }
   else if(it==cBack){
      PopBack();
      return NULL;
   }
   --cSize;
   CLinkedListNode<Type>* ret=it.Next();
   CLinkedListNode<Type>* prev=it.Prev();
   if (prev)
      prev.Next(ret);
   if (ret)
      ret.Prev(ret);
   delete it;
}
//---------------------------------------------------------
template<typename Type>
Type* CLinkedList::PopFront(){
   if (IsEmpty())
      return NULL;
   --cSize;
   Type* ret=cFront.Get();
   if (cBack==cFront)
      cBack=NULL;
   CLinkedListNode<Type>* forDelete=cFront;
   cFront=cFront.Next();
   cFront.Prev(NULL);
   delete forDelete;
   return ret;
}
//---------------------------------------------------------
template<typename Type>
Type* CLinkedList::PopBack(){
   if (IsEmpty())
      return NULL;
   --cSize;
   Type* ret=cBack.Get();
   if (cFront==cBack)
      cFront=NULL;
   CLinkedListNode<Type>* forDelete=cBack;
   cBack=cBack.Prev();
   cBack.Next(NULL);
   delete forDelete;
   return ret;
}


#endif