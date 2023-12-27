import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController _textEditingController = TextEditingController();
  List<Todo> _list = [];

  @override
  void initState() {
    super.initState();
    // 화면이 열리면 반드시 이곳을 지나감.
    init();
  }

  Future<void> init() async {
    // 로컬에서 리스트 값을 획득
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String backup = prefs.getString("list") ?? "";

    // [{}] 형태의 값을 획득
    List<dynamic> listBackup = jsonDecode(backup);
    for(dynamic row in listBackup){
      _list.add(Todo.fromJson(row));
    }

    // 화면 리프레쉬
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double dialogWidth = width * 0.5;
    return Scaffold(
      appBar: AppBar(
        title: Text("할일"),
        actions: [
          IconButton(
              onPressed: () {
                // 입력란을 리셋
                // _textEditingController.clear();
                _textEditingController.text = "";

                // 다이얼로그를 표시
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Container(
                        width: dialogWidth,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("할일 입력"),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextField(
                                controller: _textEditingController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      // 리스트에 입력란의 값과 현재 날짜 입력
                                      _list.add(Todo(
                                          _textEditingController.text,
                                          DateTime.now().toString()));
                                      // 다이얼로그 닫기
                                      Navigator.pop(context);

                                      // 로컬에 리스트를 저장하기
                                      final SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setString(
                                          'list', jsonEncode(_list));

                                      // 화면을 리프레쉬
                                      setState(() {});
                                    },
                                    child: Text("확인")),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
      body: ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_list[index].contents),
            subtitle: Text(_list[index].date),
            trailing: IconButton(
                onPressed: () async {
                  // 리스트에 해당 위치의 TODO를 삭제
                  _list.removeAt(index);

                  // 로컬에 리스트를 저장하기
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString('list', jsonEncode(_list));

                  // 화면을 리프레쉬
                  setState(() {});
                },
                icon: Icon(Icons.remove)),
          );
        },
      ),
    );
  }
}
