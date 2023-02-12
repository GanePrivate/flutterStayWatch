import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../util/formatText.dart';
import '../screens/loadAnimation.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'New! 滞在ウォッチ',
      home: Users(title: '利用者一覧'),
    );
  }
}

class Users extends StatefulWidget {
  const Users({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  List items = [];
  bool isLoading = false;

  // Futureで非同期処理
  Future<void> getData() async {
    // Getクエリの発行と実行
    var response =
        await http.get(Uri.https('go-staywatch.kajilab.tk', '/api/v1/users'));

    // レスポンスをjson形式にデコードして取得
    var jsonResponse = jsonDecode(response.body);

    // ステートに登録(画面に反映させる)
    setState(() {
      items = jsonResponse;
      isLoading = true;
    });
  }

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
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text('利用者一覧')),
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
                    subtitle: Text(formatUserText(items[index]),
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
