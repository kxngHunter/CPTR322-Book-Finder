class Book {
  String title;
  String author;
  var publishDate;
  String imgUrl;

  String toString() => '$title $author $publishDate $imgUrl';
}

List<Book> books = [];
