'use strict';

var five = require('johnny-five');
var board = new five.Board();
var keypress = require('keypress');

board.on('ready', function() {
  // Use your shield configuration from the list
  // http://johnny-five.io/api/motor/#pre-packaged-shield-configs
  var configs = five.Motor.SHIELD_CONFIGS.ADAFRUIT_V1;
  var motors = new five.Motors([
    configs.M1,
    configs.M2
  ]);

  // If you want to add servos to your motor shield
  // You can also use continuous servos: new five.Servo.Continuous(10)
  var servo1 = new five.Servo(10);
  var servo2 = new five.Servo(9);

  this.repl.inject({
    motors: motors,
    servo1: servo1,
    servo2: servo2
  });

  console.log('Welcome to the Motorized SumoBot!');
  console.log('Control the bot with the arrow keys, and SPACE to stop.');

  function forward() {
    console.log('Going forward');
    motors.fwd(255);
  }

  function backward() {
    console.log('Going backward');
    motors.rev(255);
  }

  function left() {
    console.log('Going left');
    motors[0].rev(200);
    motors[1].fwd(200);
  }

  function right() {
    console.log('Going right');
    motors[1].rev(200);
    motors[0].fwd(200);
  }

  function stop() {
    motors.stop();

    // Optionally, stop servos from sweeping
    servo1.stop();
    servo2.stop();
  }

  function sweep() {
    console.log('Sweep the leg!!');

    // Sweep from 0-180 (repeat)
    servo1.sweep();
    servo2.sweep();
  }

  keypress(process.stdin);
  process.stdin.resume();
  process.stdin.setEncoding('utf8');
  process.stdin.setRawMode(true);
  process.stdin.on('keypress', function (ch, key) {

    if ( !key ) { return; }

    if ( key.name === 'q' ) {

      console.log('Quitting');
      stop();
      process.exit();

    } else if ( key.name === 'up' ) {

      forward();

    } else if ( key.name === 'down' ) {

      backward();

    } else if ( key.name === 'left' ) {

      left();

    } else if ( key.name === 'right' ) {

      right();

    } else if ( key.name === 'space' ) {

      stop();

    } else if ( key.name === 's' ) {

      sweep();

    }
  });
});
