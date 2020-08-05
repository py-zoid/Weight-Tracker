import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class WeightObject {
  final DateTime timestamp;
  final double weight;

  WeightObject({@required this.timestamp, @required this.weight});
}
