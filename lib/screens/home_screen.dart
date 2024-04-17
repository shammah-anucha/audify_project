// import 'dart:async';

import 'package:audio_book_app/models/conversion.dart';
import 'package:audio_book_app/providers/audios.dart';
import 'package:audio_book_app/providers/auth.dart';
import 'package:audio_book_app/screens/converting_screen.dart';
import 'package:audio_book_app/screens/converting_second_screen.dart';
import 'package:audio_book_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:audio_book_app/providers/books.dart';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late ConversionModel _conversionModel;
  late SharedPreferences
      _prefs; // Add this line to hold a reference to SharedPreferences
  //ignore: unused_field
  var _isInit = true;
  //ignore: unused_field
  var _isLoading = false;
  File? _file;
  String audioName = '';

  getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      _file = file;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select file'),
      ));
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _conversionModel = Provider.of<ConversionModel>(context, listen: false);
  //   _saveAudioToS3();
  // }

  // void _saveAudioToS3() async {
  //   print("First: $audioName");
  //   final prefs = await SharedPreferences.getInstance();
  //   if (prefs.containsKey('audioName')) {
  //     audioName = prefs.getString('audioName') ?? '';
  //   }
  //   Navigator.pop(context);

  //   final isValid = _formKey.currentState!.validate();
  //   if (!isValid) {
  //     return;
  //   }
  //   _formKey.currentState!.save();

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   print("audioName: $audioName");
  //   try {
  //     _conversionModel.startConverting();
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => const ConvertingScreen()),
  //     );
  //     final authData = Provider.of<Auth>(context, listen: false);
  //     int bookId = await Provider.of<Books>(context, listen: false)
  //         .addBook(_file, authData.token);
  //     print("book_id: ${bookId}");
  //     print("token: ${authData.token}");

  //     await Provider.of<Audios>(context, listen: false)
  //         .addAudio(bookId, audioName, authData.token);

  //     Navigator.pop(context);
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => const HomeScreen()),
  //     );
  //     _conversionModel.completeConverting();
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("An error : $error"),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     return;
  //   }

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  // Move the initialization of audioName to initState
  @override
  void initState() {
    super.initState();
    _conversionModel = Provider.of<ConversionModel>(context, listen: false);
    _initSharedPreferences();
  }

  // Initialize SharedPreferences
  void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    // Retrieve audioName if it exists
    if (_prefs.containsKey('audioName')) {
      setState(() {
        audioName = _prefs.getString('audioName') ?? '';
      });
    }
  }

  void _saveAudioToS3() async {
    // Ensure _formKey.currentState is not null before accessing it
    if (_formKey.currentState == null) {
      return;
    }

    // Save audioName to SharedPreferences
    await _prefs.setString('audioName', audioName);

    print("First: $audioName");

    Navigator.pop(context);

    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    print("audioName: $audioName");
    try {
      _conversionModel.startConverting();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ConvertingScreen()),
      );
      final authData = Provider.of<Auth>(context, listen: false);
      int bookId = await Provider.of<Books>(context, listen: false)
          .addBook(_file, authData.token);
      print("book_id: ${bookId}");
      print("token: ${authData.token}");

      await Provider.of<Audios>(context, listen: false)
          .addAudio(bookId, audioName, authData.token);

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      _conversionModel.completeConverting();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error : $error"),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Audify'),
      ),
      drawer: AppDrawer(),
      body: Consumer<ConversionModel>(
        builder: (context, model, _) {
          if (model.status == ConversionStatus.converting) {
            return const ConvertingSecondScreen();
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(50),
                          child: const Column(
                            children: [
                              Text(
                                "Convert PDF to Audio",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 52, 51, 51),
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "3 simple steps:",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Import pdf, Click Convert to Audio, Listen to Audio on the App",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 300.0,
                          height: 100.0,
                          child: ElevatedButton(
                            onPressed: () {
                              getFile();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            child: const Text(
                              'Import PDF',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text('Maximum Filesize: 5MB'),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _file != null
                                      ? "File Name:- "
                                      : "No file is Selected",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.90,
                                  child: Text(
                                    _file != null
                                        ? _file!.path.split("/").last
                                        : "",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _file != null
                                    ? Column(
                                        children: [
                                          SizedBox(
                                            width: 300.0,
                                            height: 100.0,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          "Name Your Audio"),
                                                      content: Form(
                                                        key: _formKey,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            TextFormField(
                                                              decoration:
                                                                  const InputDecoration(
                                                                labelText:
                                                                    'Enter Audio name',
                                                              ),
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter audio name';
                                                                }
                                                                return null;
                                                              },
                                                              onSaved: (value) {
                                                                audioName =
                                                                    value!;
                                                              },
                                                            ),
                                                            const SizedBox(
                                                                height: 20),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                _saveAudioToS3();
                                                              },
                                                              child: const Text(
                                                                  'Done'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                              ),
                                              child: const Text(
                                                'Convert Now',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

      
    




// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   static const routeName = '/home';

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   late ConversionModel _conversionModel;

//   // ignore: unused_field
//   var _isInit = true;
//   // ignore: unused_field
//   var _isLoading = false;
//   File? _file;
//   String audioName = '';
//   // final int bookId;
//   getFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null) {
//       final file = File(result.files.single.path!);
//       _file = file;
//       setState(() {});
//     } else {
//       // User canceled the picker
//       // You can show snackbar or fluttertoast
//       // here like this to show warning to user
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Please select file'),
//       ));
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _conversionModel = Provider.of<ConversionModel>(context, listen: false);
//   }

//   void _saveAudioToS3() async {
//     print("First: $audioName");
//     Navigator.pop(context);

//     final isValid = _formKey.currentState!.validate();
//     if (!isValid) {
//       return;
//     }
//     _formKey.currentState!.save();

//     setState(() {
//       _isLoading = true;
//     });

//     print("audioName: $audioName");
//     try {
//       _conversionModel.startConverting();
//       // Navigate to the ConvertingScreen
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const ConvertingScreen()),
//       );
//       final authData = Provider.of<Auth>(context, listen: false);
//       int bookId = await Provider.of<Books>(context, listen: false)
//           .addBook(_file, authData.token);
//       print("book_id: ${bookId}");
//       print("token: ${authData.token}");

//       // Add audio after book is uploaded
//       await Provider.of<Audios>(context, listen: false)
//           .addAudio(bookId, audioName, authData.token);

//       // Navigate back after conversion
//       Navigator.pop(context);
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const HomeScreen()),
//       );
//       _conversionModel.completeConverting();
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("An error : $error"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       setState(() {
//         _isLoading = false;
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text('Audify'),
//       ),
//       drawer: AppDrawer(),
//       body: Consumer<ConversionModel>(
//         builder: (context, model, _) {
//           if (model.status == ConversionStatus.converting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             return SingleChildScrollView(
//               child: Column(
//         children: [
//           const SizedBox(
//             height: 30,
//           ),
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 Container(
//                   padding: const EdgeInsets.all(50),
//                   child: const Column(children: [
//                     Text(
//                       "Convert PDF to Audio",
//                       style: TextStyle(
//                           color: Color.fromARGB(255, 52, 51, 51),
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Text(
//                       "3 simple steps:",
//                       style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       "Import pdf, Click Convert to Audio, Listen to Audio on the App",
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 16,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ]),
//                 ),
//                 SizedBox(
//                   width: 300.0,
//                   height: 100.0,
//                   child: ElevatedButton(
//                       onPressed: () {
//                         getFile();
//                       },
//                       style: TextButton.styleFrom(
//                           backgroundColor: Theme.of(context).primaryColor),
//                       child: const Text(
//                         'Import PDF',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold),
//                       )),
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 const Text(
//                   'Maximum Filesize: 5MB',
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           _file != null
//                               ? "File Name:- "
//                               : "No file is Selected",
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                               color: Colors.black, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(_file != null ? _file!.path.split("/").last : "",
//                             // To show name of file selected
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                               color: Colors.black,
//                             )),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         _file != null
//                             ? Column(
//                                 children: [
//                                   SizedBox(
//                                     width: 300.0,
//                                     height: 100.0,
//                                     child: ElevatedButton(
//                                         // onPressed: () => Navigator.of(context)
//                                         //     .pushReplacementNamed(
//                                         //         ConvertingScreen.routeName),
//                                         onPressed: () {
//                                           // _saveBookToS3();
//                                           showDialog(
//                                             context: context,
//                                             builder: (BuildContext context) {
//                                               return AlertDialog(
//                                                 title: const Text(
//                                                     "Name Your Audio"),
//                                                 content: Form(
//                                                   key: _formKey,
//                                                   child: Column(
//                                                     mainAxisSize:
//                                                         MainAxisSize.min,
//                                                     children: [
//                                                       TextFormField(
//                                                         decoration:
//                                                             const InputDecoration(
//                                                           labelText:
//                                                               'Enter Audio name',
//                                                         ),
//                                                         validator: (value) {
//                                                           if (value == null ||
//                                                               value.isEmpty) {
//                                                             return 'Please enter audio name';
//                                                           }
//                                                           return null; // Return null if the field is valid
//                                                         },
//                                                         onSaved: (value) {
//                                                           audioName = value!;
//                                                           // print(audioName);
//                                                         },
//                                                       ),
//                                                       const SizedBox(
//                                                           height: 20),
//                                                       ElevatedButton(
//                                                         onPressed: () {
//                                                           //                                                    Navigator.push(
//                                                           //   context,
//                                                           //   MaterialPageRoute(builder: (context) => const ConvertingScreen())
//                                                           // );
//                                                           _saveAudioToS3();
//                                                         },
//                                                         child:
//                                                             const Text('Done'),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                           );
//                                         },
//                                         style: TextButton.styleFrom(
//                                             backgroundColor:
//                                                 Theme.of(context).primaryColor),
//                                         child: const Text(
//                                           'Convert Now',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 22,
//                                               fontWeight: FontWeight.bold),
//                                         )),
//                                   ),
//                                 ],
//                               )
//                             : Container(), // or any other placeholder widget
//                       ],
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ],)
//       ),
//     );
//   }
// }

// import 'package:audio_book_app/screens/convertin_screen.dart';
// import 'package:audio_book_app/widgets/app_drawer.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:io';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   static const routeName = '/home';

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   File? _file;

//   Future<void> getFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null) {
//       final file = File(result.files.single.path!);
//       setState(() {
//         _file = file;
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Please select file'),
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.secondary,
//         title: const Text('Audify'),
//       ),
//       drawer: AppDrawer(),
//       body: Column(
//         children: [
//           const SizedBox(height: 30),
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 Container(
//                   padding: const EdgeInsets.all(50),
//                   child: const Column(
//                     children: [
//                       Text(
//                         "Convert PDF to Audio",
//                         style: TextStyle(
//                           color: Color.fromARGB(255, 52, 51, 51),
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         "3 simple steps:",
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         "Import pdf, Click Convert to Audio, Listen to Audio on the App",
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 16,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   width: 300.0,
//                   height: 100.0,
//                   child: ElevatedButton(
//                     onPressed: getFile,
//                     style: TextButton.styleFrom(
//                       backgroundColor: Theme.of(context).primaryColor,
//                     ),
//                     child: const Text(
//                       'Import PDF',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 const Text('Maximum Filesize: 5MB'),
//                 if (_file != null) ...[
//                   Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "File Name:- ${_file!.path.split("/").last}",
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Column(
//                             children: [
//                               const Text("Name Audio File: "),
//                               TextField(
//                                 decoration: InputDecoration(
//                                   border: OutlineInputBorder(),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 300.0,
//                                 height: 100.0,
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pushReplacementNamed(
//                                       ConvertingScreen.routeName,
//                                     );
//                                   },
//                                   style: TextButton.styleFrom(
//                                     backgroundColor:
//                                         Theme.of(context).primaryColor,
//                                   ),
//                                   child: const Text(
//                                     'Convert Now',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
