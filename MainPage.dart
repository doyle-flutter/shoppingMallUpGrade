import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shoppingmall/Database/Sharedpreferences.dart';
import 'package:shoppingmall/PriVateFile.dart';
import 'package:shoppingmall/ViewPage/DetailPage.dart';
import 'package:shoppingmall/ViewPage/UserPage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shoppingmall/main.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>  with RouteAware{

  fetch() async{
    String url = REST_API_ALL;
    var res = await http.Client().get(url);
    return json.decode(res.body);
  }

  final LocalDB localDB = new LocalDB()..init();
  RefreshController _refreshController = new RefreshController();

  void _onRefresh() async{
    await Future.delayed(Duration(seconds: 1), (){
      setState(() {
        _refreshController.refreshCompleted();
      });
    });

  }
  void _onLoading() async{
    _refreshController.loadComplete();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }
  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    super.didPush();
  }
  @override
  void didPushNext() {
    super.didPushNext();
  }
  @override
  void didPop() {
    super.didPop();
  }
  @override
  void didPopNext() {
    setState(() {});
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: new AppBar(
        title: Text("MainPage1"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserPage(
                    localDB: localDB,
                  )
                )
              );
            },
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              RollingImage(),
              Container(
                child: Text(
                  "-  NEW  -",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0
                  ),
                ),
              ),
              Container(
                height: 500,
                margin: EdgeInsets.only(top: 10.0,bottom: 30.0),
                child: FutureBuilder(
                  future: fetch(),
                  builder: (context, snap){
                    if(snap.hasData && (snap.connectionState.index == 3)){
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: snap.data.length,
                        itemBuilder: (context, int index){
                          return GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    indexing: index,
                                    localDB: localDB,
                                  )
                                )
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.all(10.0),
                              padding: EdgeInsets.only(bottom: 20.0),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    snap.data[index]['productsImg'],
                                  ),
                                  fit: BoxFit.cover,
                                )
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          snap.data[index]['id'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text(
                                          snap.data[index]['productsName'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  snap.data[index]['sales'] == null
                                    ? Container()
                                    : Positioned(
                                      top: 5,
                                      left: 5,
                                      width: 50,
                                      height: 50,
                                      child: Container(
                                        alignment: Alignment.center,
                                        color: Colors.white54,
                                        child: Text("${snap.data[index]['sales'].toString()}%"),
                                      ),
                                    )
                                ],
                              )
                            ),
                          );
                        }
                      );
                    }
                    else{
                      return Container(
                        child: Text("로딩중"),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget RollingImage(){

    List imgSrcs = [
      "https://cdn.pixabay.com/photo/2019/10/20/22/33/road-4564817_960_720.jpg",
      "https://cdn.pixabay.com/photo/2014/09/16/01/19/girl-447701_960_720.jpg"
    ];

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      margin: EdgeInsets.only(
          top: 20.0,
          bottom: 20.0
      ),
      padding: EdgeInsets.only(),
      child: CarouselSlider(
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 4),
          aspectRatio: 16/9,
          height: 200,
          enlargeCenterPage: true,
          initialPage: 0,
          items: imgSrcs.map(
                (e) => Container(
              width: MediaQuery.of(context).size.width*0.8,
              child: Image.network(
                e,
                fit: BoxFit.fitWidth,
              ),
            ),
          ).toList()
      ),
    );
  }
}

