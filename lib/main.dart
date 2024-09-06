import 'package:calculator_app/buttons_row_widget.dart';
import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Calculator',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.deepOrange.shade900),
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  final List<List<String>> allRows = [
    ["C/AC", "÷"],
    ["7", "8", "9", "x"],
    ["4", "5", "6", "—"],
    ["1", "2", "3", "+"],
    ["0", ".", "="],
  ];
  static const _operators = ['+', '-', '*', '/', '÷', 'x'];
  bool isResult = false;

  @override
  void initState() {
    _controller = TextEditingController(text: "0");
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _calculate() {
    String expression = _controller.text;
    if (expression == '0') return;

    expression = expression.replaceAllMapped(
      RegExp(r'[÷x]'),
      (match) => match[0] == '÷' ? '/' : '*',
    );

    expression = removeTrailingDecimalPoints(expression);
    devtools.log('expression: $expression');

    try {
      final parsedExpression = Expression.parse(expression);
      const evaluator = ExpressionEvaluator();
      final result = evaluator.eval(parsedExpression, {});
      String resultString = result.toString();

      if (resultString.endsWith(".0")) {
        resultString = resultString.substring(0, resultString.length - 2);
      }

      _controller.text = resultString;
      setState(() {
        isResult = true;
      });
    } catch (e) {
      _controller.text = "Error";
      devtools.log(e.toString());
    }
  }

  String removeTrailingDecimalPoints(String expression) {
    final pattern = RegExp(r'\.(?=[+\-*/x÷]|\s*$)');

    while (pattern.hasMatch(expression)) {
      devtools.log(
          'hasMatch: ${pattern.hasMatch(expression)}, expression: $expression');
      expression = expression.replaceFirst(pattern, '');
      devtools.log('expression: $expression');
    }

    return expression;
  }

  void _appendNumToExpression(String value) {
    if (isResult) {
      _controller.text = value;
      setState(() {
        isResult = false;
      });
    } else {
      if (_controller.text == "0") {
        _controller.text = value;
      } else {
        _controller.text += value;
      }
    }
  }

  bool _isLastCharacterAnOperator() {
    return _operators.contains(_controller.text.characters.last);
  }

  void _appendOperatorToExpression(String value) {
    final text = _controller.text;
    String partAfterLastOperator = '';

    if (value == '.') {
      final lastOperatorIndex = text.lastIndexOf(RegExp(r'[+\-*/x÷]'));
      if (lastOperatorIndex >= 0) {
        partAfterLastOperator = text.substring(lastOperatorIndex + 1);
      } else {
        partAfterLastOperator = text;
      }

      if (partAfterLastOperator.contains('.')) return;
      // if (partAfterLastOperator.endsWith('.')) return;
    }

    // if (text.endsWith('.') && value == ".") return;

    if (text.isNotEmpty) {
      if (_isLastCharacterAnOperator() && value != '.') {
        _controller.text = text.substring(0, text.length - 1) + value;
      } else if (partAfterLastOperator.isEmpty && value == '.') {
        _controller.text += "0$value";
      } else {
        _controller.text += value;
      }

      setState(() {
        isResult = false;
      });
    }
  }

  void _reduceExpression() {
    setState(() {
      _controller.text = _controller.text.length > 1
          ? _controller.text.substring(0, _controller.text.length - 1)
          : "0";
    });
  }

  void _resetExpression() {
    setState(() {
      _controller.text = "0";
      isResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFFff9700),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(32),
          ),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: 411.4,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(
                  heightFactor: 1.8,
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: () {
                        _focusNode.unfocus();
                      },
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        minLines: 1,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) {
                          _calculate();
                        },
                      ),
                    ),
                  ),
                ),
                ...allRows.map(
                  (row) {
                    return ButtonsRow(
                      buttons: row,
                      appendNumber: _appendNumToExpression,
                      appendOperator: _appendOperatorToExpression,
                      isResult: isResult,
                      calculate: _calculate,
                      reduceExpression: _reduceExpression,
                      resetExpression: _resetExpression,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
