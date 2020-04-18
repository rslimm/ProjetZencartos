import 'dart:convert';

import 'Employee.dart';

// http://localhost:8080/

class Services{
  static const ROOT = 'http://192.168.43.206/test/employees_actions.php'; //employees_actions
  static const _CREATE_TABLE_ACTION ='CREATE_TABLE';
  static const _GET_ALL_ACTION ='GET_ALL';
  static const _ADD_EMP_ACTION ='ADD_EMP';
  static const _UPDATE_EMP_ACTION ='UPDATE_EMP';
  static const _DELETE_EMP_ACTION ='DELETE_EMP';








static List<Employee> parseResponse(String responseBody){
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Employee>((json)=> Employee.fromJson(json)).toList();
}







}