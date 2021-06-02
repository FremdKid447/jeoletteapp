import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

int currentMoney = 100;
String currentChoice;
int currentBet;
String currentRouletteChoice;
List<Question> questionList = [];
List<RouletteNumber> rouletteNumberList = [];
List<String> attributeList = ['Red', 'Black', 'Odd', 'Even'];
int wins = 0;
int losses = 0;

class Question {
  String question;
  String firstAnswer;
  String secondAnswer;
  String thirdAnswer;
  String fourthAnswer;
  String correctAnswer;
  bool isAsked;

  Question(
      {this.question,
      this.firstAnswer,
      this.secondAnswer,
      this.thirdAnswer,
      this.fourthAnswer,
      this.correctAnswer}) {
    isAsked = false;
  }

  // ignore: non_constant_identifier_names
  String get question_ {
    return question;
  }

  // ignore: non_constant_identifier_names
  String get firstAnswer_ {
    return firstAnswer;
  }

  // ignore: non_constant_identifier_names
  String get secondAnswer_ {
    return secondAnswer;
  }

  // ignore: non_constant_identifier_names
  String get thirdAnswer_ {
    return thirdAnswer;
  }

  // ignore: non_constant_identifier_names
  String get fourthAnswer_ {
    return fourthAnswer;
  }

  // ignore: non_constant_identifier_names
  String get correctAnswer_ {
    return correctAnswer;
  }

  // ignore: non_constant_identifier_names
  bool get isAsked_ {
    return isAsked;
  }
}

Question getNextQuestion() {
  Question q;
  do {
    q = questionList[Random().nextInt(questionList.length)];
  } while (q.isAsked == true);

  q.isAsked = true;
  return q;
}

void resetQuestionsAskedStatus() {
  questionList.forEach((item) {
    item.isAsked = false;
  });
}

class RouletteNumber {
  String numberColor;
  String number;

  RouletteNumber({this.numberColor, this.number});

  // ignore: non_constant_identifier_names
  String get numberColor_ {
    return numberColor;
  }

  // ignore: non_constant_identifier_names
  String get number_ {
    return number;
  }
}

void main() {
  runApp(MyApp());
  SystemChrome.setEnabledSystemUIOverlays([]);
}

class MyApp extends StatelessWidget {
  getData() async {
    String data1 = await DefaultAssetBundle.of(myBuildContext)
        .loadString("assets/jeoletteQuestions.json");

    String data2 = await DefaultAssetBundle.of(myBuildContext)
        .loadString("assets/rouletteNumbers.json");

    var jsonData1 = json.decode(data1)['questions'];
    var jsonData2 = json.decode(data2)['numbers'];

    jsonData1.forEach((item) {
      questionList.add(Question(
          question: item['question'],
          firstAnswer: item['firstAnswer'],
          secondAnswer: item['secondAnswer'],
          thirdAnswer: item['thirdAnswer'],
          fourthAnswer: item['fourthAnswer'],
          correctAnswer: item['correctAnswer']));
    });

    jsonData2.forEach((item) {
      String color;
      if (item['numberColor'] == 'Red') {
        color = "FFB71C1C";
      } else if (item['numberColor'] == 'Green') {
        color = "FF00C853";
      } else {
        color = "FF212121";
      }

      rouletteNumberList
          .add(RouletteNumber(numberColor: color, number: item['number']));
    });
  }

  BuildContext myBuildContext;

  @override
  Widget build(BuildContext context) {
    myBuildContext = context;
    getData();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Jeolette'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Jeolette!',
              style: Theme.of(context).textTheme.headline1,
            ),
            TextButton(
                child: Text(
                  'Start',
                  style: Theme.of(context).textTheme.headline4,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return ChoiceScreen();
                    }),
                  );
                }),
            TextButton(
              child: Text(
                'Instructions',
                style: Theme.of(context).textTheme.headline4,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return InstructionsScreen();
                  }),
                );
              },
            ),
            TextButton(
              child: Text(
                'Statistics',
                style: Theme.of(context).textTheme.headline4,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return StatisticsScreen();
                  }),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class StatisticsScreen extends MyApp {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Wins: ' + wins.toString(),
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'Losses: ' + losses.toString(),
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
              child: Text(
                'Back',
                style: Theme.of(context).textTheme.headline4,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}

class ChoiceScreen extends MyApp {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Would you like to answer a trivia question or take your chances with the roulette wheel?',
                style: Theme.of(context).textTheme.headline5,
              ),
              TextButton(
                child: Text(
                  'Trivia Question',
                  style: Theme.of(context).textTheme.headline5,
                ),
                onPressed: () {
                  currentChoice = 'trivia';
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return BetScreen();
                    }),
                  );
                },
              ),
              TextButton(
                child: Text(
                  'Roulette Wheel',
                  style: Theme.of(context).textTheme.headline5,
                ),
                onPressed: () {
                  currentChoice = 'roulette';
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return BetScreen();
                    }),
                  );
                },
              )
            ],
          ),
        ));
  }
}

