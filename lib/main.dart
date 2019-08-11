import 'package:flutter/material.dart';
import 'progress_button/progress_button.dart';

void main() => runApp(LibraryApp());

class LibraryApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MainPage(),
      ),
    );
  }

}

class MainPage extends StatefulWidget {

  @override
  _MainPageState createState() => _MainPageState();

}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Library App'),
      ),
      body: Center(
        child: ProgressButton(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
            child: Text('Submit',style: Theme.of(context).textTheme.title.copyWith(color: Colors.white,fontSize: 20.0),),
          ),
          onPressed: () => Future.delayed(Duration(seconds: 5),() => ButtonState.success),
        ),
      ),
    );
  }

}
