import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  title: "Simple interest calculator app",
  theme: ThemeData(
    primaryColor: Colors.indigo,
    accentColor: Colors.indigoAccent,
  ),
  home: Home(),
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _formKey = GlobalKey<FormState>();

  List<String> _currency= ['Rupees', 'Dollar', 'Pounds', 'Others'];
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  String _selected;
  TextEditingController principalControlled = TextEditingController();
  TextEditingController interestControlled = TextEditingController();
  TextEditingController termControlled = TextEditingController();
  var displayResult = '';
  var _cardvisible = true;
  @override
  void initState(){
    _dropdownMenuItems = buildDropdownMenuItems(_currency);
    _selected =_dropdownMenuItems[0].value;
    displayResult = '';
    super.initState();
  }
  List<DropdownMenuItem<String>> buildDropdownMenuItems(List currency){
    List<DropdownMenuItem<String>> items = List();
    for (String curr in currency) {
      items.add(DropdownMenuItem(
        value: curr,
        child: Text(curr),
      )
      );
    }
    return items;
  }
  onChangeDropdownItem(String selected){
    setState(() {
      _selected = selected;
    });
  }
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Simple Interest Calculator'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Stack(
              children: <Widget>[
                ListView(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.number,
                    style: textStyle,
                    controller: principalControlled,
                    validator: (String value){
                      if(value.isEmpty){
                        return 'Enter principal amount';
                      }
                      else if(value.contains(RegExp('[^0-9].[^0-9]'))){
                        return 'Enter only numeric values';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Principal",
                      hintText: 'Enter principal amount eg:12000',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                      )
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    style: textStyle,
                    validator: (String value){
                      if(value.isEmpty){
                        return 'Enter interest';
                      }
                      else if(value.contains(RegExp('[^0-9].[^0-9]'))){
                        return 'Enter only numeric values';
                      }
                      return null;
                    },
                    controller: interestControlled,
                    decoration: InputDecoration(
                        labelText: "Rate of interest",
                        hintText: 'In %',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          style: textStyle,
                          validator: (String value){
                            if(value.isEmpty){
                              return 'Enter term period';
                            }
                            else if(value.contains(RegExp('[^0-9].[^0-9]'))){
                              return 'Enter only numeric values';
                            }
                            return null;
                          },
                          controller: termControlled,
                          decoration: InputDecoration(
                              labelText: "Term",
                              hintText: 'In years',
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)
                              )
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0,),
                      Container(
                        width: 142.0,
                        child: DropdownButton(
                          value: _selected,
                          items: _dropdownMenuItems,
                          onChanged: onChangeDropdownItem,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 50.0,
                          child: RaisedButton(
                            child: Text(
                              'Calculate',
                              style: TextStyle(
                                fontSize: 24.0
                              )
                            ),
                            color: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            onPressed: (){
                              setState(() {
                                if(_formKey.currentState.validate()) {
                                  displayResult = _calculateTotal();
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0,),
                      Expanded(
                        child: Container(
                          height: 50.0,
                          child: RaisedButton(
                            child: Text(
                              'Reset',
                              style: TextStyle(
                                  fontSize: 24.0
                              )
                            ),
                            color: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            onPressed: (){
                              setState(() {
                                _reset();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      displayResult,
                      style: TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                  ],
                ),
              Visibility(
                visible: _cardvisible,
                child: Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: Card(
                    child: Container(
                      width: 400.0,
                      child: ListTile(
                        leading: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 42.0,
                        ),
                        title: Text('Developed By Souhardhya Paul'),
                        subtitle: Text('Show some love by visiting his website'),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.cancel,
                            size: 40.0,
                            color: Colors.grey[600],
                          ),
                          onPressed: (){
                            setState(() {
                              _cardvisible = false;
                            });
                          },
                        ),
                        onTap: _launchURL,
                      ),
                    ),
                  ),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  String _calculateTotal (){
    double principal = double.parse(principalControlled.text);
    double interest = double.parse(interestControlled.text);
    double term = double.parse(termControlled.text);
    double total = principal + (principal * interest * term) / 100;
    String result = 'After $term years with principal amount of $principal and interest of $interest will cost you to pay $total $_selected';
    return result;
  }
  void _reset (){
    principalControlled.text = '';
    interestControlled.text = '';
    termControlled.text = '';
    _selected =_dropdownMenuItems[0].value;
    displayResult = '';
  }
  _launchURL() async {
    const url = 'https://souhardhyapaul.tk';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}