import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_hero_word_game/globals.dart';
import 'package:word_search/word_search.dart';

class WordSearchWidget extends StatefulWidget {
  const WordSearchWidget({super.key});

  @override
  State<WordSearchWidget> createState() => _WordSearchWidget();
}

class _WordSearchWidget extends State<WordSearchWidget> {
  Duration duration = Duration.zero;
  late Timer timer;
  int minutes = 0;
  int seconds = 0;

  int record = 0;

  int finalTime = 0;

  int correctAnswers = 0;
  int totalAnswers = 0;

  double fontSize = 10;
  int numBoxPerRow = 20;
  double padding = 5;
  Size sizeBox = Size.zero;
  int numberOfWords = 0;

  late ValueNotifier<List<List<String>>?> listChars;
  late ValueNotifier<List<CrosswordAnswer>> answerList;
  late ValueNotifier<CurrentDragObj> currentDragObj;
  late ValueNotifier<List<int>> charsDone;

  @override
  void initState() {
    super.initState();
    correctAnswers = 0;
    getRecords();
    setVarsFromDifficulty();
    listChars = ValueNotifier<List<List<String>>?>([]);
    answerList = ValueNotifier<List<CrosswordAnswer>>([]);
    currentDragObj = ValueNotifier<CurrentDragObj>(CurrentDragObj());
    charsDone = ValueNotifier<List<int>>(<int>[]);
    generateRandomWord();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    const addSeconds = 1;

    setState(() {
      seconds = duration.inSeconds + addSeconds;

      duration = Duration(seconds: seconds);
    });
  }

  void resetPuzzle() {
    correctAnswers = 0;
    setState(() {
      timer.cancel();
      duration = Duration.zero;
      startTimer();
      getRecords();
      listChars = ValueNotifier<List<List<String>>?>([]);
      answerList = ValueNotifier<List<CrosswordAnswer>>([]);
      currentDragObj = ValueNotifier<CurrentDragObj>(CurrentDragObj());
      charsDone = ValueNotifier<List<int>>(<int>[]);
      generateRandomWord();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void setVarsFromDifficulty() {
    switch (difficulty) {
      case 1:
        numBoxPerRow = 9;
        fontSize = 30;
        numberOfWords = 6;
        break;

      case 2:
        numBoxPerRow = 12;
        fontSize = 24;
        numberOfWords = 9;
        break;

      case 3:
        numBoxPerRow = 16;
        fontSize = 18;
        numberOfWords = 12;
        break;

      case 4:
        numBoxPerRow = 20;
        fontSize = 14;
        numberOfWords = 12;
        break;
    }
    totalAnswers = numberOfWords;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Scaffold(
      appBar: AppBar(
        title: Text('$minutes:$seconds'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff7c94b6),
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.dstATop,
                  ),
                  image: AssetImage('images/$categorySelection.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),

              //color: Colors.blue,
              alignment: Alignment.center,
              width: double.maxFinite,
              height: size.width - padding * 2,
              padding: EdgeInsets.all(padding),
              margin: EdgeInsets.all(padding),
              child: drawCrosswordBox(),
            ),
            Container(
              // alignment: Alignment.center,
              // lets show list word we need solve
              child: drawAnswerList(),
            ),
            ElevatedButton(
              onPressed: resetPuzzle,
              child: const Text('Reset'),
            )
          ],
        ),
      ),
    );
  }

  void onDragEnd(PointerUpEvent? event) {
    print('PointerUpEvent');
    // check if drag line object got value or not.. if no no need to clear
    if (currentDragObj.value.currentDragLine.isEmpty) return;

    currentDragObj.value.currentDragLine.clear();
    currentDragObj.notifyListeners();

    checkForPuzzleComplete();
  }