// ignore: non_constant_identifier_names
void DisplayMessageDialog(
    // ignore: non_constant_identifier_names
    BuildContext context_in,
    String titlemsg,
    String contentmsg) {
  showDialog(
      context: context_in,
      builder: (context) => new AlertDialog(
              title: new Text(titlemsg),
              content: Text(contentmsg),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true)
                        .pop(); // dismisses only the dialog and returns nothing
                  },
                  child: new Text('OK'),
                )
              ]));
}

class BetScreen extends ChoiceScreen {
  final myController = TextEditingController();

  String betQuestion() {
    String _betQuestion;
    if (currentChoice == "trivia") {
      _betQuestion =
          "How much would you like to bet on this question? You currently have " +
              currentMoney.toString() +
              ' dollars.';
    } else if (currentChoice == "roulette") {
      _betQuestion =
          "How much would you like to bet on this round? You currently have " +
              currentMoney.toString() +
              ' dollars.';
    }
    return _betQuestion;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: <Widget>[
              Text(
                betQuestion(),
                style: Theme.of(context).textTheme.headline5,
              ),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter an amount'),
                controller: myController,
              ),
              TextButton(
                child: Text(
                  'Submit',
                  style: Theme.of(context).textTheme.headline5,
                ),
                onPressed: () async {
                  currentBet = int.parse(myController.text);
                  if (currentBet == 0 || currentBet > currentMoney) {
                    {
                      await DisplayMessageDialog(
                          context,
                          'Message',
                          'Your bet has exceeded your current amount. You currently have ' +
                              currentMoney.toString() +
                              ' dollars.');
                    }
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return TrackScreen();
                      }),
                    );
                  }
                },
              )
            ],
          ),
        ));
  }
}

class InstructionsScreen extends MyApp {
  String _instructions =
      "You will be given 100 dollars at the start. You will then choose how much you want to bet and whether you want to take a trivia question or the roulette wheel. If you get the trivia question right, you win money. If the roulette wheel lands on the attribute you have chosen, you win money. If you get the trivia question wrong, you must go to the roulette wheel and hope it lands on a randomly chosen attribute. You end the game by either winning with 1000 dollars or more, or going bankrupt with 0 dollars.";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        children: <Widget>[
          Text(
            _instructions,
            style: Theme.of(context).textTheme.headline5,
          ),
          TextButton(
            child: Text(
              'Back',
              style: Theme.of(context).textTheme.headline5,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      )),
    );
  }
}

class TrackScreen extends BetScreen {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        children: <Widget>[
          Text(
            "You have just bet " +
                currentBet.toString() +
                ". If you win, you will have " +
                (currentMoney + currentBet).toString() +
                ". If you lose, you will have " +
                (currentMoney - currentBet).toString() +
                ".",
            style: Theme.of(context).textTheme.headline5,
          ),
          TextButton(
            child: Text(
              'Next',
              style: Theme.of(context).textTheme.headline5,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  if (currentChoice == "roulette") {
                    return RouletteChoiceScreen();
                  } else {
                    return QuestionScreen();
                  }
                }),
              );
            },
          )
        ],
      )),
    );
  }
}

class RouletteChoiceScreen extends TrackScreen {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        children: <Widget>[
          Text(
            "Which attribute would you like to bet the roulette wheel will land on?",
            style: Theme.of(context).textTheme.headline5,
          ),
          TextButton(
            child: Text(
              'Red',
              style: Theme.of(context).textTheme.headline5,
            ),
            onPressed: () {
              currentRouletteChoice = 'Red';
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return RouletteScreen();
                }),
              );
            },
          ),
          TextButton(
            child: Text(
              'Black',
              style: Theme.of(context).textTheme.headline5,
            ),
            onPressed: () {
              currentRouletteChoice = 'Black';
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return RouletteScreen();
                }),
              );
            },
          ),
          TextButton(
            child: Text(
              'Even',
              style: Theme.of(context).textTheme.headline5,
            ),
            onPressed: () {
              currentRouletteChoice = 'Even';
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return RouletteScreen();
                }),
              );
            },
          ),
          TextButton(
            child: Text(
              'Odd',
              style: Theme.of(context).textTheme.headline5,
            ),
            onPressed: () {
              currentRouletteChoice = 'Odd';
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return RouletteScreen();
                }),
              );
            },
          )
        ],
      )),
    );
  }
}

