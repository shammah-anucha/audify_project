import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Audio with ChangeNotifier {
  final int audioId;
  final int userId;
  final int bookId;
  final String audioFile;
  final String audioName;
  final String bookImage;

  Audio({
    required this.audioId,
    required this.userId,
    required this.bookId,
    required this.audioFile,
    required this.audioName,
    required this.bookImage,
  });
}
