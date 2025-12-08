import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// StateProvider to hold the email input from the TextField
final emailProvider = StateProvider<String>((ref) => '');

// StateProvider to hold the password input from the TextField
final passProvider = StateProvider<String>((ref) => '');

final clickedLogin = StateProvider<bool>((ref) => false);