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
          height: 56.0,
          width: 168.0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Submit',
                    style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white, fontSize: 25.0,fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ],
            ),
          ),
          errorWidget: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30.0,
                ),

                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Error',
                    style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white, fontSize: 25.0),
                  ),
                ),
              ],
            ),
          ),
          successWidget: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 30.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Success',
                    style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white, fontSize: 25.0),
                  ),
                )

              ],
            ),
          ),
          onPressed: () => Future.delayed(Duration(seconds: 5),() => ButtonState.success),
        ),
      ),
    );
  }

}
