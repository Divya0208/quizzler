import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const url = 'https://opentdb.com/api.php?amount=16&type=boolean';

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int questionNo = 0;

  List<Icon> scorekeeper = [
  ];

  List questionObjects;

  void getData() async {
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      String questionBank = response.body;
      var questions = jsonDecode(questionBank);
      setState(() {
        questionObjects = questions['results'];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                questionNo < 16
                    ? (questionObjects != null
                        ? questionObjects[questionNo]['question']
                        : 'Wait a moment while we load the questions for you.')
                    : 'You have reached the end of game.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                if (questionNo < 16) {
                  bool correctAnswer =
                      questionObjects[questionNo]['correct_answer'] == 'True'
                          ? true
                          : false;
                  if (correctAnswer == true) {
                    setState(() {
                      scorekeeper.add(Icon(
                        Icons.check,
                        color: Colors.green,
                      ));
                      questionNo++;
                    });
                  } else {
                    setState(() {
                      scorekeeper.add(Icon(
                        Icons.close,
                        color: Colors.red,
                      ));
                      questionNo++;
                    });
                  }
                }
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                if (questionNo < 16) {
                  bool correctAnswer =
                      questionObjects[questionNo]['correct_answer'] == 'True'
                          ? true
                          : false;
                  if (correctAnswer == false) {
                    setState(() {
                      scorekeeper.add(Icon(
                        Icons.check,
                        color: Colors.green,
                      ));
                      questionNo++;
                    });
                  } else {
                    setState(() {
                      scorekeeper.add(Icon(
                        Icons.close,
                        color: Colors.red,
                      ));
                      questionNo++;
                    });
                  }
                }
              },
            ),
          ),
        ),
        Row(children: scorekeeper)
      ],
    );
  }
}