  void onDragUpdate(PointerMoveEvent event) {
    // generate ondragLine so we know to highlight path later
    // & clear if condition dont meet .. :D
    generateLineOnDrag(event);

    // get index on drag

    final indexFound = answerList.value.indexWhere((answer) {
      return answer.answerLines.join('-') ==
          currentDragObj.value.currentDragLine.join('-');
    });

    print(currentDragObj.value.currentDragLine.join('-'));
    if (indexFound >= 0) {
      answerList.value[indexFound].done = true;
      correctAnswers++;
      print(correctAnswers);
      // save answerList which complete
      charsDone.value.addAll(answerList.value[indexFound].answerLines);
      charsDone.notifyListeners();
      answerList.notifyListeners();
      onDragEnd(null);
    }
  }

  void checkForPuzzleComplete() {
    if (correctAnswers == totalAnswers) {
      print('puzzle is complete');
      timer.cancel();
      finalTime = duration.inSeconds;
      print(record);
      setRecords();
      print('$finalTime was your score, the record is $record');
      showRecord();
    }
  }

  Future<void> getRecords() async {
    final prefs = await SharedPreferences.getInstance();

    if (difficulty == 1) record = prefs.getInt('easyWordSearchRecord') ?? 0;
    if (difficulty == 2) record = prefs.getInt('mediumWordSearchRecord') ?? 0;
    if (difficulty == 3) record = prefs.getInt('hardWordSearchRecord') ?? 00;
    if (difficulty == 4) record = prefs.getInt('insaneWordSearchRecord') ?? 0;

    print('record: $record');
  }

  Future<void> setRecords() async {
    final prefs = await SharedPreferences.getInstance();
    if (difficulty == 1 && (finalTime < record || record == 0)) {
      await prefs.setInt('easyWordSearchRecord', finalTime);
    }

    if (difficulty == 2 && (finalTime < record || record == 0)) {
      await prefs.setInt('mediumWordSearchRecord', finalTime);
    }

    if (difficulty == 3 && (finalTime < record || record == 0)) {
      await prefs.setInt('hardWordSearchRecord', finalTime);
    }

    if (difficulty == 4 && (finalTime < record || record == 0)) {
      await prefs.setInt('insaneWordSearchRecord', finalTime);
    }
  }

