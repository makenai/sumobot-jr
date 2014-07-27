// =======================
// Sumobot Jr demo program
// =======================

var five = require("johnny-five");
var keypress = require('keypress');

keypress(process.stdin);

var robot = {};
robot.delay = 0;
robot.sendCmd = function(type, action, ms) {
  this.delay += ms;
  var cmd = this[type][action];
  setTimeout(cmd, this.delay); 
  return this;
};
robot.done = function() {
  setTimeout(function() {
    console.log("finished!");
  }, this.delay);
  this.delay = 0;
};

var board = new five.Board();

board.on("ready", function() {

  console.log("Welcome to Sumobot Jr!")
  console.log("Control the bot with the arrow keys, and SPACE to stop.")

  robot.left_wheel  = new five.Servo({ pin:  9, type: 'continuous' }).stop();
  robot.right_wheel = new five.Servo({ pin: 10, type: 'continuous'  }).stop();

  robot.move = {};
  robot.move.forward = function() {
    console.log('moving forward...');
    robot.left_wheel.ccw();
    robot.right_wheel.cw();
  };
  robot.move.backward = function() {
    console.log('moving backward...');
    robot.left_wheel.cw();
    robot.right_wheel.ccw();    
  };
  robot.move.left = function() {
    console.log('turning left...');
    robot.left_wheel.ccw();
    robot.right_wheel.ccw();
  };
  robot.move.right = function() {
    console.log('turning right...');
    robot.left_wheel.cw();
    robot.right_wheel.cw();
  };
  robot.move.stop = function() {
    console.log('stopping...');
    left_wheel.stop();
    right_wheel.stop();
  };


  process.stdin.resume(); 
  process.stdin.setEncoding('utf8'); 
  process.stdin.setRawMode(true); 

  process.stdin.on('keypress', function (ch, key) {
    
    if ( !key ) return;


    if ( key.name == 'q' ) {

      console.log('quitting!');
      process.exit();

    } else if ( key.name == 'up' ) {

      robot.move.forward();

    } else if ( key.name == 'down' ) {

      robot.move.backward();

    } else if ( key.name == 'left' ) {

      robot.move.left();

    } else if ( key.name == 'right' ) {

      robot.move.right();

    } else if ( key.name == 'space' ) {

      robot.move.stop();

    } else if ( key.name == 'u' ) {

      // queue up the commands for our robot!
      robot.sendCmd("move", "forward", 0)
           .sendCmd("move", "backward", 1500)
           .sendCmd("move", "forward", 600)
           .sendCmd("move", "stop", 1200)
           .done();
    }

  });


});