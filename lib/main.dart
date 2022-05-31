import 'package:flutter/material.dart';

void main() => runApp(const MyApp());


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Animations Intro',
      debugShowCheckedModeBanner: false,
      home: LogoApp(),
    );
  }
}

class LogoApp extends StatefulWidget {
  const LogoApp({ Key? key }) : super(key: key);

  @override
  State<LogoApp> createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2)
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    animation.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed){
        controller.forward();
      }
    });

    // animation.addListener(() {
    //   print(animation.value);
    // });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TnnTransition(
        child: const LogoWidget(),
        animation: animation,
      ),
    );
  }
}

// class AnimatedLogo extends AnimatedWidget {
  
//   const AnimatedLogo(Animation<double> animation, {Key? key}) : super(key: key, listenable: animation);

//   @override
//   Widget build(BuildContext context) {
    
//     final Animation<double> animation = listenable as Animation<double>;

//     return Center(
//       child: SizedBox(
//         height: animation.value,
//         width: animation.value,
//         child: const FlutterLogo(),
//       ),
//     );
//   }

// }

class LogoWidget extends StatelessWidget {
  const LogoWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FlutterLogo();
  }
}

class TnnTransition extends StatelessWidget {

  final Widget child;
  final Animation<double> animation;
  
  final sizeTween = Tween<double>(begin: 0, end: 300);
  final opacityTween = Tween<double>(begin: 0.1, end: 1);

  TnnTransition({ Key? key, required this.child, required this.animation }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation, 
        builder: (context, child) {
          return Opacity(
            //opacity: opacityTween.evaluate(animation),
            opacity: opacityTween.evaluate(animation).clamp(0.0, 1.0),
            child: SizedBox(
              height: sizeTween.evaluate(animation),
              width: sizeTween.evaluate(animation),
              child: child,
            ),
          );
        },
        child: child,
      ),
    );
  }
}