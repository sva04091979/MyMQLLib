#ifndef _ND_ANCHOR_POINT_OBJECT_
#define _ND_ANCHOR_POINT_OBJECT_

template<typename Type>
class TAnchorPoint:public Type{
   ENUM_ANCHOR_POINT cAnchorPoint;
public:
   ENUM_ANCHOR_POINT AnchorPoint() const {return cAnchorPoint;}
   bool AnchorPoint(ENUM_ANCHOR_POINT anchorPoint);
   bool Show(int subW) override;
protected:
   void Init() override; 
};
//----------------------------------------------------
template<typename Type>
void TAnchorPoint::Init(){
   Type::Init();
   cAnchorPoint=(ENUM_ANCHOR_POINT)Get(OBJPROP_ANCHOR);
}
//----------------------------------------------------
template<typename Type>
bool TAnchorPoint::AnchorPoint(ENUM_ANCHOR_POINT anchorPoint){
   bool ret=Set(OBJPROP_ANCHOR,anchorPoint);
   if (ret)
      cAnchorPoint=anchorPoint;
   return ret;
}
//----------------------------------------------------
template<typename Type>
bool TAnchorPoint::Show(int subW){
   bool ret=Type::Show(subW);
   if (ret){
      AnchorPoint(cAnchorPoint);
   }
   return ret;
}

#endif