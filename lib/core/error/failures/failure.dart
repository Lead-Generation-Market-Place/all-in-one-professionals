abstract class Failure {
  final String message;
  const Failure(this.message);
}

class GenericFailure extends Failure {
  const GenericFailure(String message) : super(message);
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

class NoInternetFailure extends Failure {
  const NoInternetFailure(String message) : super(message);
}
