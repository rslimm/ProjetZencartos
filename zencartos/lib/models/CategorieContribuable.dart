import 'package:meta/meta.dart';

import 'Model.dart';


class CategorieContribuable extends Model
{
  String nom;

  CategorieContribuable({String id,
    @Required() this.nom,
    DateTime createdAt,
    DateTime deletedAt,
  }) : super(id: id, deletedAt: deletedAt, createdAt: createdAt);

  set createdAt(DateTime _createdAt) => super.createdAt = _createdAt;

  set deletedAt(DateTime _deletedAt) => super.deletedAt = _deletedAt;

  set id(String _id) => super.id = _id;

  DateTime get createdAt{ return super.createdAt;}

  DateTime get deletedAt => super.deletedAt;

  String get id => super.id;


  Map<String, dynamic> toMap(){
    Map<String, dynamic> superMap = super.toMap();
    Map<String, dynamic> map = {
      'nom': this.nom,
    };
    superMap.forEach((String key, dynamic value) => map[key] = value);

    return map;
  }

  @override
  fromMap(Map<String, dynamic> map, {bool dynamique = false}) {
    this.nom = map['nom'];
    return super.fromMap(map);
  }

  static CategorieContribuable convertFromMap(Map<String, dynamic> map){
    CategorieContribuable categorieContribuable = CategorieContribuable(nom: null);
    categorieContribuable.fromMap(map);

    return categorieContribuable;
  }

  static CategorieContribuable convertFromDynamicMap(Map<dynamic, dynamic> map) {
    CategorieContribuable categorieContribuable = CategorieContribuable(nom: map['nom']);
    categorieContribuable.fromDynamicMap(map);

    return categorieContribuable;
  }
}