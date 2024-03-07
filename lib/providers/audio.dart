import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Audio with ChangeNotifier {
  final int audioId;
  final String userId;
  final String bookId;
  final String audioFile;
  final String audioName;

  Audio({
    required this.audioId,
    required this.userId,
    required this.bookId,
    required this.audioFile,
    required this.audioName,
  });
}
