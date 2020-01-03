import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_farmer/goods.dart';
import 'package:my_farmer/goodsdetail.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:my_farmer/setting.dart';
import 'package:my_farmer/tab_screen4.dart';
import 'package:my_farmer/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'SlideRightRoute.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:toast/toast.dart';

int number = 0;
double perpage = 1;

class TabScreen extends StatefulWidget {
  final User user;

  TabScreen({Key key, this.user});

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "Searching current location...";
  List data;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    Widget image_carousel = new Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('assets/images/c1.jpg'),
          AssetImage('assets/images/c2.jpg'),
          AssetImage('assets/images/c3.jpg'),
          AssetImage('assets/images/c4.jpg'),
          AssetImage('assets/images/c5.jpg'),
          AssetImage('assets/images/c6.jpg'),
          AssetImage('assets/images/c7.jpg'),
        ],
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        indicatorBgPadding: 2.0,
      ),
    );

    return Scaffold(
        appBar: new AppBar(
            elevation: 0.1,
            backgroundColor: Colors.green,
            title: Text("Hi, "+widget.user.name),
           ),
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
        body: RefreshIndicator(
          key: refreshKey,
          color: Colors.green,
          onRefresh: () async {
            await refreshList();
          },
          child: ListView.builder(
              //Step 6: Count the data
              itemCount: data == null ? 1 : data.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        image_carousel,
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                          color: Colors.green,
                          child: Center(
                            child: Text("Goods Available Today",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (index == data.length && perpage > 1) {
                  return Container(
                    width: 250,
                    color: Colors.white,
                    child: MaterialButton(
                      child: Text(
                        "Load More",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {},
                    ),
                  );
                }
                index -= 1;
                return Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: () => _onGoodsDetail(
                        data[index]['goodsid'],
                        data[index]['goodsprice'],
                        data[index]['goodsdesc'],
                        data[index]['goodsowner'],
                        data[index]['goodsimage'],
                        data[index]['goodstime'],
                        data[index]['goodstitle'],
                        data[index]['goodslatitude'],
                        data[index]['goodslongitude'],
                        data[index]['goodsrating'],
                        widget.user.email,
                        widget.user.name,
                        widget.user.credit,
                      ),
                      onLongPress: _onGoodsDelete,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                            "http://lastyeartit.com//myFarmer/images/${data[index]['goodsimage']}.jpg")))),
                            Expanded(
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                        data[index]['goodstitle']
                                            .toString()
                                            .toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("RM " + data[index]['goodsprice']),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(data[index]['goodstime']),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ));
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

    void _profile(String name, email, phone, credit, datereg){
      User user = new User(
       name: name,
       email: email,
       phone: phone,
       credit: credit);
    
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => TabScreen4(user: user)));
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
        init(); //load data from database into list array 'data'
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> makeRequest() async {
    String urlLoadGoods = "http://lastyeartit.com//myFarmer/php/load_goods.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Goods");
    pr.show();
    http.post(urlLoadGoods, body: {
      "email": widget.user.email ?? "notavail",
      "latitude": _currentPosition.latitude.toString(),
      "longitude": _currentPosition.longitude.toString(),
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["goods"];
        perpage = (data.length / 10);
        print("data");
        print(data);
        pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  Future init() async {
    this.makeRequest();
    //_getCurrentLocation();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  void _onGoodsDetail(
      String goodsid,
      String goodsprice,
      String goodsdesc,
      String goodsowner,
      String goodsimage,
      String goodstime,
      String goodstitle,
      String goodslatitude,
      String goodslongitude,
      String goodsrating,
      String email,
      String name,
      String credit) {
    Goods goods = new Goods(
        goodsid: goodsid,
        goodstitle: goodstitle,
        goodsowner: goodsowner,
        goodsdes: goodsdesc,
        goodsprice: goodsprice,
        goodstime: goodstime,
        goodsimage: goodsimage,
        goodsworker: null,
        goodslat: goodslatitude,
        goodslon: goodslongitude,
        goodsrating: goodsrating);
    // print(data);

    Navigator.push(context,
        SlideRightRoute(page: GoodsDetail(goods: goods, user: widget.user)));
  }

  void _onGoodsDelete() {
    print("Delete");
  }
}
