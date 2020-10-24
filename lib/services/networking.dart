import 'file:///C:/Users/Hunter/AndroidStudioProjects/book_search/lib/models/book.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const url = "https://www.googleapis.com/books/v1/volumes?q=";

Future searchBooks(String searchText) async {
  http.Response response = await http.get('$url$searchText');
  if (response.statusCode == 200) {
    String data = response.body;
    var decodedData = jsonDecode(data);
    List items = decodedData['items'];
    if (items?.isEmpty ?? true) {
      print('empty');
      return false;
    } else {
      for (int x = 0; x < items.length; x++) {
        var item = items[x]['volumeInfo'];
        Book book = Book();
        book.title = item['title'];
        book.author = item['authors'][0];
        book.imgUrl = item['imageLinks']['thumbnail'];
        book.publishDate = item['publishedDate'];
        print(book);
        books.add(book);
      }
      return true;
    }
  } else {
    print(response.statusCode);
  }
}
