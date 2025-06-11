sealed class Failure {
  final String _message;

  const Failure(this._message);

  String get message => _message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network Failure']);
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server Failure']);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache Failure']);
}

final class InvalidInputFailure extends Failure {
  const InvalidInputFailure([super.message = 'Invalid Input']);
}

final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication Failure']);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Unknown Failure']);
}
