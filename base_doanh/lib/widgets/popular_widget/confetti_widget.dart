import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class Confetti extends StatelessWidget {
  const Confetti({
    Key? key,
    required this.controller,
    this.createParticlePath,
    this.numberOfParticles,
    this.colors,
  }) : super(key: key);
  final ConfettiController controller;
  final Path Function(Size size)? createParticlePath;
  final int? numberOfParticles;
  final List<Color>? colors;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: ConfettiWidget(
        confettiController: controller,
        blastDirectionality: BlastDirectionality.explosive,
        colors: colors ??
            [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.yellow,
              Colors.redAccent
            ],
        gravity: 1,
        numberOfParticles: 3,
        strokeColor: Colors.white,
        createParticlePath: createParticlePath,
      ),
    );
  }
}

List<Path> getPath(Size size) => [
      path1(size),
      path2(size),
      path3(size),
      path4(size),
      path5(size),
    ];

Path path1(Size size) {
  final Path path = Path();
  path.moveTo(size.width * 0.9747190, size.height * 0.1408192);
  path.cubicTo(
    size.width * 0.7079143,
    size.height * 0.6287967,
    size.width * 0.3053843,
    size.height * 0.4760342,
    size.width * 0.03830681,
    size.height * 0.9654500,
  );
  path.lineTo(
    size.width * 0.1121914,
    size.height * 0.3007642,
  );
  path.cubicTo(
      size.width * 0.2919762,
      size.height * 0.07856475,
      size.width * 0.5552238,
      size.height * 0.2480883,
      size.width * 0.7350048,
      size.height * 0.02636717);
  path.lineTo(
    size.width * 0.9747190,
    size.height * 0.1408192,
  );
  path.close();
  return path;
}

Path path2(Size size) {
  final Path path = Path();
  path.moveTo(size.width * 0.9905625, size.height * 0.08333182);
  path.cubicTo(
      size.width * 0.6552562,
      size.height * 0.3414995,
      size.width * 0.3774381,
      size.height * 0.6361591,
      size.width * 0.1671356,
      size.height * 0.9566636);
  path.lineTo(size.width * 0.04687469, size.height * 0.8966909);
  path.cubicTo(
      size.width * 0.2571769,
      size.height * 0.5761864,
      size.width * 0.5349975,
      size.height * 0.2815259,
      size.width * 0.8703000,
      size.height * 0.02335777);
  path.lineTo(size.width * 0.9905625, size.height * 0.08333182);
  path.close();
  return path;
}

Path path3(Size size) {
  final Path path = Path();
  path.moveTo(size.width * 0.5679553, size.height * 0.9755478);
  path.cubicTo(
      size.width * 0.5679553,
      size.height * 0.9755478,
      size.width * -0.0009522600,
      size.height * 0.9785435,
      size.width * 0.0001970513,
      size.height * 0.6320043);
  path.lineTo(size.width * 0.04578633, size.height * 0.2967052);
  path.cubicTo(
      size.width * 0.04578633,
      size.height * 0.2967052,
      size.width * -0.05305427,
      size.height * 0.6784739,
      size.width * 0.5476513,
      size.height * 0.7187000);
  path.lineTo(size.width * 0.5679553, size.height * 0.9755478);
  path.moveTo(size.width * 0.9330467, size.height * 0.01603357);
  path.lineTo(size.width * 0.9541200, size.height * 0.2773770);
  path.cubicTo(
      size.width * 0.9541200,
      size.height * 0.2773770,
      size.width * 0.08332533,
      size.height * 0.1821843,
      size.width * 0.0001922927,
      size.height * 0.6319130);
  path.cubicTo(
      size.width * 0.0001922927,
      size.height * 0.6319130,
      size.width * -0.005554260,
      size.height * 0.3923078,
      size.width * 0.04578153,
      size.height * 0.2958657);
  path.cubicTo(
      size.width * 0.1300640,
      size.height * 0.1392100,
      size.width * 0.3687373,
      size.height * -0.05792217,
      size.width * 0.9330467,
      size.height * 0.01603357);
  path.close();
  return path;
}

Path path4(Size size) {
  final Path path = Path();
  path.moveTo(size.width * 0.8243330, size.height * 0.1049980);
  path.lineTo(size.width * 0.01564940, size.height * 0.3088111);
  path.lineTo(size.width * 0.1427680, size.height * 0.9314978);
  path.lineTo(size.width * 0.9514510, size.height * 0.7276856);
  path.lineTo(size.width * 0.8243330, size.height * 0.1049980);
  path.close();
  return path;
}

Path path5(Size size) {
  final Path path = Path();
  path.moveTo(size.width * 0.06373792, size.height * 0.1915487);
  path.lineTo(size.width * 0.5979000, size.height * 0.9507800);
  path.lineTo(size.width * 0.9189833, size.height * 0.8062067);
  path.lineTo(size.width * 0.3848250, size.height * 0.04697093);
  path.lineTo(size.width * 0.06373792, size.height * 0.1915487);
  path.close();
  return path;
}
