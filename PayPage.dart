import 'package:flutter/material.dart';

/* 아임포트 결제 모듈을 불러옵니다. */
import 'package:iamport_flutter/iamport_payment.dart';
/* 아임포트 결제 데이터 모델을 불러옵니다. */
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:shoppingmall/PriVateFile.dart';
import 'package:shoppingmall/main.dart';

class Payment extends StatelessWidget {
  String userName;
  String userAddress;
  String userPhone;
  int price;

  Payment({this.userName,this.userAddress,this.userPhone,this.price});

  @override
  Widget build(BuildContext context) {
    return IamportPayment(
      appBar: new AppBar(
        title: new Text('쇼핑몰앱-카카오페이'),
      ),
      initialChild: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20.0)),
              ),
            ],
          ),
        ),
      ),
      /* [필수입력] 가맹점 식별코드 */
      userCode: PAY_CODE,
      /* [필수입력] 결제 데이터 */
      data: PaymentData.fromJson({
        'pg': 'html5_inicis',                                          // PG사
        'payMethod': 'card',                                           // 결제수단
        'name': '아임포트 결제데이터 분석',                                  // 주문명
        'merchantUid': 'mid_${DateTime.now().millisecondsSinceEpoch}', // 주문번호
        'amount': price,                                             // 결제금액
        'buyerName': this.userName.toString(),                                           // 구매자 이름
        'buyerTel': '01012345678',                                     // 구매자 연락처
        'buyerEmail': 'example@naver.com',                             // 구매자 이메일
        'buyerAddr': '서울시 강남구 신사동 661-16',                         // 구매자 주소
        'buyerPostcode': '06018',                                      // 구매자 우편번호
        'appScheme': 'example',                                        // 앱 URL scheme
      }),
      /* [필수입력] 콜백 함수 */
      callback: (Map<String, String> result) {
        Navigator.of(context).pop();
      },
    );
  }
}