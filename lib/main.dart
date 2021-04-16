import 'package:flutter/material.dart';
import 'package:flutter_arc_progress/arc_progress_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _marginValue = 50;
  double _canvasSize = 300;
  double _progress = 90;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width,
            child: Center(
              child: Container(
                width: _canvasSize,
                height: _canvasSize,
                alignment: Alignment.center,
                color: Colors.grey[200],
                margin:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: ArcProgressBar(
                  progress: _progress,
                  marginValue: _marginValue,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 16),
                child: Text('调整进度'),
                constraints: BoxConstraints(minWidth: 100),
              ),
              Expanded(
                child: Slider(
                    value: _progress,
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        _progress = value;
                      });
                    }),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 16),
                child: Text('仪表盘间距'),
                constraints: BoxConstraints(minWidth: 100),
              ),
              Expanded(
                child: Slider(
                    value: _marginValue,
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        _marginValue = value;
                      });
                    }),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 16),
                child: Text('画布大小'),
                constraints: BoxConstraints(minWidth: 100),
              ),
              Expanded(
                child: Slider(
                    value: _canvasSize,
                    min: 150,
                    max: MediaQuery.of(context).size.width,
                    onChanged: (value) {
                      setState(() {
                        _canvasSize = value;
                      });
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
