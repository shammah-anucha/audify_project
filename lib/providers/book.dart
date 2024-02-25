import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Book with ChangeNotifier {
  final String bookId;
  final String userId;
  final String bookName;
  final String bookFile;
  final String bookImage;

  Book({
    required this.bookId,
    required this.userId,
    required this.bookName,
    required this.bookFile,
    required this.bookImage,
  });
}
