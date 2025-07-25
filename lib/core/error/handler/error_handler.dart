import 'dart:io';

import 'package:logger/logger.dart';
import 'package:yelpax_pro/core/error/exceptions/exceptions.dart';
import 'package:yelpax_pro/core/error/failures/failure.dart';

class ErrorHandler {
  static final _logger = Logger();
  
  static Failure mapExceptionToFailure(Exception e) {
    _logger.e('Exception caught', error: e, stackTrace: StackTrace.current);
    
    if (e is ServerException) return ServerFailure(e.message);
    if (e is NetworkException) return NetworkFailure(e.message);
    if (e is ValidationException) return ValidationFailure(e.message);
    if (e is CacheException) return CacheFailure(e.message);
    if (e is SocketException) return NoInternetFailure('No internet connection');
    
    return GenericFailure('An unexpected error occurred');
  }

  static String getUserFriendlyMessage(Failure failure) {
    if (failure is NoInternetFailure) {
      return 'Please check your internet connection and try again';
    } else if (failure is ServerFailure) {
      return 'Our servers are having issues. Please try again later';
    } else if (failure is ValidationFailure) {
      return 'Invalid input: ${failure.message}';
    } else {
      return 'Something went wrong. Please try again';
    }
  }
}