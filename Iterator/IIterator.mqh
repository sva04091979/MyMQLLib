#ifndef _STD_I_ITERATOR_
#define _STD_I_ITERATOR_

#include <STD\Define\StdDefine.mqh>

#define _tEIteratorType __std(EIteratorType)

#define _tdecl_Iterator __decl(_SIterator)
#define _tdeclEIteratorType __decl(EIteratorType)

NAMESPACE(STD)

template<typename ContainerType,typename WrapeType,typename NodeType,typename T>
struct _tdecl_Iterator{
   WrapeType cWrape;
protected:
   _tdecl_Iterator(const WrapeType* mWrape):
      cWrape(mWrape){}
   _tdecl_Iterator(NodeType* mNode,ContainerType* mContainer):
      cWrape(mContainer,mNode){}
public:
   const WrapeType* Wrape() const {return &cWrape;}
   bool CheckContainer(ContainerType &mContainer) {return cWrape.CheckContainer(mContainer);}
public:
   T Dereference() const {return _(cWrape);}
   void operator =(_tdecl_Iterator<ContainerType,WrapeType,NodeType,T> &mOther);
   void operator =(WrapeType &mWrape) {cWrape=mWrape;}
   bool operator ==(_tdecl_Iterator<ContainerType,WrapeType,NodeType,T> &other) {return cWrape==other.cWrape;}
   bool operator !=(_tdecl_Iterator<ContainerType,WrapeType,NodeType,T> &other) {return cWrape!=other.cWrape;}
   bool operator ==(const WrapeType &mWrape) {return cWrape==mWrape;}
   bool operator !=(const WrapeType &mWrape) {return cWrape!=mWrape;}
   bool IsEnd() {return cWrape.IsEnd();}
};
//-----------------------------------------------------------------
template<typename ContainerType,typename WrapeType,typename NodeType,typename T>
void _tdecl_Iterator::operator =(_tdecl_Iterator<ContainerType,WrapeType,NodeType,T> &mOther){
   cWrape=mOther.Wrape();
}

END_SPACE

#endif