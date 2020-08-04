import 'package:meta/meta.dart';

@immutable
class SignoutState {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailed;

  SignoutState({
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailed,
  });

  factory SignoutState.initial() {
    return SignoutState(
      isSubmitting: false,
      isSuccess: false,
      isFailed: false,
    );
  }

  factory SignoutState.loading() {
    return SignoutState(
      isSubmitting: true,
      isSuccess: false,
      isFailed: false,
    );
  }

  factory SignoutState.failed() {
    return SignoutState(
      isSubmitting: false,
      isSuccess: false,
      isFailed: true,
    );
  }

  factory SignoutState.success() {
    return SignoutState(
      isSubmitting: false,
      isSuccess: true,
      isFailed: false,
    );
  }

  @override
  String toString() {
    return '''SignoutState {     
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailed: $isFailed,
    }''';
  }
}