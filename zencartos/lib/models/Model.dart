import 'package:meta/meta.dart';


class Model{

  String id;

  DateTime createdAt = new DateTime.now(),
           deletedAt = new DateTime.now();

  Model({@Required('id') this.id, this.createdAt, this.deletedAt});

  Map<String, dynamic> toMap(){
    if(this.createdAt == null) this.createdAt = DateTime.now();

    return {
      'id': this.id,
      'createdAt': {'year': this.createdAt.year, 'month': this.createdAt.month, 'day': this.createdAt.day, 'hour': this.createdAt.hour,
      'minute': this.createdAt.minute, 'second': this.createdAt.second, 'millisecond': this.createdAt.millisecond},
      'deletedAt': this.deletedAt == null ? null: this.deletedAt
    };

  }

  fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    Map<dynamic, dynamic> createdDate = map['createdAt'];
    this.createdAt = new DateTime(createdDate['year'], createdDate['month'], createdDate['day'], createdDate['hour'],
    createdDate['minute'], createdDate['second'], createdDate['millisecond']);
    this.deletedAt = map['deletedAt'] == null  ? null: new DateTime.fromMicrosecondsSinceEpoch(map['deletedAt']);
    }
  fromDynamicMap(Map<dynamic, dynamic> map){
    this.id = map['id'];
    Map<dynamic, dynamic> createdDate = map['createdAt'];
    if(createdDate != null){
      this.createdAt = new DateTime(createdDate['year'], createdDate['month'], createdDate['day'], createdDate['hour'],
      createdDate['minute'], createdDate['second'], createdDate['milisecond']);
      this.deletedAt = map['deletedAt'] == null ? null : new DateTime.fromMicrosecondsSinceEpoch(map['deletedAt']);
    }
  }
}