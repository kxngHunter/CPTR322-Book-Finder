import 'file:///C:/Users/Hunter/AndroidStudioProjects/book_search/lib/models/book.dart';
import 'package:book_search/services/networking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool toggleSearch = false;
  String searchText;
  bool isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: toggleSearch ? Colors.white : Colors.blue,
        leading: toggleSearch
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    toggleSearch = !toggleSearch;
                  });
                },
              )
            : null,
        title: toggleSearch ? null : Text('Book Search'),
        actions: <Widget>[
          Visibility(
            visible: toggleSearch,
            child: Container(
              color: Colors.white,
              child: TextField(
                style: TextStyle(
                  fontSize: 20.0,
                ),
                cursorColor: Colors.grey,
                autofocus: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 5.0),
                ),
                onChanged: (val) {
                  setState(() {
                    searchText = val;
                  });
                },
              ),
              width: MediaQuery.of(context).size.width * 0.7,
            ),
          ),
          IconButton(
              icon: Icon(Icons.search),
              color: toggleSearch ? Colors.grey : Colors.white,
              onPressed: () async {
                // books.clear();
                // showSearch(context: context, delegate: BookSearch());
                if (toggleSearch == false) {
                  setState(() {
                    toggleSearch = !toggleSearch;
                  });
                } else {
                  setState(() {
                    books.clear();
                    isLoading = !isLoading;
                  });
                  bool success = await searchBooks(searchText);
                  print(success.toString());
                  if (success) {
                    setState(() {
                      books.length;
                      toggleSearch = !toggleSearch;
                      isLoading = !isLoading;
                    });
                  } else {
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text(
                          '$searchText was not found. Try another book title.',
                        ),
                        duration: Duration(milliseconds: 3000),
                      ),
                    );
                    setState(() {
                      toggleSearch = !toggleSearch;
                      isLoading = !isLoading;
                    });
                  }
                }
              })
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemCount: books.length,
              itemBuilder: (context, index) {
                if (books.length == 0 || books.isEmpty) {
                  return Container();
                } else {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(books[index].imgUrl),
                    ),
                    title: Text(books[index].title),
                    subtitle: Text(books[index].author),
                    trailing: Text(books[index].publishDate.toString()),
                  );
                }
              }),
    );
  }
}
