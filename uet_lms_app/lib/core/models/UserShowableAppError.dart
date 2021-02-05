class UserShowableAppError {
  String message;
  String description;

  UserShowableAppError({this.message, this.description});

  @override
  String toString() {
    return "UserShowableAppError: $message\n$description";
  }
}
