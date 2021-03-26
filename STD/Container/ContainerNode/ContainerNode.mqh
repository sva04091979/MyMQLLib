#ifndef _STD_I_CONTAINER_NODE_
#define _STD_I_CONTAINER_NODE_

#include <STD\Define\StdDefine.mqh>

#define _tdeclIContainerNode __decl(IContainerNode)

NAMESPACE(STD)

template<typename NodeType,typename Type>
class _tdeclIContainerNode{
protected:
   Type cObject;
   _tdeclIContainerNode(){}
   _tdeclIContainerNode(const Type &mObj):cObject((Type)mObj){}
   _tdeclIContainerNode(const NodeType &mOther):cObject(_(mOther)){}
  ~_tdeclIContainerNode(){}
public:
   Type Dereference() const {return cObject;}
   Type It() const {return cObject;}
   virtual bool Equal(const NodeType &mOther){return !mOther.IsEnd()&&cObject==_(mOther);}
   virtual NodeType* Free()=0;
   virtual bool IsEnd() const {return false;}
};
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
template<typename NodeType>
NodeType* NewContainerNode(NodeType* mNode,NodeType* mNext){
   return new NodeType(mNode,mNext);}

END_SPACE

#endif