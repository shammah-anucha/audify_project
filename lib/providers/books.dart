// import 'dart:io';

// import 'package:audio_book_app/providers/auth.dart';
// import 'dart:html';
import 'dart:io' as io;

import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'book.dart';
import 'package:http/http.dart' as http;
// import 'package:uuid/uuid.dart';
import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:audio_book_app/models/http_exception.dart';

class Books with ChangeNotifier {
  List<Book> _books = [
    // Book(
    //   bookId: 2,
    //   userId: 1,
    //   bookName: "The Frog Prince.pdf",
    //   bookFile:
    //       "https://myaudiobookapp.s3.eu-central-1.amazonaws.com/The-Frog-Prince-Landscape-Book-CKF-FKB.pdf",
    //   bookImage: "assets/output.jpg",
    // ),
    // Book(
    //   bookId: 2,
    //   userId: 1,
    //   bookName: "Ugly Duckline",
    //   bookFile:
    //       "https://myaudiobookapp.s3.eu-central-1.amazonaws.com/The-Frog-Prince-Landscape-Book-CKF-FKB.pdf",
    //   bookImage: "assets/output.jpg",
    // ),
  ];

  List<Book> get items {
    return [..._books];
  }

  List<Book> get books => _books;

  Book findById(int id) {
    return _books.firstWhere((book) => book.bookId == id);
  }

