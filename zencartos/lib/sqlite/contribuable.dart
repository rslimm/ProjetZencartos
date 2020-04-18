class Contribuable{
  int id;
  String _name;
  String _sigle;
  String _niu;
  String _activite;
  double _long;
  double _lat;
  DateTime _datePaye;
  String  _autorisation;


  Contribuable(this.id, this._name, this._sigle, this._niu, this._activite,this._long,this._lat,this._datePaye,this._autorisation);


//set
  set long(double newlong){   this._long=newlong;              }
  set lat(double newlat){   this._lat=newlat;              }
  set name(String newname){   this._name=newname;              }
  set sigle(String newsigle){   this._sigle=newsigle;              }
  set datePaye(DateTime newdatePaye){   this._datePaye=newdatePaye;              }
  set autorisation(String newautorisation){   this._autorisation=newautorisation;              }
  //get
  double get long=>  _long;
  double get lat=>  _lat;
  String get name=>  _name;
  String get niu=>  _niu;
  String get activite=>  _activite;
  String get sigle=>  _sigle;
  DateTime get datePaye=>  _datePaye;
  String get autorisation=>  _autorisation;

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'id': id,
      'name': _name,
      'sigle': _sigle,
      'niu': _niu,
      'activite': _activite,
      'long':_long,
      'lat':_lat,
       'datePaye':"$_datePaye",
        'autorisation':_autorisation,
    };
    return map;
  }

  Contribuable.fromMap(Map<String, dynamic> map){
    id = map['id'];
    this._name = map['name'];
    this._sigle = map['sigle'];
    this._niu = map['niu'];
    this._activite = map['activite'];
    this._long=map['long'];
    this._lat=map['lat'];
    this._datePaye=DateTime.parse("${map['datePaye']}");
    this.autorisation=map['autorisation'];
  }




}