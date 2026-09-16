import 'dart:async';
import 'dart:developer' show log;
import 'dart:ffi';
import 'dart:math' show pow;

import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

class BmiView extends StatefulWidget {
  const new({super.key});

  @override
  State<BmiView> createState() => _BmiViewState();
}

class _BmiViewState extends State<BmiView> {
  double? _bmi;
  double? _height;
  double? _weight;

  bool _bmiValueIsNull = true;

  void _animateHeadline() {
    setState(() {
      _bmiValueIsNull = !_bmiValueIsNull;
    });
  }

  void _setHeight(double? height) {
    _height = height ?? _height;
  }

  void _setWeight(double? weight) {
    _weight = weight ?? _weight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AnimatedHeadline(isBig: _bmiValueIsNull),
          AnimatedPadding(
            duration: Duration(milliseconds: 600),
            padding: EdgeInsetsGeometry.directional(
              top: _bmiValueIsNull ? 40 : 20,
              bottom: _bmiValueIsNull ? 0 : 20,
            ),
            child: Row(
              children: [
                AppInputField(
                  text: "Height in cm",
                  callback: _setHeight,
                ),
                AppInputField(
                  text: "Weight",
                  callback: _setWeight,
                ),
              ],
            ),
          ),
          AnimatedPadding(
            duration: Duration(milliseconds: 600),
            padding: EdgeInsetsGeometry.directional(
              top: _bmiValueIsNull ? 50 : 5,
            ),
            child: ElevatedButton(
              onPressed: () {
                if (_height != null && _weight != null) {
                  setState(() {
                    _bmi = _weight! / pow(_height! / 100, 2);
                    _bmiValueIsNull = false;
                    _animateHeadline;
                  });
                }
              },
              style: ButtonStyle(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const AppText(
                  data: "Calculate",
                  fontSize: 30,
                ),
              ),
            ),
          ),
          ResultText(bmi: _bmi),
          (_bmi != null) ? BmiGauge(bmi: _bmi) : SizedBox.shrink(),
          (_bmi != null)
              ? FadeInWidget(
                  conditon: _bmi != null,
                  child: AppText(
                    data: getCategory(_bmi!),
                    fontSize: 30,
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}

String getCategory(double bmi) {
  if (bmi < 18.5) return "Underweight";
  if (bmi < 25) return "Normal";
  if (bmi < 30) return "Overweight";
  if (bmi < 40) return "Obese";
  return "Severely obese";
}

class AnimatedHeadline extends StatefulWidget {
  final bool isBig;
  const AnimatedHeadline({super.key, required this.isBig});

  @override
  State<AnimatedHeadline> createState() => _AnimatedHeadlineState();
}

class _AnimatedHeadlineState extends State<AnimatedHeadline> {
  @override
  Widget build(BuildContext context) {
    widget.isBig;
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedPadding(
          duration: Duration(milliseconds: 100),
          curve: Curves.fastOutSlowIn,
          padding: EdgeInsetsGeometry.directional(top: widget.isBig ? 120 : 40),
          child: Align(
            child: AppText(
              data: "BMI",
              fontSize: widget.isBig ? 120 : 50,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        AppText(
          data: "BODY - MASS - INDEX",
          fontSize: widget.isBig ? 20 : 20,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}

class AppText extends StatefulWidget {
  final String data;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;

  const AppText({
    super.key,
    required this.data,
    this.fontSize,
    this.color,
    this.fontWeight,
  });

  @override
  State<AppText> createState() => _AppTextState();
}

class _AppTextState extends State<AppText> {
  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: Duration(milliseconds: 600),
      curve: Curves.fastOutSlowIn,
      style: TextStyle(
        fontSize: widget.fontSize,
        color: widget.color,
        fontWeight: widget.fontWeight,
      ),
      child: Text(
        widget.data,
      ),
    );
  }
}

class AppInputField extends StatelessWidget {
  final String text;
  final Function(double? value) callback;
  const AppInputField({super.key, required this.text, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppText(
              data: text,
              fontSize: 19,
            ),
          ),
          Container(
            width: 150,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                vertical: 12,
                horizontal: 10,
              ),
              child: Center(
                child: Expanded(
                  child: TextField(
                    onChanged: (value) => callback(double.tryParse(value)),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FadeInWidget extends StatefulWidget {
  final bool conditon;
  final Widget child;
  const FadeInWidget({super.key, required this.child, required this.conditon});

  @override
  State<FadeInWidget> createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget> {
  @override
  Widget build(BuildContext context) {
    double opacity = 0;
    void animate() {
      setState(() {
        opacity = 1;
      });
    }

    if (widget.conditon) animate();
    return AnimatedOpacity(
      opacity: opacity,
      duration: Duration(seconds: 1),
      child: widget.child,
    );
  }
}

class ResultText extends StatefulWidget {
  final double? bmi;
  const ResultText({super.key, required this.bmi});

  @override
  State<ResultText> createState() => _ResultTextState();
}

class _ResultTextState extends State<ResultText> {
  @override
  Widget build(BuildContext context) {
    return FadeInWidget(
      conditon: widget.bmi != null,
      child: Column(
        children: [
          AppText(
            data: "BMI:",
            fontSize: (widget.bmi != null) ? 60 : 0,
          ),
          AppText(
            data: (widget.bmi ?? 0).round().toString(),
            fontSize: (widget.bmi != null) ? 30 : 0,
          ),
        ],
      ),
    );
  }
}

class BmiGauge extends StatefulWidget {
  final double? bmi;
  const BmiGauge({super.key, required this.bmi});

  @override
  State<BmiGauge> createState() => _BmiGaugeState();
}

class _BmiGaugeState extends State<BmiGauge> {
  bool isActive = false;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  void _startTimer() async {
    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      isActive = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isActive
        ? SizedBox(
            width: 260,
            height: 300,
            child: SfRadialGauge(
              enableLoadingAnimation: true,
              animationDuration: 1500,
              axes: <RadialAxis>[
                RadialAxis(
                  showLabels: false,
                  minimum: 10,
                  maximum: 40,
                  ranges: <GaugeRange>[
                    GaugeRange(
                      startValue: 0,
                      endValue: 18.5,
                      color: Colors.blue,
                      startWidth: 80,
                      endWidth: 80,
                    ),

                    GaugeRange(
                      startValue: 18.5,
                      endValue: 24.9,
                      color: Colors.green,
                      startWidth: 80,
                      endWidth: 80,
                    ),
                    GaugeRange(
                      startValue: 24.9,
                      endValue: 30,
                      color: Colors.orange,
                      startWidth: 80,
                      endWidth: 80,
                    ),
                    GaugeRange(
                      startValue: 30,
                      endValue: 35,
                      color: const Color.fromARGB(255, 255, 98, 0),
                      startWidth: 80,
                      endWidth: 80,
                    ),
                    GaugeRange(
                      startValue: 35,
                      endValue: 40,
                      color: const Color.fromARGB(255, 255, 0, 0),
                      startWidth: 80,
                      endWidth: 80,
                    ),
                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(
                      value: widget.bmi ?? 11,
                      enableAnimation: true,
                    ),
                  ],
                ),
              ],
            ),
          )
        : SizedBox.shrink();
  }
}