class RouletteScreen extends RouletteChoiceScreen {
  final selected = StreamController<int>();

  dispose() {
    selected.close();
  }

  @override
  Widget build(BuildContext context) {
    final items = rouletteNumberList;

    String buttontext = "OK";
    int selIndex = 0;
    String color;

    setState() {
      selIndex = Random().nextInt(items.length);
      selected.add(
        selIndex,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Fortune Wheel'),
      ),
      body: GestureDetector(
        onTap: setState(),
        child: Column(
          children: [
            Expanded(
              child: FortuneWheel(
                selected: selected.stream,
                items: [
                  for (var it in items)
                    FortuneItem(
                        child: Text(it.number),
                        style: FortuneItemStyle(
                            color: Color(int.parse(it.numberColor, radix: 16))))
                ],
              ),
            ),
            SizedBox(
                height: 200,
                child: TextButton(
                    child: Text(
                      'Next',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    onPressed: () {
                      if (currentRouletteChoice == 'Red' &&
                          items[selIndex].numberColor == "FFB71C1C") {
                        currentMoney += currentBet;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return WinRouletteScreen();
                          }),
                        );
                      } else if (currentRouletteChoice == 'Black' &&
                          items[selIndex].numberColor == "FF212121") {
                        currentMoney += currentBet;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return WinRouletteScreen();
                          }),
                        );
                      } else if (currentRouletteChoice == 'Even' ||
                          currentRouletteChoice == 'Odd') {
                        int resultVal = 0;
                        if (currentRouletteChoice == 'Even')
                          resultVal = 0;
                        else
                          resultVal = 1;
                        if (int.parse(items[selIndex].number) % 2 ==
                            resultVal) {
                          currentMoney += currentBet;
                          if (currentMoney > 1000) {
                            wins += 1;
                            resetQuestionsAskedStatus();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return WinScreen();
                              }),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return WinRouletteScreen();
                              }),
                            );
                          }
                        } else {
                          currentMoney -= currentBet;
                          if (currentMoney <= 0) {
                            losses += 1;
                            resetQuestionsAskedStatus();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return LoseScreen();
                              }),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return LoseRouletteScreen();
                              }),
                            );
                          }
                        }
                      } else {
                        currentMoney -= currentBet;
                        if (currentMoney <= 0) {
                          losses += 1;
                          resetQuestionsAskedStatus();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return LoseScreen();
                            }),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return LoseRouletteScreen();
                            }),
                          );
                        }
                      }
                    })),
          ],
        ),
      ),
    );
  }
}

class WinRouletteScreen extends RouletteScreen {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.green,
        body: Center(
            child: Column(children: <Widget>[
          Text(
              'The roulette wheel worked in your favor. You currently have ' +
                  currentMoney.toString() +
                  ' dollars.',
              style: Theme.of(context).textTheme.headline4),
          TextButton(
              child: Text(
                'Next',
                style: Theme.of(context).textTheme.headline5,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ChoiceScreen();
                  }),
                );
              })
        ])));
  }
}

class LoseRouletteScreen extends RouletteScreen {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.red,
        body: Center(
            child: Column(children: <Widget>[
          Text(
              'The roulette wheel did not work in your favor. You currently have ' +
                  currentMoney.toString() +
                  ' dollars.',
              style: Theme.of(context).textTheme.headline4),
          TextButton(
              child: Text(
                'Next',
                style: Theme.of(context).textTheme.headline5,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ChoiceScreen();
                  }),
                );
              })
        ])));
  }
}

