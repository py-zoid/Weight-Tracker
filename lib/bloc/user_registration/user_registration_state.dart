import 'package:meta/meta.dart';

@immutable
class UserRegistrationState {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailed;
  String errorMessage;

  UserRegistrationState({
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailed,
    this.errorMessage,
  });

  factory UserRegistrationState.initial() {
    return UserRegistrationState(
      isSubmitting: false,
      isSuccess: false,
      isFailed: false,
    );
  }

  factory UserRegistrationState.loading() {
    return UserRegistrationState(
      isSubmitting: true,
      isSuccess: false,
      isFailed: false,
    );
  }

  factory UserRegistrationState.failed(String message) {
    return UserRegistrationState(
      isSubmitting: false,
      isSuccess: false,
      isFailed: true,
      errorMessage: message,
    );
  }

  factory UserRegistrationState.success() {
    return UserRegistrationState(
      isSubmitting: false,
      isSuccess: true,
      isFailed: false,
    );
  }

  @override
  String toString() {
    return '''UserRegistrationState {     
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailed,
      errorMessage: $errorMessage
    }''';
  }
}