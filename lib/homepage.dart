import 'dart:async';

import 'package:bubble_trouble/ball.dart';
import 'package:bubble_trouble/button.dart';
import 'package:bubble_trouble/missile.dart';
import 'package:bubble_trouble/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

enum direction {LEFT, RIGHT}

class _HomePageState extends State<HomePage>{
  //Player variable
  static double playerX = 0;

  // missile variable
  
  double missileX = playerX;
  double missileHeight = 10;
  bool midShot = false;

  // ball variables
  double ballX = 0.5;
  double ballY = 1;
  var ballDirection = direction.LEFT;

  void startGame(){

    double time = 0;
    double height = 0;
    double velocity = 60; // how strong the jump is

    Timer.periodic(Duration(milliseconds: 10), (timer){
      // quadratic equation that models a bounce (upside down porabola)
      height = -5 * time * time + velocity * time;

      //if the ball reaches the ground , reset the jump
      if(height < 0){
        time = 0;
      }

      // update the new ball position
      setState(() {
        ballY = heightToPosition(height);
      });

      // if the ball hits the left wall, then change direction to right
      if(ballX - 0.005 < -1){
        ballDirection = direction.RIGHT;
      } 
      // if the ball hits the right wall, then change direction to left
      else if (ballX + 0.005 > 1) {
        ballDirection = direction.LEFT;
      }

      if(ballDirection == direction.LEFT){
      setState(() {
        ballX -= 0.005;
      });
      }else if (ballDirection == direction.RIGHT){
        setState(() {
         ballX += 0.005;
        });
      }

      // check if ball hits the player
      if(playerDies()){
        timer.cancel();
        print('dead');
      }

      //keep the time going!
      time += 0.1;
    });
  }

  void moveLeft(){
    setState(() {
      if(playerX  -0.1 < -1){
        //do nothing
      }
      else{
        playerX -= 0.1;
      }
      
      // only make the X coordinate the same when it isn't in the middle of a shot
      if(!midShot){
      missileX =playerX;
      }
    });
  }

  void moveRight(){
    setState(() {
      if(playerX +0.1 > 1){
        //do nothing
      }
      else{
        playerX += 0.1;
      }
      // only make the X coordinate the same when it isn't in the middle of a shot
      if(!midShot){
      missileX =playerX;
      }
    });
  }

  void fireMissile(){
    if(midShot == false){
    Timer.periodic(Duration(milliseconds: 20), (timer) {

      // shots fired
      midShot = true;

      //missile grows till it hits the top of the screen
      setState(() {
        missileHeight += 10;
      });

      //stop missile when it reaches top of the scrren
      if(missileHeight > MediaQuery.of(context).size.height *3/4){
        resetMissile();
        timer.cancel();
        
      }

      // check if missile has hit the ball
      if(ballY > heightToPosition(missileHeight) && 
      (ballX - missileX).abs() < 0.03){
        resetMissile();
        ballX = 5;
        timer.cancel();
      }
    });}
  }

  //coverts height to a coordinate
  double heightToPosition(double height){
    double totalHeight = MediaQuery.of(context).size.height * 3/4;
    double position = 1 - 2 * height / totalHeight;
    return position;
  }

  void resetMissile(){
    missileX = playerX;
    missileHeight = 10;
    midShot = false;
  }

  bool playerDies(){
    // if the ball position and the player position
    // are the same, then player dies
    if((ballX - playerX).abs() < 0.05 && ballY > 0.95){
      return true;
    }else{
      return false;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: (event){
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft){
          moveLeft();
        }else if (event.logicalKey == LogicalKeyboardKey.arrowRight){
          moveRight();
        }

        if(event.logicalKey == LogicalKeyboardKey.space){
          fireMissile();
        }

      },
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.pink[100],
              child: Center(
                child: Stack(
                  children: [
                    MyBall(ballX: ballX, ballY: ballY),
                    MyMissile(
                      height: missileHeight,
                      missileX: missileX,
                    ),
                    MyPlayer(
                      playerX: playerX,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    icon: Icons.play_arrow,
                    function: startGame,
                  ),
                  MyButton(
                    icon: Icons.arrow_back,
                    function: moveLeft,
                  ),
                  MyButton(
                    icon: Icons.arrow_upward,
                    function: fireMissile,
                  ),
                  MyButton(
                    icon: Icons.arrow_forward,
                    function: moveRight,
                  ),
      
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}