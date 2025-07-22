import 'dart:io';

import 'package:logger/logger.dart';
import 'package:yelpax_pro/core/error/exceptions/exceptions.dart';
import 'package:yelpax_pro/core/error/failures/failure.dart';



class ErrorHandler {
  static final _logger = Logger();
  static Failure mapExceptionToFailure(Exception e) {
    _logger.e('Exception caught', error: e);
    if (e is ServerException) return ServerFailure(e.message);
    if (e is NetworkException) return NetworkFailure(e.message);
    if (e is ValidationException) return ValidationFailure(e.message);
    if (e is CacheException) return CacheFailure(e.message);
    if (e is SocketException) return NoInternetFailure(e.message);
    return GenericFailure('Unexpected error occurred');
  }
}
