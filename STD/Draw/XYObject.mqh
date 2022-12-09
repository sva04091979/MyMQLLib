#ifndef _ND_COORD_OBJECT_
#define _ND_COORD_OBJECT_

template<typename Type>
class TXYObject:public Type{
   int cX;
   int cY;
   ENUM_BASE_CORNER cCorner;
public:
   ENUM_BASE_CORNER Corner() const {return cCorner;}
   bool Corner(ENUM_BASE_CORNER corner);
   bool X(int x);
   bool Y(int y);
   bool XY(int x,int y) {return X(x)&&Y(y);}
   bool Move(int x,int y) {return XY(x,y);}
   int X() const {return cX;}
   int Y() const {return cY;}
   bool Show() override;
protected:
   void Init() override; 
};
//----------------------------------------------------
template<typename Type>
void TXYObject::Init(){
   Type::Init();
   cCorner=(ENUM_BASE_CORNER)Get(OBJPROP_CORNER);
   cX=(int)Get(OBJPROP_XDISTANCE);
   cY=(int)Get(OBJPROP_YDISTANCE);
}
//----------------------------------------------------
template<typename Type>
bool TXYObject::Corner(ENUM_BASE_CORNER corner){
   bool ret=Set(OBJPROP_CORNER,corner);
   if (ret)
      cCorner=corner;
   return ret;
}
//----------------------------------------------------
template<typename Type>
bool TXYObject::X(int x){
   bool ret=Set(OBJPROP_XDISTANCE,x);
   if (ret)
      cX=x;
   return ret;
}
//----------------------------------------------------
template<typename Type>
bool TXYObject::Y(int y){
   bool ret=Set(OBJPROP_YDISTANCE,y);
   if (ret)
      cY=y;
   return ret;
}
//----------------------------------------------------
template<typename Type>
bool TXYObject::Show(){
   bool ret=Type::Show();
   if (ret){
      Corner(cCorner);
      XY(cX,cY);
   }
   return ret;
}

#endif