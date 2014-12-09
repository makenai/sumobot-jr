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
    robot.left_wheel.stop();
    robot.right_wheel.stop();
  };


  process.stdin.resume(); 
  process.stdin.setEncoding('utf8'); 
  process.stdin.setRawMode(true); 

  process.stdin.on('keypress', function (ch, key) {
    
    if ( !key ) return;

    switch (key.name) {
      case 'q':
        console.log('quitting!');
        process.exit();
        break;
      case 'up': 
        console.log('moving forward...');
        robot.move.forward();
        break;
      case 'down': 
        console.log('moving backward...');
        robot.move.backward();
        break;
      case 'left': 
        console.log('turning left...');
        robot.move.left();
        break;
      case 'right': 
        console.log('moving backward...');
        robot.move.right();
        break;
      case 'space': 
        console.log('stopping...');
        robot.move.stop();
      break;
      case 'u': 
        console.log('custom choreography...');

        // queue up the commands for our robot!
        robot.sendCmd("move", "forward", 0)
             .sendCmd("move", "backward", 300)
             .sendCmd("move", "forward", 300)
             .sendCmd("move", "stop", 300)
             .done();
        break;
    }

  });


});