import 'package:flutter/material.dart';

int finalScore = 0;
int questionNumber = 0;
MultipleAnswerQuiz quiz = MultipleAnswerQuiz('', '', '', '');

class MultipleAnswerQuiz {
  MultipleAnswerQuiz(this.image, this.question, this.options, this.correct);
  String image;
  String question;
  String options;
  String correct;

  List<String> images = [
    'captainamerica',
    'blackpanther',
    'ironman',
    'avengers'
  ];

  List<String> questions = [
    "What is Captain America's real name?",
    '_________ like to chase mice and birds.',
    'Give a _________ a bone and he will find his way home',
    'A nocturnal animal with some really big eyes',
  ];

  List<List<String>> choices = [
    ['Steve Rogers', 'Bucky Rogers', 'Bruce Banner', 'Bruce Wayne'],
    ['Cat', 'Snail', 'Slug', 'Horse'],
    ['Mouse', 'Dog', 'Elephant', 'Donkey'],
    ['Spider', 'Snake', 'Hawk', 'Owl']
  ];

  List<String> correctAnswers = ['Steve Rogers', 'Cat', 'Dog', 'Owl'];
}

class MultiQuiz extends StatefulWidget {
  const MultiQuiz({super.key});

  @override
  State<MultiQuiz> createState() => _MultiQuiz();
}

class _MultiQuiz extends State<MultiQuiz> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              const Padding(padding: EdgeInsets.all(20)),

              Container(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Question ${questionNumber + 1} of '
                      '${quiz.questions.length}',
                      style: const TextStyle(fontSize: 22),
                    ),
                    Text(
                      'Score: $finalScore',
                      style: const TextStyle(fontSize: 22),
                    )
                  ],
                ),
              ),

              //image
              const Padding(padding: EdgeInsets.all(10)),

              SizedBox(
                height: 400,
                child: Image.asset(
                  'images/${quiz.images[questionNumber]}.jpeg',
                ),
              ),

              SizedBox(
                height: 100,
                child: Text(
                  quiz.questions[questionNumber],
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //button 1
                  MaterialButton(
                    minWidth: 120,
                    color: Colors.blueGrey,
                    onPressed: () {
                      if (quiz.choices[questionNumber][0] ==
                          quiz.correctAnswers[questionNumber]) {
                        debugPrint('Correct');
                        finalScore++;
                      } else {
                        debugPrint('Wrong');
                      }
                      updateQuestion();
                    },
                    child: Text(
                      quiz.choices[questionNumber][0],
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),

                  //button 2
                  MaterialButton(
                    minWidth: 120,
                    color: Colors.blueGrey,
                    onPressed: () {
                      if (quiz.choices[questionNumber][1] ==
                          quiz.correctAnswers[questionNumber]) {
                        debugPrint('Correct');
                        finalScore++;
                      } else {
                        debugPrint('Wrong');
                      }
                      updateQuestion();
                    },
                    child: Text(
                      quiz.choices[questionNumber][1],
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),

              const Padding(padding: EdgeInsets.all(10)),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //button 3
                  MaterialButton(
                    minWidth: 120,
                    color: Colors.blueGrey,
                    onPressed: () {
                      if (quiz.choices[questionNumber][2] ==
                          quiz.correctAnswers[questionNumber]) {
                        debugPrint('Correct');
                        finalScore++;
                      } else {
                        debugPrint('Wrong');
                      }
                      updateQuestion();
                    },
                    child: Text(
                      quiz.choices[questionNumber][2],
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),

                  //button 4
                  MaterialButton(
                    minWidth: 120,
                    color: Colors.blueGrey,
                    onPressed: () {
                      if (quiz.choices[questionNumber][3] ==
                          quiz.correctAnswers[questionNumber]) {
                        debugPrint('Correct');
                        finalScore++;
                      } else {
                        debugPrint('Wrong');
                      }
                      updateQuestion();
                    },
                    child: Text(
                      quiz.choices[questionNumber][3],
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),

              const Padding(padding: EdgeInsets.all(15)),

              Container(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                  minWidth: 240,
                  height: 30,
                  color: Colors.red,
                  onPressed: resetQuiz,
                  child: const Text(
                    'Quit',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void resetQuiz() {
    setState(() {
      Navigator.pop(context);
      finalScore = 0;
      questionNumber = 0;
    });
  }

  void updateQuestion() {
    setState(() {
      if (questionNumber == quiz.questions.length - 1) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => Summary(
              score: finalScore,
            ),
          ),
        );
      } else {
        questionNumber++;
      }
    });
  }
}

class Summary extends StatelessWidget {
  const Summary({super.key, required this.score});
  final int score;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Final Score: $score',
              style: const TextStyle(fontSize: 35),
            ),
            const Padding(padding: EdgeInsets.all(30)),
            MaterialButton(
              color: Colors.red,
              onPressed: () {
                questionNumber = 0;
                finalScore = 0;
                Navigator.pop(context);
              },
              child: const Text(
                'Reset Quiz',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
