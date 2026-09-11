import 'dart:developer' show log;

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
    log(_height.toString());
  }

  void _setWeight(double? weight) {
    _weight = weight ?? _weight;
    log(_weight.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AnimatedHeadline(isBig: _bmiValueIsNull),
          Padding(
            padding: EdgeInsetsGeometry.directional(top: 40),
            child: Row(
              children: [
                AppInputField(
                  text: "Height",
                  callback: _setHeight,
                ),
                AppInputField(
                  text: "Weight",
                  callback: _setWeight,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.directional(top: 50),
            child: ElevatedButton(
              onPressed: () {
                if (_height != null && _weight != null) {
                  setState(() {
                    _bmi = _weight! / _height!;
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
        ],
      ),
    );
  }
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
          duration: Duration(milliseconds: 600),
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
          AppText(data: text),
          Container(
            width: 150,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                vertical: 12,
                horizontal: 10,
              ),
              child: TextField(
                onChanged: (value) => callback(double.tryParse(value)),
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
