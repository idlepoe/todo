class Todo {
  String contents;
  String date;

  Todo(this.contents, this.date);

  Map<String, dynamic> toJson() {
    return {
      "contents": contents,
      "date": date,
    };
  }

  Todo.fromJson(Map<String, dynamic> data)
      : contents = data["contents"],
        date = data["date"];
}
