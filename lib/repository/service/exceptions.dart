class RequestException implements Exception {
  final String errorMessage;

  RequestException(this.errorMessage);
}

class InvalidRequestException extends RequestException {
  InvalidRequestException({String? errorMessage})
      : super(errorMessage ??
            'Something have went wrong, please try again later');
}

class InternalServerErrorException extends RequestException {
  InternalServerErrorException({String? errorMessage})
      : super(errorMessage ??
            'Something have went wrong, please try again later');
}

class NotFoundException extends RequestException {
  NotFoundException({String? errorMessage})
      : super(errorMessage ?? 'The requested information could not be found');
}

class NoConnectionException extends RequestException {
  NoConnectionException()
      : super('No internet connection detected, please try again later.');
}

class TimeOutException extends RequestException {
  TimeOutException()
      : super('The connection has timed out, please try again later.');
}
