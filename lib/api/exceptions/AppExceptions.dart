
class AppExceptions implements Exception{
  AppExceptions([this._message, this._prefix]);
  final _message;
  final _prefix;
  String toString(){
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppExceptions{
  FetchDataException({String? message}) : super(message, "Error During Communication");
}

class BadRequestException extends AppExceptions{
  BadRequestException({String? message}) : super(message, "Ivalid Request");
}

class UnAuthorizedException extends AppExceptions{
  UnAuthorizedException({String? message}) : super(message, "Unauthorized request");
}

class InvalidInputException extends AppExceptions{
  InvalidInputException({String? message}) : super(message, "Invalid Input");
}