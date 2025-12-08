import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showAlert(BuildContext context, String title, String message) {
  Flushbar(
    title: title,
    message: message,
    duration: const Duration(seconds: 4),
    margin: const EdgeInsets.all(12),
    borderRadius: BorderRadius.circular(12),
    backgroundColor: Colors.redAccent,
    flushbarPosition: FlushbarPosition.TOP,
    icon: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28),
  ).show(context);
}
