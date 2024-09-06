import 'package:flutter/material.dart';

class ButtonsRow extends StatefulWidget {
  final List<String> buttons;
  final Function(String) appendNumber;
  final bool isResult;
  final Function(String) appendOperator;
  final Function()? calculate;
  final Function()? reduceExpression;
  final Function()? resetExpression;

  const ButtonsRow(
      {super.key,
      required this.buttons,
      required this.appendNumber,
      required this.appendOperator,
      this.isResult = false,
      this.calculate,
      this.reduceExpression,
      this.resetExpression});

  @override
  State<ButtonsRow> createState() => _ButtonsRowState();
}

class _ButtonsRowState extends State<ButtonsRow> {
  void handleButtonPress(String button) {
    if (button == '=') {
      widget.calculate!();
    } else if (button == 'C/AC') {
      widget.isResult ? widget.resetExpression!() : widget.reduceExpression!();
    } else if (int.tryParse(button) != null) {
      widget.appendNumber(button);
    } else {
      widget.appendOperator(button == "—" ? "-" : button);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widget.buttons.map(
        (button) {
          bool isWide = button == "="; 
          return createButton(
            button,
            () => handleButtonPress(button),
            isWide: isWide,
          );
        },
      ).toList(),
    );
  }

  Widget createButton(String button, Function() onPress,
      {bool isWide = false}) {
    return TextButton(
      onPressed: onPress,
      onLongPress: button == "C/AC" ? widget.resetExpression : null,
      style: ButtonStyle(
        backgroundColor: int.tryParse(button) != null || button == "."
            ? WidgetStateProperty.all<Color>(const Color(0xFF3d3d3d))
            : button == '='
                ? WidgetStateProperty.all<Color>(const Color(0xFFff9700))
                : WidgetStateProperty.all<Color>(const Color(0xFF1a1a1a)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        minimumSize: WidgetStateProperty.all<Size>(
          isWide ? const Size(191.8, 90) : const Size(90, 90),
        ),
      ),
      child: Text(
        button == 'C/AC' ? (widget.isResult ? 'AC' : 'C') : button,
        style: TextStyle(
            fontSize: button == 'C/AC' ? 28 : 32, color: Colors.white),
      ),
    );
  }
}
