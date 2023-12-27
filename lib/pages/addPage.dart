import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController _textEditingController = TextEditingController();
  List<String> _list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("할일"),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _textEditingController,
                          ),ElevatedButton(onPressed: () {
                            _list.add(_textEditingController.text);
                            Navigator.pop(context);
                            setState(() {

                            });
                          }, child: Text("확인"))
                        ],
                      ),
                    );
                  },
                );
              },
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ))
        ],
      ),
      body: ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_list[index]),
            trailing: IconButton(onPressed: (){
              _list.removeAt(index);
              setState(() {

              });
            }, icon: Icon(Icons.exposure_minus_1)),
          );
        },
      ),
    );
  }
}
