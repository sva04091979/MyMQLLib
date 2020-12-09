#ifndef _STD_CONTAINER_NODE_
#define _STD_CONTAINER_NODE_

#include <STD\Define\StdDefine.mqh>

#define _tdecl_ItNode __decl(_CItNode)
#define _tdecl_ContainerNode __decl(_CContainerNode)
#define _tdecl_ForwardNode __decl(_CForwardNode)


NAMESPACE(STD)

template<typename T,typename Type>
class _tdecl_ContainerNode{
protected:
   T cObject;
   _tdecl_ContainerNode(){}
   _tdecl_ContainerNode(const T &mObj):cObject((T)mObj){}
   _tdecl_ContainerNode(const Type &mOther):cObject(_(mOther)){}
  ~_tdecl_ContainerNode(){}
public:
   T Dereference() const {return cObject;}
   virtual bool Equal(const Type &mOther){return !mOther.IsEnd()&&cObject==_(mOther);}
   virtual Type* Free()=0;
   virtual bool IsEnd() const {return false;}
};
////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
template<typename T,typename Type>
class _tdecl_ForwardNode:public _tdecl_ContainerNode<T,Type>{
protected:
   Type* cNext;
   _tdecl_ForwardNode():_tdecl_ContainerNode<T,Type>(){}
   _tdecl_ForwardNode(const T &mObj,Type* mNext):_tdecl_ContainerNode<T,Type>(mObj),cNext(mNext){}
   _tdecl_ForwardNode(const Type &mOther):_tdecl_ContainerNode<T,Type>(mOther),cNext(mOther.Next()){}
public:
   static Type* NewNode(_tdecl_ForwardNode<T,Type> &mNode,Type* mNext) {return new Type(mNode.cObject,mNext);}
   Type* Free() override;
   Type* Next() const {return cNext;}
   Type* EraceNext();
   Type* Insert(const T &mVal);
   void Next(Type* mNext) {cNext=mNext;}
   bool IsLast() {return cNext!=NULL&&cNext.IsEnd();}
};
//-------------------------------------------------
template<typename T,typename Type>
Type* _tdecl_ForwardNode::Free(){
   Type* ret=cNext;
   delete &this;
   return ret;
}
//-------------------------------------------------
template<typename T,typename Type>
Type* _tdecl_ForwardNode::EraceNext(){
   cNext=cNext.Free();
   return cNext;
}
//-------------------------------------------------
template<typename T,typename Type>
Type*
_tdecl_ForwardNode::Insert(const T &mVal){
   cNext=new Type(mVal,cNext);
   return cNext;
}


END_SPACE

#endif