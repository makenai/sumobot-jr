# Sumobot Jr.

Sumobot Jr. is an open source sumobot design made for [Nodebots Day](http://nodebotsday.com). Most existing sumo kits cost between $99 and $160. Since we're trying to keep our event costs, I decided to try to design a bot that could be put together for around $50 including the cost of the Arduino. The name and design are inspired by the simplicity and ziptied wood beauty of the [Prinrbot Jr](http://printrbot.com/).

<img src="https://github.com/makenai/sumobot-jr/raw/master/assets/sumobotjr.png">

## How?

The main part of the design is a cutting sheet in EPS format that is made for a laser cutter. You can find it in the cutting_plans directory. If you don't have a laser cutter, you can use a CNC, tape your printout to balsa wood and go at it with an x-acto knife, or send it to a laser cutting service like [Ponoko](https://www.ponoko.com/) and get the sheet done for about $10.

There is also a directory called 3d_print that contains an STL file for a ball caster designed by [sliptonic](http://www.thingiverse.com/thing:13782) - the STL is set up for a 16mm ball bearing, but you can make one for other sizes with the included OpenSCAD file.

## What if I don't have a Laser Cutter / 3D Printer?!

Neither do I! The best way to get some help creating the parts is to look up your local [Hackerspace](http://hackerspaces.org) and connect with them. I belong to a fantastic hackerspace in Las Vegas called [SYN Shop](http://synshop.org)!

<img src="https://github.com/makenai/sumobot-jr/raw/master/assets/synshop.png">

If you don't have a hackerspace nearby, you can also use a mail order service like [Ponoko](http://ponoko.com) that does both 3D printing and laser cutting.

## Other Parts Needed

+ Arduino - $25
+ [4xAA battery holder](http://www.pololu.com/catalog/product/1153) - $2
+ 2 Zip ties - ?
+ 5 \#4 3/8" wood screws - ?
+ Thick rubber bands - ?
+ 2 continuous servo motors like [Futaba S148](http://www.pololu.com/catalog/product/536) - $28
+ Some wire or leads
+ 16mm ball bearing - ?

That's about it! connect the red and black leads on the servos togehter, then connect them to the + and - terminals on the battery holder respectively. Then connect the black leads and - terminal to the ground of the Arduino. Finally, the white leads of each motor go to pins 9 and 10 (or whatever you lke) on the arduino - you're done!

Stay tuned for detailed assembly instructions.

## License

[Creative Commons - Attribution - ShareAlike 3.0](http://creativecommons.org/licenses/by-sa/3.0/)

You are free to:

+ to Share—to copy, distribute and transmit the work, and
+ to Remix—to adapt the work
+ Under the following conditions:
    + Attribution—You must attribute the work in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the work.)
    + Share Alike—If you alter, transform, or build upon this work, you may distribute the resulting work only under the same, similar or a compatible license.

With the understanding that:

+ Waiver—Any of the above conditions can be waived if you get permission from the copyright holder.
+ Other Rights—In no way are any of the following rights affected by the license:
    + your fair dealing or fair use rights;
    + the author's moral rights; and
    + rights other persons may have either in the work itself or in how the work is used, such as publicity or privacy rights.

## Credits

Made by

<img src="https://github.com/makenai/sumobot-jr/raw/master/assets/amalgamation.png">

Design by [@makenai](http://twitter.com/makenai) with feedback and ideas from [@suziam](http://twitter.com/suziam) aka Amalgamation of Cats.



