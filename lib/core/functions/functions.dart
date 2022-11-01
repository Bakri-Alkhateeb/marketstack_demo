import 'package:flutter/material.dart';

void snackBarMessage({
  required BuildContext context,
  required String message,
  required Color backgroundColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    ),
  );
}

Future<T> exceptionHandler<T, E extends Exception>({
  required ValueGetter<Future<T>> tryBlock,
  required E Function({required String error}) makeException,
}) async {
  try {
    return await tryBlock();
  } on Exception catch (e, stackTrace) {
    if (e is E) {
      rethrow;
    }

    Error.throwWithStackTrace(
      makeException(error: e.toString()),
      stackTrace,
    );
  }
}
