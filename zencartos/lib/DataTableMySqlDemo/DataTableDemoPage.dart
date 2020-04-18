import 'package:flutter/material.dart';
import 'Employee.dart';



class DataTableDemo extends StatefulWidget {
  DataTableDemo() : super();
  final String title = 'Slimm Data Table';

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<DataTableDemo> {
  List<Employee> _employees;
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _firstNameController; // controller for the first Name TextField we are going to create
  TextEditingController _lastNameController; // controller for the last Name TextField we are going to create
  Employee _selectedEmployee;

  bool _isUpdating;
  String _titleProgress;

  @override
  void initState(){
    super.initState();
    _employees = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // Key to get the context to show a Snackbar
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
  }

  // Method to update title in the AppBar Title
  _showProgress(String message){
    setState(() {
      _titleProgress = message;
    });
  }

  _showSnackBar(context, message){
    _scaffoldKey.currentState.showSnackBar(SnackBar
      (content: Text(message),
    ),
    );
  }

  // issue here



  _addEmployee(){
    //
  }

  _getEmployees(){
    
    //
  }

  _updateEmployee(){
    //
  }

  _deleteEmployee(){
    //
  }

  // Method to clear TextField values
  _clearValues(){
    _firstNameController.text ='';
    _lastNameController.text ='';
  }

  // here's my UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress), // we show the progress in the title...
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
               
              },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (){
              _getEmployees();
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _firstNameController,
                decoration: InputDecoration.collapsed(
                    hintText: 'First Name'
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _lastNameController,
                decoration: InputDecoration.collapsed(
                    hintText: 'Last Name'
                ),
              ),
            ),
            // add an update button and a cancel button
            // show these buttons only updating an employee
            _isUpdating?
            Row(
              children: <Widget>[
                OutlineButton(
                  child: Text('UPDATE'),
                  onPressed: (){
                    _updateEmployee();
                  },
                ),
                OutlineButton(
                  child: Text('CANCEL'),
                  onPressed: (){
                    setState(() {
                      _isUpdating = false;
                    });
                    _clearValues();
                  },
                ),
              ],
            )
                :Container(),
          ],
        ),
      ),
    );
  }
}
