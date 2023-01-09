import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login/domain/network_test.dart';

class MyView extends StatefulWidget {
  const MyView({super.key});

  @override
  State<MyView> createState() => _MyViewState();
}

class _MyViewState extends State<MyView> {
  //사용할 변수 미리 선언
  late String userName = '';
  late String userEmail = '';

  @override
  void initState() {
    super.initState();
    //state 진입시 api 데이터 파싱.
    getTestData();
  }

  getTestData() async {
    //url을 받아 데이터를 파싱하는 network 메소드 사용. 미리 만들어둠.
    //mysql db에서 유저 데이터를 받아오는 express api 호출
    Network network = Network('http://localhost:3000/get');

    var jsonData = await network.getJsonData();
    userName = await jsonData[0]['user_name'];
    userEmail = await jsonData[0]['user_email'];
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('청소년톡talk',
              style: TextStyle(color: Colors.black, fontSize: 20)),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context); //뒤로가기
              },
              color: Colors.purple,
              icon: Icon(Icons.arrow_back)),
        ),
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${userName}'),
                Text('${userEmail}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
