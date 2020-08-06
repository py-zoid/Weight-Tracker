import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/bloc/selected_weight.dart';
import 'package:weight_tracker/widgets/loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/repository/database.dart';

class UserDataParent extends StatefulWidget {
  final FirebaseUser _user;
  final DatabaseRepository _databaseRepository;

  UserDataParent(
      {Key key,
      @required FirebaseUser user,
      @required DatabaseRepository databaseRepository})
      : assert(databaseRepository != null),
        _user = user,
        _databaseRepository = databaseRepository,
        super(key: key);

  @override
  _UserDataParentState createState() => _UserDataParentState();
}

class _UserDataParentState extends State<UserDataParent> {
  double width;
  double height;
  int _currentIndex = 0;
  bool hasWeight = false;
  String _currentDoc;
  String _currentSelectedWeight;
  DateFormat dateFormat = DateFormat("d MMM yy");
  TextEditingController _weightController = TextEditingController();
  TextEditingController _editController = TextEditingController();
  SelectedWeightBloc _selectedWeightBloc = SelectedWeightBloc();

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        height: height,
        child: Stack(
          children: [
            currentWeight(),
            enterWeight(),
            weightsList(),
            editWeight(),
          ],
        ),
      ),
    );
  }

  Widget currentWeight() {
    return Positioned(
      width: width / 4,
      height: height / 4,
      left: width / 5,
      top: width / 7,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.orange,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Center(
            child: StreamBuilder(
              stream:
                  widget._databaseRepository.getCurrentWeight(widget._user.uid),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  var weight = snapshot.data['weight'];
                  return weight != null
                      ? Text(
                          '$weight kg',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        )
                      : Text('');
                }
                return Text('');
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget enterWeight() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
          color: Colors.deepOrange[100],
          borderRadius: BorderRadius.circular(30.0),
        ),
        width: width / 2,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _weightController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d{0,3}(\.\d{0,2})?'))
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                  hintText: 'Add weight',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.add,
                size: 20.0,
              ),
              onPressed: () {
                print('adding weight');
                widget._databaseRepository.addWeight(
                    widget._user.uid, double.parse(_weightController.text));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget editWeight() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: height * 0.18, left: width * 0.10),
        width: width * 0.25,
        height: height * 0.14,
        decoration: BoxDecoration(
          color: Colors.deepOrange[100],
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StreamBuilder(
                stream: _selectedWeightBloc.textStream,
                builder: (context, snapshot) {
                  _editController.text = snapshot.data;
                  return TextFormField(
                    controller: _editController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d{0,3}(\.\d{0,2})?'))
                    ],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24.0),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                      hintStyle: TextStyle(fontSize: 14.0),
//                      border: InputBorder.none,
                    ),
                  );
                }),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: InkWell(
                  onTap: () async {
                    if (_currentDoc != null &&
                        _currentSelectedWeight != _editController.text) {
                      await widget._databaseRepository.updateWeight(
                          widget._user.uid,
                          double.parse(_editController.text),
                          _currentDoc);
                      await widget._databaseRepository.updateCurrentWeight(
                          widget._user.uid, double.parse(_editController.text));
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit),
                      Text('Edit'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget weightsList() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.only(bottom: height * 0.10, right: width * 0.18),
        height: height * 0.3,
        width: width * 0.25,
        child: StreamBuilder(
          stream: widget._databaseRepository.getWeights(widget._user.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data != null && snapshot.data.documents.length > 0) {
              List documents = snapshot.data.documents.toList();
              if (!hasWeight) {
                _selectedWeightBloc
                    .updateText(documents[0]['weight'].toString());
                _currentDoc = documents[0].documentID;
              }
              hasWeight = true;
              return ScrollConfiguration(
                behavior: M(),
                child: ListWheelScrollView.useDelegate(
                  itemExtent: height * 0.1,
                  onSelectedItemChanged: (value) {
                      _currentIndex = value;
                      _selectedWeightBloc
                          .updateText(documents[value]['weight'].toString());
                      _currentDoc = documents[value].documentID;
                  },
                  renderChildrenOutsideViewport: false,
                  childDelegate: ListWheelChildBuilderDelegate(
                      childCount: documents.length,
                      builder: (BuildContext context, int index) {
                        return ListTile(
                          title: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              documents[index]['weight'].toString(),
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: index == _currentIndex
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),
                          ),
                          subtitle: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              dateFormat.format(
                                  documents[index]['timestamp'].toDate()),
                              style: TextStyle(
                                  fontWeight: index == _currentIndex
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),
                          ),
                        );
                      }),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class M extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
