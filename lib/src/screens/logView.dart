import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../util/formatText.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'New! 滞在ウォッチ',
      home: StayLog(title: '滞在者履歴'),
    );
  }
}

class StayLog extends StatefulWidget {
  const StayLog({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StayLog> createState() => _StayLogState();
}


class _StayLogState extends State<StayLog> {
  List items = [];

  // Futureで非同期処理
  Future<void> getData() async {

    while(true) {
      // Getクエリの発行と実行
      var response = await http.get(Uri.https(
          'go-staywatch.kajilab.tk',
          '/room/v1/log',
          {'page': '1'}));

      // レスポンスをjson形式にデコードして取得
      var jsonResponse = jsonDecode(response.body);

      // ステートに登録(画面に反映させる)
      setState(() {
        items = jsonResponse;
      });

      // 5秒スリープ
      await Future.delayed(const Duration(seconds: 5));
    }

  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('滞在者履歴')),
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
                  title: Text(items[index]['name'],
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                      '${formatPeriodText(items[index])}\n${items[index]['room']}',
                      style: const TextStyle(fontSize: 20)
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}