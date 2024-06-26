import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Book with ChangeNotifier {
  final int bookId;
  final int userId;
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
