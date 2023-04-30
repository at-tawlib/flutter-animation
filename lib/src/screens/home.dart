import 'package:flutter/material.dart';
import '../widgets/cat.dart';
import 'dart:math';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  late Animation<double> catAnimation;
  late AnimationController catController;
  late Animation<double> boxAnimation;
  late AnimationController boxController;

  @override
  initState() {
    super.initState();

    // set up animation for box flaps
    boxController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    boxAnimation = Tween(
      begin: pi * 0.6,
      end: pi * 0.65,
    ).animate(CurvedAnimation(
      parent: boxController,
      curve: Curves.easeInOut,
    ));

    boxAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxController.forward();
      }
    });
    boxController.forward();

    // set up the animation controller
    catController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // set up the animation
    catAnimation = Tween(begin: 20.0, end: 200.0).animate(CurvedAnimation(
      parent: catController,
      curve: Curves.easeIn,
    ));
  }

  // box is flapping and cat is inside the box
  // when tapped, the box stops flapping and the cats pops out
  // when tapped again, the cat returns into the box and the box starts flapping again
  onTap() {
    if (catController.status == AnimationStatus.completed) {
      catController.reverse();
      boxController.forward();
    } else if (catController.status == AnimationStatus.dismissed) {
      catController.forward();
      boxController.stop();
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation'),
      ),
      body: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          bottom: catAnimation.value,
          right: 0.0,
          left: 0.0,
          child: child ?? Cat(),
        );
      },
      child: Cat(),
    );
  }

  // Build box to contain cat
  Widget buildBox() {
    return Container(
      height: 200.0,
      width: 200.0,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 3.0,
      child: AnimatedBuilder(
          animation: boxAnimation,
          child: Container(
            height: 20.0,
            width: 125.0,
            color: Colors.brown,
          ),
          builder: (context, child) {
            return Transform.rotate(
              angle: boxAnimation.value,
              alignment: Alignment.topLeft,
              child: child,
            );
          }),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 3.0,
      child: AnimatedBuilder(
          animation: boxAnimation,
          child: Container(
            height: 20.0,
            width: 125.0,
            color: Colors.brown,
          ),
          builder: (context, child) {
            return Transform.rotate(
              angle: -boxAnimation.value,
              alignment: Alignment.topRight,
              child: child,
            );
          }),
    );
  }
}
