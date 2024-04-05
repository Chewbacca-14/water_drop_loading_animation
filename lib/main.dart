import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: WaterDropAnimation(),
        ),
      ),
    );
  }
}

class WaterDropAnimation extends StatefulWidget {
  const WaterDropAnimation({
    super.key,
  });

  @override
  State<WaterDropAnimation> createState() => _WaterDropAnimationState();
}

class _WaterDropAnimationState extends State<WaterDropAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 800,
      ),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    const double dotSize = 60 * 0.17;
    const double negativeSpace = 60 - (4 * dotSize);
    const double gapBetweenDots = negativeSpace / 3;
    const double previousDotPosition = -(gapBetweenDots + dotSize);

    Widget translatingDrop() => Transform.translate(
          offset: Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(0, -previousDotPosition),
          )
              .animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(
                    0.22,
                    0.82,
                  ),
                ),
              )
              .value,
          child: const WaterDrop(),
        );

    Widget scalingDrop(bool scaleDown, Interval interval) => Transform.scale(
          scale: Tween<double>(
            begin: scaleDown ? 1.0 : 0.0,
            end: scaleDown ? 0.0 : 1.0,
          )
              .animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: interval,
                ),
              )
              .value,
          child: const WaterDrop(),
        );

    return Center(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SizedBox(
              width: 60,
              height: 60,
              //WATER DROPS ANIMATION
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (_, __) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          scalingDrop(
                            false,
                            const Interval(
                              0.3,
                              0.7,
                            ),
                          ),
                          translatingDrop(),
                        ],
                      ),
                      translatingDrop(),
                      translatingDrop(),
                      scalingDrop(
                        true,
                        const Interval(
                          0.0,
                          0.4,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          //WATER BOX
          Container(
            height: 18,
            width: 40,
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
                left: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
                bottom: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

//Draw Water Drop

class WaterDrop extends StatelessWidget {
  const WaterDrop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('drop.svg');
  }
}