class QuestionScreen extends TrackScreen {
  Question currentQuestion = getNextQuestion();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        children: <Widget>[
          Text(
            currentQuestion.question_,
            style: Theme.of(context).textTheme.headline5,
          ),
          TextButton(
              child: Text(
                currentQuestion.firstAnswer_,
                style: Theme.of(context).textTheme.headline5,
              ),
              onPressed: () {
                if (currentQuestion.firstAnswer_ ==
                    currentQuestion.correctAnswer_) {
                  currentMoney += currentBet;
                  if (currentMoney >= 1000) {
                    wins += 1;
                    resetQuestionsAskedStatus();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return WinScreen();
                    }));
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return WinQuestionScreen();
                    }));
                  }
                } else if (currentQuestion.firstAnswer_ !=
                    currentQuestion.correctAnswer_) {
                  currentRouletteChoice =
                      attributeList[Random().nextInt(attributeList.length)];
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LoseQuestionScreen();
                  }));
                }
              }),
          TextButton(
              child: Text(
                currentQuestion.secondAnswer_,
                style: Theme.of(context).textTheme.headline5,
              ),
              onPressed: () {
                if (currentQuestion.secondAnswer_ ==
                    currentQuestion.correctAnswer_) {
                  currentMoney += currentBet;
                  if (currentMoney >= 1000) {
                    wins += 1;
                    resetQuestionsAskedStatus();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return WinScreen();
                    }));
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return WinQuestionScreen();
                    }));
                  }
                } else if (currentQuestion.secondAnswer_ !=
                    currentQuestion.correctAnswer_) {
                  currentRouletteChoice =
                      attributeList[Random().nextInt(attributeList.length)];
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LoseQuestionScreen();
                  }));
                }
              }),
          TextButton(
              child: Text(
                currentQuestion.thirdAnswer_,
                style: Theme.of(context).textTheme.headline5,
              ),
              onPressed: () {
                if (currentQuestion.thirdAnswer_ ==
                    currentQuestion.correctAnswer_) {
                  currentMoney += currentBet;
                  if (currentMoney >= 1000) {
                    wins += 1;
                    resetQuestionsAskedStatus();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return WinScreen();
                    }));
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return WinQuestionScreen();
                    }));
                  }
                } else if (currentQuestion.thirdAnswer_ !=
                    currentQuestion.correctAnswer_) {
                  currentRouletteChoice =
                      attributeList[Random().nextInt(attributeList.length)];
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LoseQuestionScreen();
                  }));
                }
              }),
          TextButton(
              child: Text(
                currentQuestion.fourthAnswer_,
                style: Theme.of(context).textTheme.headline5,
              ),
              onPressed: () {
                if (currentQuestion.fourthAnswer_ ==
                    currentQuestion.correctAnswer_) {
                  currentMoney += currentBet;
                  if (currentMoney >= 1000) {
                    wins += 1;
                    resetQuestionsAskedStatus();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return WinScreen();
                    }));
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return WinQuestionScreen();
                    }));
                  }
                } else if (currentQuestion.fourthAnswer_ !=
                    currentQuestion.correctAnswer_) {
                  currentRouletteChoice =
                      attributeList[Random().nextInt(attributeList.length)];
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LoseQuestionScreen();
                  }));
                }
              })
        ],
      )),
    );
  }
}

class WinQuestionScreen extends QuestionScreen {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.green,
        body: Center(
            child: Column(children: <Widget>[
          Text(
              'You got the question right! You currently have ' +
                  currentMoney.toString() +
                  ' dollars.',
              style: Theme.of(context).textTheme.headline4),
          TextButton(
              child: Text(
                'Next',
                style: Theme.of(context).textTheme.headline5,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ChoiceScreen();
                  }),
                );
              })
        ])));
  }
}

class LoseQuestionScreen extends QuestionScreen {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.red,
        body: Center(
            child: Column(children: <Widget>[
          Text(
              'Wrong answer. You will now go to the roulette wheel and hope that it lands on your randomly chosen attribute : ' +
                  currentRouletteChoice,
              style: Theme.of(context).textTheme.headline4),
          TextButton(
              child: Text(
                'Next',
                style: Theme.of(context).textTheme.headline5,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return RouletteScreen();
                  }),
                );
              })
        ])));
  }
}

class WinScreen extends QuestionScreen {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.green,
        body: Center(
            child: Column(children: <Widget>[
          Text(
              'Congratulations! You have won this game with 1000 dollars or more. Click Next to play again.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
          TextButton(
              child: Text(
                'Next',
                style: Theme.of(context).textTheme.headline5,
              ),
              onPressed: () {
                currentMoney = 100;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ChoiceScreen();
                  }),
                );
              }),
          TextButton(
              child: Text(
                'Statistics',
                style: Theme.of(context).textTheme.headline5,
              ),
              onPressed: () {
                currentMoney = 100;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return StatisticsScreen();
                  }),
                );
              })
        ])));
  }
}

class LoseScreen extends RouletteScreen {
  //RouletteScreen {

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.red,
        body: Center(
            child: Column(children: <Widget>[
          Text(
              'The bouncer has kicked you out because you have 0 dollars left. Click Next to play again.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
          TextButton(
              child: Text(
                'Next',
                style: Theme.of(context).textTheme.headline5,
              ),
              onPressed: () {
                currentMoney = 100;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ChoiceScreen();
                  }),
                );
              }),
          TextButton(
              child: Text(
                'Statistics',
                style: Theme.of(context).textTheme.headline5,
              ),
              onPressed: () {
                currentMoney = 100;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return StatisticsScreen();
                  }),
                );
              })
        ])));
  }
}
