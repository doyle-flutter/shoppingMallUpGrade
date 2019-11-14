import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shoppingmall/Database/Sharedpreferences.dart';
import 'package:shoppingmall/Database/resion.dart';

class UserPage extends StatefulWidget {

  LocalDB localDB;
  UserPage({this.localDB});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {


  GlobalKey<FormBuilderState> _fbkey = GlobalKey<FormBuilderState>();

  submit(){
    _fbkey.currentState.save();

    print(_fbkey.currentState.value.toString() + ":: 전체 저장 데이터");
    print("이름 : "+_fbkey.currentState.fields['userName'].currentState.value);
    print("주소 : "+_fbkey.currentState.fields['userAddress'].currentState.value);
    print("주소 : "+_fbkey.currentState.fields['userAddress2'].currentState.value);

    if(!_fbkey.currentState.validate()){
      print("검사오나료");
      print(!_fbkey.currentState.validate());
      return null;
    }
    try{
      widget.localDB.saveUserName(_fbkey.currentState.fields['userName'].currentState.value);
      widget.localDB.saveUserPhone(_fbkey.currentState.fields['userPhone'].currentState.value);
      widget.localDB.saveUserAddress(_fbkey.currentState.fields['userAddress'].currentState.value);
      widget.localDB.saveUserAddress2(_fbkey.currentState.fields['userAddress2'].currentState.value);

    }
    catch(e){
      throw "에러";
    }
    return Navigator.of(context).pop();
  }

  List<String> getSuggestion(String query) {
    if (query.isEmpty) {
      return [];
    }

    List<String> matches = [];
    final regionNames = regions.map((region) {
      return region['regionName'];
    }).toList();

    matches.addAll(regionNames);

    matches.retainWhere((s) => s.contains(query));
    return matches;
  }

  bool _checkRegionName(String regionName) {
    final foundRegion = regions.firstWhere((region) {
      return region['regionName'] == regionName;
    }, orElse: () => null);

    return foundRegion == null ? false : true;
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: Text("UserPage"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FormBuilder(
              key: _fbkey,
              child: Column(
                children: <Widget>[
                  userNameField(key: "userName"),
                  Container(
                    padding:EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                    child: FormBuilderTextField(
                      attribute: 'userPhone',
                      initialValue: widget.localDB.getUserPhone()??null,
                      decoration: InputDecoration(
                          labelText: '연락처(핸드폰)',
                          labelStyle: TextStyle(
                            fontSize: 20.0
                          ),
                          border: OutlineInputBorder(),
                          hintMaxLines: 1
                      ),
                      maxLines: 1,
                      validators: [
                        FormBuilderValidators.required(
                          errorText: '핸드폰 번호는 필수 입니다.',
                        ),
                        FormBuilderValidators.numeric(
                          errorText: "숫자만 입력해주세요."
                        ),
                        (val) {
                          if(
                            _fbkey.currentState.fields['userPhone'].currentState.value.toString().length < 10
                            || _fbkey.currentState.fields['userPhone'].currentState.value.toString().length > 11
                            ){
                            return "10~11자리의 번호를 입력해주세요";
                          }
                          return null;
                        }
                      ],
                    ),
                  ),
                  Container(
                    padding:EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                    child: FormBuilderTypeAhead(
                      attribute: 'userAddress',
                      decoration: InputDecoration(
                        labelText: '시군구',
                        hintText: '시군구를 입력하면 자동 완성됩니다',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: widget.localDB.getUserAddress()??null,
                      validators: [
                        FormBuilderValidators.required(
                          errorText: '시군구는 필수입니다',
                        ),
                        (val) {
                          if (!_checkRegionName(val)) {
                            return '잘못된 지역 이름입니다';
                          }
                          return null;
                        }
                      ],
                      suggestionsCallback: (pattern) {
                        print(pattern);
                        return getSuggestion(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding:EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                    child: FormBuilderTextField(
                      attribute: 'userAddress2',
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: '나머지 주소',
                        hintText: '동/번지/호수 등 나머지 주소를 입력해주세요',
                        border: OutlineInputBorder(),
                        hintMaxLines: 1
                      ),
                      initialValue: widget.localDB.getUserAddress2()??null,
                      validators: [
                        FormBuilderValidators.required(
                          errorText: '필수입니다',
                        ),
                        (val) {
                          return null;
                        }
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        child: RaisedButton(
                          onPressed: () => this.submit(),
                          child: Text(widget.localDB.getUserName() ==null?"저장":"수정"),
                        ),
                      ),
                      Container(
                        child: RaisedButton(
                          onPressed: (){
                            widget.localDB.removeAll();
                            Navigator.of(context).pop();
                          },
                          child: Text("전체삭제"),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget userNameField({String key}){
    return Container(
      padding:EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
      child: FormBuilderTextField(
        attribute: key,
        initialValue: widget.localDB.getUserName()??null,
        decoration: InputDecoration(
            labelText: '이름(수취인 실명)',
            labelStyle: TextStyle(
                fontSize: 20.0
            ),
            border: OutlineInputBorder(),
            hintMaxLines: 1
        ),
        maxLines: 1,
        validators: [
          FormBuilderValidators.required(
            errorText: '이름은 필수입니다',
          ),
          (val) {
            final sd = _fbkey.currentState.fields['userName'].currentState.value;
            print(sd);
            return null;
          }
        ],
      ),
    );
  }
}
