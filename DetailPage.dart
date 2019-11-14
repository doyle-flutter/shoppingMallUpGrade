import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shoppingmall/Database/Sharedpreferences.dart';
import 'package:shoppingmall/PriVateFile.dart';
import 'package:shoppingmall/ViewPage/PayPage.dart';
import 'package:shoppingmall/ViewPage/UserPage.dart';
import 'package:http/http.dart' as http;
import 'package:shoppingmall/main.dart';


class DetailPage extends StatefulWidget {
  int indexing;
  LocalDB localDB;
  DetailPage({this.indexing, this.localDB});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with RouteAware{

  moneyMask({int money}){
    String smoney = money.toString();
    if(smoney.length == 4){
      return "${smoney.substring(0,1)},${smoney.substring(1)}";
    }
    if(smoney.length > 4 && smoney.length < 7){
      return "${smoney.substring(0,2)},${smoney.substring(2)}";
    }
    if(smoney.length == 7){
      return "${smoney.substring(0,1)},${smoney.substring(1,4)},${smoney.substring(4)}";
    }
    if(smoney.length == 8){
      return "${smoney.substring(0,2)},${smoney.substring(2,5)},${smoney.substring(5)}";
    }
    return smoney;
  }

  int salesParser({int money, int sales}){
    if(sales==null){
      return money.toInt();
    }
    return (money - (money*(sales/100))).toInt();
  }

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

  detailFetch(int id) async{
    final url = REST_API_ID+id.toString();
    var res = await http.Client().get(url);
    return json.decode(res.body);
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
      appBar: AppBar(
        title: Text("${widget.indexing}번 상품"),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(
                horizontal: 50.0,
              ),
              child: FutureBuilder(
                future: detailFetch(widget.indexing),
                builder: (context, snap){
                  if(!snap.hasData) return CircularProgressIndicator();
                  else if(snap.connectionState.index != 3) return CircularProgressIndicator();
                  return Contents(snap.data);
                },
              )
            ),

          ],
        )
      ),
    );
  }

  Widget Contents(dynamic products){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                height: MediaQuery.of(context).size.height/2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(products['productsImg']),
                      fit: BoxFit.fitHeight
                  ),
                ),
              ),
              products['sales'] == null
                  ? Container()
                  : Positioned(
                top: 5,
                left: 5,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: Colors.red[300],
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Text(
                    "${products['sales']} % 할인",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Text("상품 번호 : ${products['id']} 번"),
        ),
        Container(
          child: Text("상품명 : ${products['productsName']}"),
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 20.0),
              child: Text(
                "금액 : ${moneyMask(money: salesParser(money:products['price'],sales: products['sales']))} 원",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            products['sales'] == null
                ? Container()
                : Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 20.0),
                  child: Text(
                    "${moneyMask(money: products['price'])}원",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: Colors.red[300],
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Text(
                    "${products['sales']} % 할인",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        Container(
          child: Text("재고 : ${products['ea'].toString()} 개"),
        ),
        (widget.localDB.getUserName() == null)
            ? GestureDetector(
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => UserPage(
                    localDB: widget.localDB,
                  )
              )
          ),
          child: Container(
            margin: EdgeInsets.only(top: 20.0),
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: Colors.red[200],
                borderRadius: BorderRadius.circular(20.0)
            ),
            alignment: Alignment.center,
            child: Text(
              "회원 정보 입력 후 이용할 수 있습니다.\n 클릭하면 이동합니다.",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        )
            : Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Container(
                  child: Text("안녕하세요 "+widget.localDB.getUserName()+" 님"),
                ),
                RaisedButton(
                  onPressed: () async{
                    String url = "http://192.168.1.7:3000/products/buy/${widget.indexing}";
                    var re = await http.Client().get(url);
                    var isData = json.decode(re.body);
                    //int.parse(jsonH.result[widget.indexing]['id']) >
                    if(isData[0]['complete']){
                      return Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => Payment(
                                price:salesParser(money:products['price'],sales: products['sales']),
                                userName: widget.localDB.getUserName(),
                                userAddress: widget.localDB.getUserAddress()+widget.localDB.getUserAddress2(),
                                userPhone: widget.localDB.getUserPhone(),
                              )
                          )
                      );
                    }
                    else{
                      return print("재고없음");
                    }
                  },
                  child: Text("구매"),
                ),
              ],
            )
        )
      ],
    );
  }
}
