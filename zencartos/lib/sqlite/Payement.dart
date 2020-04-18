class Payement{
  int _id;
 
  String _niu;
   String _idandroid;
 
  double _montant;
  
  DateTime _datePaye;
 


  Payement( this._niu, this._montant,this._datePaye,this._idandroid);


//set
  set montant(double newmontant){   this._montant=newmontant;              }

  set datePaye(DateTime newdatePaye){   this._datePaye=newdatePaye;              }
  set idandroid(String newidandroid){   this._idandroid=newidandroid;              }
   set niu(String newniu){   this._niu=newniu;              }
  
  //get
  double get montant=>  _montant;

  String get niu=>  _niu;
   String get idandroid=>  _idandroid;

  DateTime get datePaye=>  _datePaye;
 




  Map<String ,dynamic>mapperpayement(){
  var map=Map<String ,dynamic>();
        if(_id!=null){
      map['id']=_id;}
      map['niu']=_niu;
       map['montant']=_montant;
      map['datePaye']="$_datePaye";
       map['idandroid']=_idandroid;
       
      return map;
}

  Payement.fromMap(Map<String, dynamic> map){
    _id = map['id'];
  
    this._niu = map['niu'];
  
    this._montant=double.parse(map['montant']);
  
    this._datePaye=DateTime.parse("${map['datePaye']}");

  }




}