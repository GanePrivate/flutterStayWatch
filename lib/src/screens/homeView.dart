import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../util/formatText.dart';
import '../screens/loadAnimation.dart';

// 下のメニューバーに関するクラス
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'New! 滞在ウォッチ',
      home: CurrentStay(title: '在室者一覧'),
    );
  }
}

// ステートフルウィジェットの為の前処理？
class CurrentStay extends StatefulWidget {
  const CurrentStay({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<CurrentStay> createState() => _StayLogState();
}

// ↑のやつを継承して実際の処理の中身が書かれたクラス
class _StayLogState extends State<CurrentStay> {
  List items = [];
  bool isLoading = false;

  // Futureで非同期処理
  Future<void> getData() async {
    while (true) {
      // Getクエリの発行と実行
      var response = await http
          .get(Uri.https('go-staywatch.kajilab.tk', '/api/v1/stayers'));

      // レスポンスをjson形式にデコードして取得
      var jsonResponse = jsonDecode(response.body);

      // ステートに登録(画面に反映させる)
      setState(() {
        items = jsonResponse;
        isLoading = true;
      });

      // 5秒スリープ
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  // ステートの初期化
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      // データのロード中はローディングアニメーションを表示
      return createProgressIndicator();
    } else if (items.isEmpty) {
      // 滞在者がいない場合
      return Scaffold(
        appBar: AppBar(title: const Text('滞在者一覧')),
        body: const Scaffold(
          body:
              Center(child: Text('誰もいないみたい', style: TextStyle(fontSize: 32.0))),
        ),
      );
    } else {
      // 滞在者がいる場合
      return Scaffold(
        appBar: AppBar(title: const Text('滞在者一覧')),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(
                      Icons.account_circle,
                      color: Colors.indigoAccent,
                      size: 50,
                    ),
                    title: Text(
                      items[index]['name'],
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(formatStayUserText(items[index]),
                        style: const TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
  }
}
