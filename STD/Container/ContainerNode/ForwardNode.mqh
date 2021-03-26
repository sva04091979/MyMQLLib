#ifndef _STD_I_FORWARD_NODE_
#define _STD_I_FORWARD_NODE_

#include "ContainerNode.mqh"

#define _tdeclForwardNode __decl(CForwardNode)
#define __Node _tdeclForwardNode<Type>
#define _tdeclForwardNodeEnd __decl(CForwardNodeEnd)

NAMESPACE(STD)

template<typename Type>
class _tdeclForwardNode:public _tdeclIContainerNode<__Node,Type>{
protected:
   __Node* cNext;
  ~_tdeclForwardNode(){}
public:
   _tdeclForwardNode():_tdeclIContainerNode<__Node,Type>(){}
   _tdeclForwardNode(__Node* mNode,__Node* mNext):_tdeclIContainerNode<__Node,Type>(mNode.cObject),cNext(mNext){}
   _tdeclForwardNode(const Type &mObj,__Node* mNext):_tdeclIContainerNode<__Node,Type>(mObj),cNext(mNext){}
   _tdeclForwardNode(const __Node &mOther):_tdeclIContainerNode<__Node,Type>(mOther),cNext(mOther.Next()){}
//   static __Node* NewNode(__Node &mNode,__Node* mNext) {return new __Node(mNode.cObject,mNext);}
   __Node* Free() override;
   __Node* Next() const {return cNext;}
   __Node* EraceAfter();
   __Node* InsertAfter(const Type &mVal);
   void Next(__Node* mNext) {cNext=mNext;}
   bool IsLast() {return cNext!=NULL&&cNext.IsEnd();}
};
//-------------------------------------------------
template<typename Type>
__Node* _tdeclForwardNode::Free(){
   __Node* ret=cNext;
   delete &this;
   return ret;
}
//-------------------------------------------------
template<typename Type>
__Node* _tdeclForwardNode::EraceAfter(){
   cNext=cNext.Free();
   return cNext;
}
//-------------------------------------------------
template<typename Type>
__Node* _tdeclForwardNode::InsertAfter(const Type &mVal){
   cNext=new __Node(mVal,cNext);
   return cNext;
}

template<typename Type>
class _tdeclForwardNodeEnd:public _tdeclForwardNode<Type>{
public:
   _tdeclForwardNodeEnd():_tdeclForwardNode<Type>(){}
   bool IsEnd() override const {return true;}
   bool Equal(const _tdeclForwardNode<Type> &mOther) override {return mOther.IsEnd();}
};

END_SPACE

#undef __Node

#endif