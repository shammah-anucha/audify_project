// import 'dart:io';

// import 'package:audio_book_app/providers/auth.dart';
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
    // if (token == null) {
    //   // Handle null token gracefully, such as logging an error or returning early
    //   print('Token is null');
    //   return;
    // }

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
    print(json.decode(response.body));
    print(numberOfObjects);
    final List<Book> loadedBook = [];
    final extractedData = json.decode(response.body);
    // print(extractedData["name"]);
    if (extractedData == null) {
      return;
    }
    // extractedData.forEach((eventId, eventData) {
    print("issue!!!!!");
    int a = 1;
    print(extractedData[a]['book_id']);
    print("user_id: ${extractedData[a]['user_id']}");
    print(extractedData[a]['book_name']);
    print(extractedData[a]['book_file']);
    print(extractedData[a]['book_image']);
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

    print(_books);
    notifyListeners();
  }

  // final String baseUrl = "http://127.0.0.1:8000/api/v1/events/";

  // void _fetchDataFromTheServer() async {
  //   final Dio dio = Dio();
  // }

// // http://127.0.0.1:8000/api/v1/events/
//   Future<void> addEvent(Event event) async {
//     final url = Uri.parse('http://10.0.2.2:8000/api/v1/events/{event_id}');
//     var uuid = Uuid();
//     try {
//       final response = await http.post(url,
//           headers: <String, String>{
//             'Content-Type': 'application/json; charset=UTF-8',
//           },
//           body: json.encode({
//             // 'event_id': uuid.v4(),
//             'title': event.title,
//             'eventdate': event.eventdate,
//             'time': event.time,
//             'imageUrl': event.imageUrl,
//             'location': event.location,
//             'location_url': event.location_url,
//             'host': event.host,
//           }));
//       print(json.decode(response.body));
//       final newEvent = Event(
//         event_id: json.decode(response.body)['event_id'],
//         title: event.title,
//         eventdate: event.eventdate,
//         time: event.time,
//         imageUrl: event.imageUrl,
//         location: event.location,
//         location_url: event.location_url,
//         host: event.host,
//       );
//       _events.add(newEvent);
//       notifyListeners();
//     } catch (error) {
//       print(error);
//       throw (error);
//     }
//   }

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

//   Future<void> deleteEvent(String id) async {
//     final evIndex = _events.indexWhere((ev) => ev.event_id == id);
//     final event_id = _events[evIndex].event_id;
//     var existingEvent = _events[evIndex];
//     final url = Uri.parse('http://10.0.2.2:8000/api/v1/events/$event_id');
//     _events.removeAt(evIndex);
//     notifyListeners();
//     final response = await http.delete(url);
//     if (response.statusCode >= 400) {
//       _events.insert(evIndex, existingEvent);
//       notifyListeners();
//       throw HttpException('Could not delete product.');
//     }
//     existingEvent = null;
//   }
}
