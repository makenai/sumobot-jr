// ================================================
// Sumobot Jr demo program (wireless with Spark-IO)
// ================================================

'use strict';

var five = require('johnny-five');
var Spark = require('spark-io');
var keypress = require('keypress');

keypress(process.stdin);

var board = new five.Board({
  io: new Spark({
    token: process.env.SPARK_TOKEN,
    deviceId: process.env.SPARK_DEVICE_ID
  })
});

board.on('ready', function() {

  console.log('Welcome to Sumobot Jr, powered wirelessly with the Spark Core!')
  console.log('Control the bot with the arrow keys, and SPACE to stop.')

  var leftWheel = new five.Servo({ pin: 'D0', type: 'continuous' }).stop();
  var rightWheel = new five.Servo({ pin: 'D1', type: 'continuous' }).stop();

  process.stdin.resume();
  process.stdin.setEncoding('utf8');
  process.stdin.setRawMode(true);

  process.stdin.on('keypress', function (ch, key) {

    if ( !key ) { return; }

    if ( key.name === 'q' ) {

      console.log('Quitting');
      process.exit();

    } else if ( key.name === 'up' ) {

      console.log('Forward');
      leftWheel.ccw(0.9);
      rightWheel.cw(0.9);

    } else if ( key.name === 'down' ) {

      console.log('Backward');
      leftWheel.cw(0.9);
      rightWheel.ccw(0.9);

    } else if ( key.name === 'left' ) {

      console.log('Left');
      leftWheel.ccw(0.9);
      rightWheel.ccw(0.9);


    } else if ( key.name === 'right' ) {

      console.log('Right');
      leftWheel.cw(0.9);
      rightWheel.cw(0.9);

    } else if ( key.name === 'space' ) {

      console.log('Stopping');
      leftWheel.stop();
      rightWheel.stop();

    }

  });

});
