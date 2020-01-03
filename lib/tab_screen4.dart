import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:my_farmer/loginscreen.dart';
import 'package:my_farmer/mainscreen.dart';
import 'package:my_farmer/payment.dart';
import 'package:my_farmer/registrationscreen.dart';
import 'package:my_farmer/splashscreen.dart';
import 'package:my_farmer/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:my_farmer/setting.dart';

import 'SlideRightRoute.dart';

String urlgetuser = "http://lastyeartit.com//myFarmer/php/get_user.php";
String urluploadImage =
    "http://lastyeartit.com//myFarmer/php/upload_imageprofile.php";
String urlupdate = "http://lastyeartit.com//myFarmer/php/update_profile.php";
File _image;
int number = 0;
String _value;

class TabScreen4 extends StatefulWidget {
  //final String email;
  final User user;
  TabScreen4({this.user});

  @override
  _TabScreen4State createState() => _TabScreen4State();
}

class _TabScreen4State extends State<TabScreen4> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "Searching current location...";

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            elevation: 0.1,
            backgroundColor: Colors.green,
            title: Text("My Profile"),
            actions: <Widget>[
            ]),
              drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: Text(widget.user.name),
                accountEmail: Text(widget.user.email),
                currentAccountPicture: GestureDetector(
                    child: Container(
                                    width: 150.0,
                                    height: 150.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white),
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: new NetworkImage(
                                                "http://lastyeartit.com//myFarmer/profile/${widget.user.email}.jpg?dummy=${(number)}'"
                                                )
                                                )
                                                )
                                                ),
                ),
                decoration: new BoxDecoration(color: Colors.green),
              ),

              // body

              InkWell(
                onTap: () => _homePage(
                        widget.user.name,
                        widget.user.email,
                        widget.user.phone,
                        widget.user.credit,
                        widget.user.datereg,
                      ),     
                child: ListTile(
                  title: Text('Home Page'),
                  leading: Icon(Icons.home),
                ),
              ),

              Divider(),

              InkWell(
                onTap: () => _settings(
                        widget.user.name,
                        widget.user.email,
                        widget.user.phone,
                        widget.user.credit,
                        widget.user.datereg,
                      ), 
                child: ListTile(
                  title: Text('Settings'),
                  leading: Icon(Icons.settings),
                ),
              ),

              InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text('About'),
                  leading: Icon(
                    Icons.help,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: ListView.builder(

              //Step 6: Count the data
              itemCount: 5,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Stack(children: <Widget>[
                          Image.asset(
                            "assets/images/background.jpg",
                            width: 2000,
                            height: 210,
                            fit: BoxFit.fitWidth,
                          ),
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: 15,
                              ),
                              Center(
                                child: Container(
                                  padding: EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                      color: Colors.black38,
                                      borderRadius: BorderRadius.circular(15.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0.0, 15.0),
                                          blurRadius: 15.0,
                                        ),
                                        BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0.0, -10.0),
                                          blurRadius: 10.0,
                                        ),
                                      ]),
                                  child: Text("MyFarmer",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                //onTap: _takePicture,
                                 onTap: _choose,
                                child: Container(
                                    width: 150.0,
                                    height: 150.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white),
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: new NetworkImage(
                                                "http://lastyeartit.com//myFarmer/profile/${widget.user.email}.jpg?dummy=${(number)}'"
                                                )
                                                )
                                                )
                                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                child: Text(
                                  widget.user.name?.toUpperCase() ??
                                      'Not register',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                              ),
                              Container(
                                child: Text(
                                  widget.user.email,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.phone_android,
                                      ),
                                      Text(widget.user.phone ??
                                          'not registered', style: TextStyle(fontSize:16),),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.credit_card,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        child: Text("You have " +
                                                widget.user.credit +
                                                " Credit" ??
                                            "You have 0 Credit", style: TextStyle(fontSize:16),),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: Text(_currentAddress, style: TextStyle(fontSize:16),),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),

                       Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: _registerAccount, 
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(" Register", style: TextStyle(fontSize:18,fontWeight: FontWeight.bold,color: Colors.blue),), 
                                ],
                              ), 
                                          Icon(Icons.keyboard_arrow_right,color: Colors.blue),              
                          ],
                        ),
                      ),
                    ),
                  ), 
                ),

                 Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: _gotologinPage, 
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(" Log in", style: TextStyle(fontSize:18,fontWeight: FontWeight.bold,color: Colors.blue),), 
                                ],
                              ), 
                                          Icon(Icons.keyboard_arrow_right,color: Colors.blue),              
                          ],
                        ),
                      ),
                    ),
                  ), 
                ),


                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: () => _settings(
                        widget.user.name,
                        widget.user.email,
                        widget.user.phone,
                        widget.user.credit,
                        widget.user.datereg,
                      ), 
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon( Icons.settings),
                                  Text("  Settings", style: TextStyle(fontSize:18,fontWeight: FontWeight.bold),), 
                                ],
                              ), 
                                          Icon(Icons.keyboard_arrow_right,),              
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox( height: 40,),

                 Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: _gotologout, 
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon( Icons.exit_to_app,color: Colors.red,),
                                  Text(" Log out", style: TextStyle(fontSize:18,fontWeight: FontWeight.bold,color: Colors.red,),), 
                                ],
                              ), 
                                          Icon(Icons.keyboard_arrow_right,color: Colors.red,),              
                          ],
                        ),
                      ),
                    ),
                  ), 
                ),
                            ],
                          ),
                        ]),
                      ],
                    ),
                  );
                }
              }),
            );
    }


 void _settings(
   String name, email, phone, credit, datereg) {
      if (widget.user.email == "user@noregister") {
      Toast.show("Not Allowed. Please register an account.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }else{
     User user = new User(
       name: name,
       email: email,
       phone: phone,
       credit: credit);
       
      Navigator.push(context,
        SlideRightRoute(page: Settings(user: widget.user)));}
  }

  
    void _homePage(String name, email, phone, credit, datereg){
      User user = new User(
       name: name,
       email: email,
       phone: phone,
       credit: credit);
    
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(user: user)));
        }
  
  
 
  void _choose() async {
     if (widget.user.email == "user@noregister") {
      Toast.show("Not Allowed. Please register an account.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }else{
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 180,
            child: Container(
              child: _buildBottomNavigationMenu(),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });}
  }

  Column _buildBottomNavigationMenu() {
    
    return Column(
      children: <Widget>[
        ListTile(
            leading: Icon(Icons.people),
            title: Text('View profile picture'),
            onTap: () async {
              Navigator.pop(context);
              Hero(
                tag: 'Profile Picture',
                child: Image.asset('http://lastyeartit.com//myFarmer/profile/${widget.user.email}.jpg?dummy=${(number)}'),
              );

              Navigator.push(context, MaterialPageRoute(builder: (context)=>
              DetailScreen(user:widget.user)));
              setState(() {});
            }),

        ListTile(
            leading: Icon(Icons.camera_enhance),
            title: Text('Take profile picture'),
            onTap: () async {
            if (widget.user.name == "not register") {
            Toast.show("Not allowed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            return;
            }
            String base64Image;
            try{
              Navigator.of(context).pop();
              _image = await ImagePicker.pickImage( source: ImageSource.camera,
                  imageQuality: 60,
                  maxHeight: 450,
                  maxWidth: double.infinity);
                  base64Image = base64Encode(_image.readAsBytesSync());
                   }catch (e){
                    print(e);
                    }

              http.post(urluploadImage,body:{
                "encoded_string": base64Image,
                "emai":widget.user.email,
            }).then((res){
                print(res.body);
                if(res.body == "success"){
                setState((){
                  number = new Random().nextInt(100);
                  print(number);
                });
              }else{}
            }).catchError((err){
              print(err);
            });
  }),      
        ListTile(
            leading: Icon(Icons.image),
            title: Text('Take from gallery'),
            onTap: () async {
              if (widget.user.name =="not register"){
                Toast.show("Not allowed", context,
                duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
                return;
              }
              String base64Image;
              try{
                Navigator.of(context).pop();
              _image = await ImagePicker.pickImage(source: ImageSource.gallery,
              imageQuality: 80,
              maxHeight: 450,
              maxWidth:double.infinity);

              base64Image = base64Encode(_image.readAsBytesSync());
              }catch(e){
                print(e);
              }

              http.post(urluploadImage,body:{
                "encoded_string":base64Image,
                "email": widget.user.email,
              }).then((res){
                print(res.body);
                if(res.body == "success"){
                  setState(() {
                    number = new Random().nextInt(100);
                    print(number);
                  });
                }else{}
              }).catchError((err){
                print(err);
              });
            },
              )
      ],
    );
  }

  _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition);
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name},${place.locality}, ${place.postalCode}, ${place.country}";
        //load data from database into list array 'data'
      });
    } catch (e) {
      print(e);
    }
  }

  void _changeName() {
    TextEditingController nameController = TextEditingController();
    // flutter defined function

    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change name for " + widget.user.name + "?"),
          content: new TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                icon: Icon(Icons.person),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (nameController.text.length < 5) {
                  Toast.show(
                      "Name should be more than 5 characters long", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "name": nameController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.user.name = dres[1];
                    });
                    Toast.show("Success", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    Navigator.of(context).pop();
                    return;
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                Toast.show("Failed", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changePassword() {
    TextEditingController passController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change Password for " + widget.user.name),
          content: new TextField(
            controller: passController,
            decoration: InputDecoration(
              labelText: 'New Password',
              icon: Icon(Icons.lock),
            ),
            obscureText: true,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (passController.text.length < 5) {
                  Toast.show("Password too short", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "password": passController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.user.name = dres[1];
                      if (dres[0] == "success") {
                        Toast.show("Success", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        savepref(passController.text);
                        Navigator.of(context).pop();
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changePhone() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change phone for " + widget.user.name),
          content: new TextField(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'phone',
                icon: Icon(Icons.phone),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (phoneController.text.length < 5) {
                  Toast.show("Please enter correct phone number", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "phone": phoneController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    setState(() {
                      widget.user.phone = dres[3];
                      Toast.show("Success ", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      Navigator.of(context).pop();
                      return;
                    });
                  }
                }).catchError((err) {
                  print(err);
                });
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _registerAccount() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Register new account?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                print(
                  phoneController.text,
                );
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => RegisterScreen()));
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _gotologinPage() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Go to login page?" + widget.user.name),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                print(
                  phoneController.text,
                );
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _gotologout() async {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(widget.user.name+", Log out of MyFarmer?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Log out"),
              onPressed: () async {
                Navigator.of(context).pop();
                print(phoneController.text);
                Navigator.push(context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SplashScreen()));
              },
            ),
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void savepref(String pass) async {
    print('Inside savepref');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pass', pass);
  }

  void _loadPayment() async {
    // flutter defined function
    if (widget.user.name == "not register") {
      Toast.show("Not allowed please register", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Buy Credit?"),
          content: Container(
            height: 100,
            child: DropdownExample(),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();
                var now = new DateTime.now();
                var formatter = new DateFormat('ddMMyyyyhhmmss-');
                String formatted =
                    formatter.format(now) + randomAlphaNumeric(10);
                print(formatted);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                            user: widget.user,
                            orderid: formatted,
                            val: _value)));
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class DropdownExample extends StatefulWidget {
  @override
  _DropdownExampleState createState() {
    return _DropdownExampleState();
  }
}

class _DropdownExampleState extends State<DropdownExample> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        items: [
          DropdownMenuItem<String>(
            child: Text('50 HCredit (RM10)'),
            value: '10',
          ),
          DropdownMenuItem<String>(
            child: Text('100 HCredit (RM20)'),
            value: '20',
          ),
          DropdownMenuItem<String>(
            child: Text('150 HCredit (RM30)'),
            value: '30',
          ),
        ],
        onChanged: (String value) {
          setState(() {
            _value = value;
          });
        },
        hint: Text('Select Credit'),
        value: _value,
      ),
    );
  }
}

class DetailScreen extends StatefulWidget{
  final User user;
  const DetailScreen({Key key, this.user}): super(key:key);
  @override
  _DetailScreenState createState()=> _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        backgroundColor:Colors.green,
        centerTitle: true,
        title: Text('Profile Picture'),
      ),
      body: Container(
        child: Center(
          child: Hero(
            tag: 'Profile Picture',
            child: Image.network("http://lastyeartit.com//myFarmer/profile/${widget.user.email}.jpg?dummy=${(number)}"),
            ),
            ),
            ),
    );

  }
}



