import 'package:flutter/material.dart';
import 'package:shoppingmall/ViewPage/MainPage.dart';


final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() => runApp(
  MaterialApp(
    home: MyApp(),
    navigatorObservers: <NavigatorObserver>[routeObserver],
  ),
);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((_){
      return Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainPage()
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "SHOP",
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold
            ),
          ),
          Image.network(
            "https://cdn.pixabay.com/photo/2016/10/10/14/13/dog-1728494_960_720.png",
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
