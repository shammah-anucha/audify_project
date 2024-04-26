import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'book.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Books with ChangeNotifier {
  List<Book> _books = [];

  List<Book> get items {
    return [..._books];
  }

  List<Book> get books => _books;

  Book findById(int id) {
    return _books.firstWhere((book) => book.bookId == id);
  }

  Future<void> fetchAndSetBooks(String? token) async {
    String tokenString = token!;

    final url = Uri.parse('http://127.0.0.1:8000/api/v1/Books/');

    Map<String, String>? headers = {
      'Authorization': 'Bearer $tokenString',
      'Content-Type': 'application/json',
    };

    // I modified the http.dart to Map<String, String?>? for it to work
    final response = await http.get(url, headers: headers);
    final decodedResponse = json.decode(response.body);
    final int numberOfObjects = decodedResponse.length;
    final List<Book> loadedBook = [];
    final extractedData = json.decode(response.body);
    if (extractedData == null) {
      return;
    }

    int i = 0;
    while (i < numberOfObjects) {
      loadedBook.add(Book(
        bookId: extractedData[i]['book_id'],
        userId: extractedData[i]['user_id'],
        bookName: extractedData[i]['book_name'],
        bookFile: extractedData[i]['book_file'],
        bookImage: extractedData[i]['book_image'],
      ));
      i++;
    }

    _books = loadedBook.reversed.toList();

    notifyListeners();
  }

  Future<int> addBook(io.File? pdfFile, String? token) async {
    String tokenString = token!;
    pdfFile!.path;

    Map<String, String>? headers = {
      'Authorization': 'Bearer $tokenString',
      'Content-Type': 'application/json',
    };

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://127.0.0.1:8000/api/v1/Books/uploadbook/'),
      );
      request.headers.addAll(headers);
      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          pdfFile.path,
          filename: pdfFile.path.split("/").last,
        ),
      );

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['book_id'];
      } else if (response.statusCode == 403) {
        throw Exception(response.body);
      } else if (response.statusCode == 413) {
        throw Exception("File size is too large. The Maximum File size is 5MB");
      } else if (response.statusCode == 404) {
        throw Exception("User not found");
      } else if (response.statusCode == 500) {
        throw Exception("Internal Server Error");
      } else {
        throw Exception("Unexpected error occurred (${response.statusCode})");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteBook(int id) async {
    final bookIndex = _books.indexWhere((book) => book.bookId == id);
    final bookId = _books[bookIndex].bookId;
    var existingBook = _books[bookIndex];
    final url = Uri.parse('http://127.0.0.1:8000/api/v1/Books/$bookId');
    _books.removeAt(bookIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _books.insert(bookIndex, existingBook);
      notifyListeners();
      throw Exception('Could not delete product.');
    }
  }
}