  Future<void> showRecord() async {
    final recordMinutes = record ~/ 60;
    final recordSeconds = record % 60;
    final finalTimeMinutes = finalTime ~/ 60;
    final finalTimeSeconds = finalTime % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final displayMinutes = twoDigits(finalTimeMinutes);
    final displaySeconds = twoDigits(finalTimeSeconds);
    final displayRecordMinutes = twoDigits(recordMinutes);
    final displayRecordSeconds = twoDigits(recordSeconds);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final recordText = (record <= finalTime)
            ? 'Current record: $displayRecordMinutes:$displayRecordSeconds'
            : 'Previous record: $displayRecordMinutes:$displayRecordSeconds';
        return Dialog(
          backgroundColor: Colors.white,
          child: Container(
            width: MediaQuery.of(context).size.width * .9,
            height: MediaQuery.of(context).size.width * .9,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('PUZZLE FINISHED'),
                Text('Your time: $displayMinutes:$displaySeconds'),
                Text(recordText),
                Text(
                  (record <= finalTime)
                      ? ''
                      : 'Well done, you have the new record!',
                ),
                ElevatedButton(
                  child: const Text('CONTINUE'),
                  onPressed: () {
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int calculateIndexBasePosLocal(Offset localPosition) {
    // get size max per box
    final maxSizeBox =
        (sizeBox.width - (numBoxPerRow - 1) * padding) / numBoxPerRow;

    if (localPosition.dy > sizeBox.width || localPosition.dx > sizeBox.width) {
      return -1;
    }

    var x = 0;
    var y = 0;
    var yAxis = 0.0;
    var xAxis = 0.0;
    var yAxisStart = 0.0;
    var xAxisStart = 0.0;

    for (var i = 0; i < numBoxPerRow; i++) {
      xAxisStart = xAxis;
      xAxis += maxSizeBox +
          (i == 0 || i == (numBoxPerRow - 1) ? padding / 2 : padding);

      if (xAxisStart < localPosition.dx && xAxis > localPosition.dx) {
        x = i;
        break;
      }
    }

    for (var i = 0; i < numBoxPerRow; i++) {
      yAxisStart = yAxis;
      yAxis += maxSizeBox +
          (i == 0 || i == (numBoxPerRow - 1) ? padding / 2 : padding);

      if (yAxisStart < localPosition.dy && yAxis > localPosition.dy) {
        y = i;
        break;
      }
    }

    return y * numBoxPerRow + x;
  }

  void generateLineOnDrag(PointerMoveEvent event) {
    // we need calculate index array base local position on drag
    final indexBase = calculateIndexBasePosLocal(event.localPosition);

    if (indexBase >= 0) {
      // check drag line already pass 2 box
      if (currentDragObj.value.currentDragLine.length >= 2) {
        // check drag line is straight line
        WSOrientation? wsOrientation;

        if (currentDragObj.value.currentDragLine[0] % numBoxPerRow ==
            currentDragObj.value.currentDragLine[1] % numBoxPerRow) {
          wsOrientation = WSOrientation.vertical;
        } else if (currentDragObj.value.currentDragLine[0] ~/ numBoxPerRow ==
            currentDragObj.value.currentDragLine[1] ~/ numBoxPerRow) {
          wsOrientation = WSOrientation.horizontal;
        }

        if (wsOrientation == WSOrientation.horizontal) {
          if (indexBase ~/ numBoxPerRow !=
              currentDragObj.value.currentDragLine[1] ~/ numBoxPerRow) {
            onDragEnd(null);
          }
        } else if (wsOrientation == WSOrientation.vertical) {
          if (indexBase % numBoxPerRow !=
              currentDragObj.value.currentDragLine[1] % numBoxPerRow) {
            onDragEnd(null);
          }
        } else {
          onDragEnd(null);
        }
      }

      if (!currentDragObj.value.currentDragLine.contains(indexBase)) {
        currentDragObj.value.currentDragLine.add(indexBase);
      } else if (currentDragObj.value.currentDragLine.length >= 2 &&
          currentDragObj.value.currentDragLine[
                  currentDragObj.value.currentDragLine.length - 2] ==
              indexBase) {
        onDragEnd(null);
      }
    }
    // before mistake , should in here
    currentDragObj.notifyListeners();
  }

  void onDragStart(int indexArray) {
    try {
      final indexSelecteds = answerList.value
          .where((answer) => answer.indexArray == indexArray)
          .toList();

      // check indexSelecteds got any match , if 0 no proceed!
      if (indexSelecteds.isEmpty) return;
      // nice triggered
      currentDragObj.value.indexArrayOnTouch = indexArray;
      currentDragObj.notifyListeners();
    } catch (e) {
      /* no-op */
    }
  }

  // nice one

  Widget drawCrosswordBox() {
    // add listener tp catch drag, push down & up
    return Listener(
      onPointerUp: onDragEnd,
      onPointerMove: onDragUpdate,
      child: LayoutBuilder(
        builder: (context, constraints) {
          sizeBox = Size(constraints.maxWidth, constraints.maxWidth);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: numBoxPerRow,
              crossAxisSpacing: padding,
              mainAxisSpacing: padding,
            ),
            itemCount: numBoxPerRow * numBoxPerRow,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) {
              // we need expand because to merge 2d array to become 1..
              // example [["x","x"],["x","x"]] become ["x","x","x","x"]
              final char = listChars.value!.expand((e) => e).toList()[index];

              // yeayy.. now we got crossword box.. easy right!!
              // later i will show how to display current word on crossword
              // next show color path on box when drag, we will using
              // Valuelistener done .. yeayy.. this is simple crossword system
              return Listener(
                onPointerDown: (event) => onDragStart(index),
                child: ValueListenableBuilder(
                  valueListenable: currentDragObj,
                  builder: (context, CurrentDragObj value, child) {
                    //Color color = Colors.yellow;
                    Color? color;

                    if (value.currentDragLine.contains(index)) {
                      color = Colors.white24;
                    } else if (charsDone.value.contains(index)) {
                      color = Colors.blueGrey;
                    } // change color box already path correct

                    return Container(
                      decoration: BoxDecoration(
                        color: color,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        char.toUpperCase(),
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void generateRandomWord() {
    final maxCount = numberOfWords;

    final words = getWords(categorySelection);

    final wl = <String>[];

    for (var i = 0; i < maxCount; i++) {
      wl.add(words[i]);
    }

    // setup configuration to generate crossword

    // Create the puzzle sessting object
    final ws = WSSettings(
      width: numBoxPerRow,
      height: numBoxPerRow,
      orientations: List.from([
        WSOrientation.horizontal,
        WSOrientation.horizontalBack,
        WSOrientation.vertical,
        WSOrientation.verticalUp,
        // WSOrientation.diagonal,
        // WSOrientation.diagonalUp,
      ]),
    );

    // Create new instance of the WordSearch class
    final wordSearch = WordSearch();

    // Create a new puzzle
    final newPuzzle = wordSearch.newPuzzle(wl, ws);

    /// Check if there are errors generated while creating the puzzle
    if (newPuzzle.errors.isEmpty) {
      // if no error.. proceed

      // List<List<String>> charsArray = newPuzzle.puzzle;
      listChars.value = newPuzzle.puzzle;
      // done pass..ez

      // Solve puzzle for given word list
      final solved = wordSearch.solvePuzzle(newPuzzle.puzzle!, wl);

      answerList.value = solved.found
          .map((solve) => CrosswordAnswer(solve, numPerRow: numBoxPerRow))
          .toList();
    }
  }

  Widget drawAnswerList() {
    return ValueListenableBuilder(
      valueListenable: answerList,
      builder: (context, List<CrosswordAnswer> value, child) {
        // lets make custom widget using Column & Row

        // how many row child we want show per row?
        const perColTotal = 3;

        // generate using list.generate
        final List<Widget> list = List.generate(
            (value.length ~/ perColTotal) +
                ((value.length % perColTotal) > 0 ? 1 : 0), (int index) {
          final maxColumn = (index + 1) * perColTotal;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                maxColumn > value.length
                    ? maxColumn - value.length
                    : perColTotal,
                (indexChild) {
                  // forgot to declare array for access answerList
                  final indexArray = index * perColTotal + indexChild;

                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 3.3,
                    child: Text(
                      // make text more clearly to read
                      value[indexArray].wsLocation.word.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: (difficulty < 2) ? 18 : 14,
                        //fontSize: 18,

                        color: value[indexArray].done
                            ? Colors.green
                            : Colors.black,
                        decoration: value[indexArray].done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          );
        }).toList();

        return Column(
          children: list,
        );
      },
    );
  }
}

class CurrentDragObj {
  CurrentDragObj({
    this.indexArrayOnTouch,
    this.currentTouch,
  });
  Offset? currentDragPos;
  Offset? currentTouch;
  int? indexArrayOnTouch;
  List<int> currentDragLine = <int>[];
}

class CrosswordAnswer {
  CrosswordAnswer(this.wsLocation, {required int numPerRow}) {
    indexArray = wsLocation.y * numPerRow + wsLocation.x;
    generateAnswerLine(numPerRow);
  }
  bool done = false;
  int? indexArray;
  WSLocation wsLocation;
  late List<int> answerLines;

  // get answer index for each character word
  void generateAnswerLine(int numPerRow) {
    // declare new list<int>
    answerLines = <int>[];

    // push all index based base word array
    answerLines.addAll(
      List<int>.generate(
        wsLocation.overlap,
        (index) => generateIndexBaseOnAxis(wsLocation, index, numPerRow),
      ),
    );
  }

// calculate index base axis x & y
  int generateIndexBaseOnAxis(WSLocation wsLocation, int i, int numPerRow) {
    var x = wsLocation.x;
    var y = wsLocation.y;

    if (wsLocation.orientation == WSOrientation.horizontal ||
        wsLocation.orientation == WSOrientation.horizontalBack) {
      x = (wsLocation.orientation == WSOrientation.horizontal) ? x + i : x - i;
    } else {
      y = (wsLocation.orientation == WSOrientation.vertical) ? y + i : y - i;
    }

    return x + y * numPerRow;
  }
}
