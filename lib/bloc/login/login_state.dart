import 'package:meta/meta.dart';

@immutable
class LoginState {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailed;
  String errorMessage;

  LoginState({
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailed,
    this.errorMessage,
  });

  factory LoginState.initial() {
    return LoginState(
      isSubmitting: false,
      isSuccess: false,
      isFailed: false,
    );
  }

  factory LoginState.loading() {
    return LoginState(
      isSubmitting: true,
      isSuccess: false,
      isFailed: false,
    );
  }

  factory LoginState.failed(String message) {
    return LoginState(
      isSubmitting: false,
      isSuccess: false,
      isFailed: true,
      errorMessage: message,
    );
  }

  factory LoginState.success() {
    return LoginState(
      isSubmitting: false,
      isSuccess: true,
      isFailed: false,
    );
  }

  @override
  String toString() {
    return '''LoginState {     
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailed: $isFailed,
      errorMessage: $errorMessage,
    }''';
  }
}