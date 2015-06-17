// ===================================
// Sumobot Jr "Thriller" dance program
// ===================================

'use strict';

var five = require('johnny-five');
var keypress = require('keypress');
var promise = require('bluebird');
var board = new five.Board();


board.on('ready', function() {

  var leftWheel = new five.Servo({ pin: 9, type: 'continuous' }).stop();
  var rightWheel = new five.Servo({ pin: 10, type: 'continuous' }).stop();


  keypress(process.stdin);
  process.stdin.resume();
  process.stdin.setEncoding('utf8');
  process.stdin.setRawMode(true);

  var okay = promise.resolve();

  var beat = 508;

function stop() {

  console.log('Stopping');
  leftWheel.stop();
  rightWheel.stop();
}

function turnleft() {

  console.log('Left');
  leftWheel.ccw();
  rightWheel.ccw();
}

function turnright() {

  console.log('Right');
  leftWheel.cw();
  rightWheel.cw();
}

function forward() {

  console.log('Forward');
  leftWheel.ccw();
  rightWheel.cw();
}

function back() {

  console.log('Backward');
  leftWheel.cw();
  rightWheel.ccw();
}


  process.stdin.on('keypress', function (ch, key) {


    if ( !key ) { return; }


    if ( key.name === 'q' ) {

      console.log('Quitting');
      process.exit();

    }

    if ( key.name === 'space' ) {

      for(var i = 0; i < 10; i++) {
        if(i === 6){
          okay = okay.delay(beat * 2);
          for(var j = 0; j < 16; j++){
            okay = okay.then(forward);
            okay = okay.delay(beat);
            okay = okay.then(back);
            okay = okay.then(beat);
          }
          continue;
        }

        okay = okay.then(turnleft);
        okay = okay.delay(4 * beat);
        okay = okay.then(turnright);
        okay = okay.delay(4 * beat);
        okay = okay.then(forward);
        okay = okay.delay(4 * beat);
        okay = okay.then(back);
        okay = okay.delay(4 * beat);
        okay = okay.then(stop);
      }
    }
  });
});
