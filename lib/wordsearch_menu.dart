import 'dart:core';

import 'package:flutter/material.dart';
import 'package:super_hero_word_game/globals.dart';
import 'package:super_hero_word_game/wordsearch_widget.dart';

class WordSearchMenu extends StatefulWidget {
  const WordSearchMenu({super.key});

  @override
  State<WordSearchMenu> createState() => _WordSearchMenu();
}

class _WordSearchMenu extends State<WordSearchMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text('WORDSEARCH'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                difficultyButton('Easy', 1),
                difficultyButton('Medium', 2),
                difficultyButton('Hard', 3),
                difficultyButton('Insane', 4),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .8,
              width: MediaQuery.of(context).size.width * .97,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    button('Iron Man', 'ironman'),
                    button('Black Panther', 'blackpanther'),
                    button(
                      'Guardians of the Galaxy',
                      'guardiansofthegalaxy',
                    ),
                    button('Spider Man', 'spiderman'),
                    button('Avengers', 'avengers'),
                    button('Captain America', 'captainamerica'),
                    button('Batman', 'batman'),
                    button('Venom', 'venom'),
                    button('Thor', 'thor'),
                  ],
                  //),
                ),
                //padding: EdgeInsets.only(left: 0.02.sh, right: 0.02.sh),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton difficultyButton(String text, int level) {
    return ElevatedButton(
      onPressed: () {
        difficulty = level;
        setState(() {});
      },
      style: difficulty != level
          ? ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white24),
            )
          : ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
            ),
      child: Text(text),
    );
  }

  GestureDetector button(String title, String text) {
    return GestureDetector(
      onTap: () {
        categorySelection = text;
        openCrossword();
      },
      child: getTile(title, text),
    );
  }

  void openCrossword() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const WordSearchWidget(),
      ),
    );
  }

  Container getTile(String thisTitle, String imageFile) {
    final _imageFile = 'images/$imageFile.jpeg';

    return Container(
      height: 0.1 * MediaQuery.of(context).size.height,
      width: 1 * MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(1),
        borderRadius:
            BorderRadius.circular(0.02 * MediaQuery.of(context).size.width),
      ),
      margin:
          EdgeInsets.only(bottom: 0.01 * MediaQuery.of(context).size.height),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius:
                BorderRadius.circular(0.02 * MediaQuery.of(context).size.width),
            child: Container(
              height: 0.4 * MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_imageFile),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.srcOver,
                  ),
                ),
              ),
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              margin: EdgeInsets.only(
                left: 0.05 * MediaQuery.of(context).size.width,
                top: 0.04 * MediaQuery.of(context).size.height,
              ),
              child: Text(
                thisTitle.toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  letterSpacing: 0.3,
                  wordSpacing: 1,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
