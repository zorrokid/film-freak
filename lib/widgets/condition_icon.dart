import 'package:flutter/material.dart';
import '../models/condition.dart';

class ConditionIcon extends StatelessWidget {
  const ConditionIcon({required this.condition, super.key});
  final Condition condition;

  Color _getColor(condition) {
    var color = Colors.grey;
    switch (condition) {
      case Condition.bad:
        {
          color = Colors.red;
        }
        break;
      case Condition.poor:
        {
          color = Colors.orange;
        }
        break;
      case Condition.fair:
        {
          color = Colors.yellow;
        }
        break;
      case Condition.good:
        {
          color = Colors.blue;
        }
        break;
      case Condition.excellent:
        {
          color = Colors.green;
        }
        break;
      case Condition.mint:
        {
          color = Colors.green;
        }
        break;
      default:
        {
          color = Colors.grey;
        }
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.check, color: _getColor(condition));
  }
}
