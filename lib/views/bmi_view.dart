import 'package:flutter/material.dart';

class BmiView extends StatefulWidget {
  const new({super.key});

  @override
  State<BmiView> createState() => _BmiViewState();
}

class _BmiViewState extends State<BmiView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Padding(
            padding: EdgeInsetsGeometry.directional(top: 120),
            child: Align(
              child: AppText(
                data: "BMI",
                fontSize: 100,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          AppText(
            data: "BODY - MASS - INDEX",
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          Padding(
            padding: EdgeInsetsGeometry.directional(top: 40),
            child: Row(
              children: [
                AppInputField(
                  text: "Height",
                ),
                AppInputField(
                  text: "Weight",
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.directional(top: 50),
            child: ElevatedButton(
              onPressed: () {},
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

class AppText extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}

class AppInputField extends StatelessWidget {
  final String text;
  const AppInputField({super.key, required this.text});

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
