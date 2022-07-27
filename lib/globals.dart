String categorySelection = '';

int difficulty = 1;

List<String> returnString = [];

List<String> getWords(String category) {
  switch (category) {
    case 'guardiansofthegalaxy':
      returnString = [
        'starlord',
        'yondu',
        'drax',
        'nebula',
        'kree',
        'taserface',
        'gamora',
        'groot',
        'rocket',
        'ronan',
        'ravagers',
        'music'
      ];

      returnString.shuffle();
      return returnString;
    case 'spiderman':
      returnString = [
        'spiderman',
        'peter',
        'parker',
        'sandman',
        'ned',
        'vulture',
        'web',
        'swing',
        'shocker',
        'droctopus',
        'mysterio',
        'rhino'
      ];

      returnString.shuffle();
      return returnString;

    case 'avengers':
      returnString = [
        'thor',
        'captain',
        'america',
        'ironman',
        'hawkeye',
        'hulk',
        'thanos',
        'antman',
        'loki',
        'fury',
        'avengers',
        'wasp'
      ];
      if (difficulty >= 3) {
        returnString
          ..add('blackwidow')
          ..add('blackpanther');
      }
      returnString.shuffle();
      return returnString;

    case 'captainamerica':
      returnString = [
        'captain',
        'america',
        'serum',
        'soldier',
        'steve',
        'rogers',
        'redskull',
        'shield',
        'army',
        'bucky',
        'barnes',
        'war',
        'peggy'
      ];
      if (difficulty >= 3) {
        returnString.add('wintersoldier');
      }

      returnString.shuffle();
      return returnString;

    case 'batman':
      returnString = [
        'batman',
        'robin',
        'joker',
        'penguin',
        'bruce',
        'wayne',
        'twoface',
        'catwoman',
        'batmobile',
        'alfred',
        'gotham',
        'arkham',
        'mrfreeze',
        'riddler',
        'batgirl'
      ];

      returnString.shuffle();
      return returnString;

    case 'venom':
      returnString = [
        'venom',
        'carnage',
        'symbiote',
        'eddie',
        'brock',
        'black',
        'antivenom',
        'spiderman',
        'teeth',
        'scream',
        'scary'
      ];
      if (difficulty >= 2) {
        returnString.add('experiment');
      }
      returnString.shuffle();
      return returnString;

    case 'ironman':
      returnString = [
        'ironman',
        'tony',
        'stark',
        'pepper',
        'coulson',
        'friday',
        'jarvis',
        'whiplash',
        'fury',
        'happy',
        'howard'
      ];
      if (difficulty >= 2) {
        returnString.add('warmachine');
      }
      returnString.shuffle();
      return returnString;

    case 'thor':
      returnString = [
        'thor',
        'loki',
        'odin',
        'hela',
        'valkyrie',
        'jane',
        'heimdall',
        'korg',
        'asgardian',
        'sif',
        'hammer',
        'mjolnir'
      ];
      if (difficulty >= 3) {
        returnString.add('stormbreaker');
      }

      returnString.shuffle();
      return returnString;
    case 'blackpanther':
      returnString = [
        'wakanda',
        'shuri',
        'okoye',
        'vibranium',
        'claws',
        'tchalla',
        'king',
        'tchaka',
        'mbaku',
        'nakia',
        'jabari',
        'africa'
      ];
      if (difficulty >= 3) {
        returnString
          ..add('killmonger')
          ..add('blackpanther');
      }

      returnString.shuffle();
      return returnString;
  }

  return [];
}