  Future<void> fetchAndSetBooks(String? token) async {
    String tokenString = token!;
    print("Token string is: $tokenString");

    final url = Uri.parse('http://127.0.0.1:8000/api/v1/Books/');

    Map<String, String>? headers = {
      'Authorization': 'Bearer $tokenString',
      'Content-Type': 'application/json',
    };

    // print(token);

    // I modified the http.dart to Map<String, String?>? for it to work
    final response = await http.get(url, headers: headers);
    final decodedResponse = json.decode(response.body);
    final int numberOfObjects = decodedResponse.length;
    final List<Book> loadedBook = [];
    final extractedData = json.decode(response.body);
    // print(extractedData["name"]);
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

  // final String baseUrl = "http://127.0.0.1:8000/api/v1/events/";

  // void _fetchDataFromTheServer() async {
  //   final Dio dio = Dio();
  // }

// // http://127.0.0.1:8000/api/v1/events/
  // Future<int?> addBook(io.File? pdfFile, String? token) async {
  //   String tokenString = token!;
  //   print("Token string is: $tokenString");

  //   Map<String, String>? headers = {
  //     'Authorization': 'Bearer $tokenString',
  //     'Content-Type': 'application/json',
  //   };

  //   List<int> pdfBytes = await pdfFile!.readAsBytes();
  //   print(pdfBytes);

  //   // final url = Uri.parse('http://127.0.0.1:8000/api/v1/Books/uploadbook/');

  //   var request = http.MultipartRequest(
  //       'POST', Uri.parse('http://127.0.0.1:8000/api/v1/Books/uploadbook/'));
  //   request.headers.addAll(headers);
  //   request.files.add(
  //     await http.MultipartFile.fromPath(
  //       pdfFile.path
  //           .split("/")
  //           .toString(), // NOTE - this value must match the 'file=' at the start of -F
  //       pdfFile.path,
  //       // contentType: MediaType('image', 'png'),
  //     ),
  //   );

  //   final response = await http.Response.fromStream(await request.send());

  //   print(response.body);

  //   // final req = http.MultipartFile.fromBytes(pdfBytes, );

  //   // Map<String, String>? headers = {
  //   //   'Authorization': 'Bearer $tokenString',
  //   //   'Content-Type': 'application/json',
  //   // };
  //   try {
  //     //   final response = await http.post(url,
  //     //       headers: headers,
  //     //       body: json.encode({
  //     //         // 'event_id': uuid.v4(),
  //     //         'file': pdfFile,
  //     //       }));
  //     //   print("issue!!!");
  //     //   print(json.decode(response.body));

  //     final newBook = Book(
  //       bookId: json.decode(response.body)['book_id'],
  //       userId: json.decode(response.body)['user_id'],
  //       bookFile: json.decode(response.body)['book_file'],
  //       bookImage: json.decode(response.body)['book_image'],
  //       bookName: json.decode(response.body)['book_name'],
  //     );
  //     _books.add(newBook);
  //     notifyListeners();
  //     print(_books);
  //     // Return the bookId
  //     final int? bookId = json.decode(response.body)['book_id'];

  //     return bookId;
  //   } catch (error) {
  //     print(error);
  //     throw (error);
  //   }
  // }

  // Future<int> addBook(io.File? pdfFile, String? token) async {
  //   String tokenString = token!;
  //   print("Token string is: $tokenString");
  //   print(pdfFile!.path);
  //   print(pdfFile.path.split("/").last);

  //   Map<String, String>? headers = {
  //     'Authorization': 'Bearer $tokenString',
  //     'Content-Type': 'application/json',
  //   };

  //   // List<int> pdfBytes = await pdfFile.readAsBytes();
  //   // print(pdfBytes);

  //   var request = http.MultipartRequest(
  //       'POST', Uri.parse('http://127.0.0.1:8000/api/v1/Books/uploadbook/'));
  //   request.headers.addAll(headers);
  //   request.files.add(
  //     await http.MultipartFile.fromPath("file", pdfFile.path,
  //         filename: pdfFile.path.split("/").last),
  //   );

  //   final response = await http.Response.fromStream(await request.send());
  //   print(response.body);

  //   // if (response.statusCode >= 400) {}
  //   try {
  //     // Parse the response JSON
  //     final Map<String, dynamic> responseData = json.decode(response.body);

  //     // Create a new book object from the response data
  //     final newBook = Book(
  //       bookId: responseData['book_id'],
  //       userId: responseData['user_id'],
  //       bookFile: responseData['book_file'],
  //       bookImage: responseData['book_image'],
  //       bookName: responseData['book_name'],
  //     );

  //     // Add the new book to the list of books
  //     _books.add(newBook);
  //     // final int? bookId = responseData['book_id'];
  //     // print(bookId);

  //     // Notify listeners about the changes
  //     notifyListeners();

  //     // Return the bookId
  //     final int bookId = responseData['book_id'];
  //     return bookId;
  //   } catch (error) {
  //     print("An unexpected error occurred: $error");
  //     throw error;
  //   }
  // }

  Future<int> addBook(io.File? pdfFile, String? token) async {
    String tokenString = token!;
    print("Token string is: $tokenString");
    print(pdfFile!.path);
    print(pdfFile.path.split("/").last);

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
      // print("An unexpected error occurred: $error");
      throw error;
    }
  }

//   Future<void> updateEvent(String id, Event newEvent) async {
//     final evIndex = _events.indexWhere((ev) => ev.event_id == id);
//     final event_id = _events[evIndex].event_id;
//     if (evIndex != null) {
//       final url = Uri.parse('http://10.0.2.2:8000/api/v1/events/$event_id');
//       await http.put(url,
//           headers: <String, String>{
//             'Content-Type': 'application/json; charset=UTF-8',
//           },
//           body: json.encode({
//             'title': newEvent.title,
//             'eventdate': newEvent.eventdate,
//             'time': newEvent.time,
//             'imageUrl': newEvent.imageUrl,
//             'location': newEvent.location,
//             'location_url': newEvent.location_url,
//             'host': newEvent.host
//           }));
//       print(event_id);
//       _events[evIndex] = newEvent;
//       notifyListeners();
//     } else {
//       print('...');
//     }
//   }

  Future<void> deleteBook(int id) async {
    final bookIndex = _books.indexWhere((book) => book.bookId == id);
    final book_id = _books[bookIndex].bookId;
    var existingBook = _books[bookIndex];
    final url = Uri.parse('http://127.0.0.1:8000/api/v1/Books/$book_id');
    _books.removeAt(bookIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _books.insert(bookIndex, existingBook);
      notifyListeners();
      throw Exception('Could not delete product.');
    }
    // existingBook = null;
  }
}
