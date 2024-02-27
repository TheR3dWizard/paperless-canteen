// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
// import 'package:paperless_canteen/providers/foodItem.dart';
// import 'package:provider/provider.dart';

// GoogleSignIn _googleSignIn = GoogleSignIn(
//   scopes: [
//     'email',
//   ],
// );

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   GoogleSignInAccount? _currentUser;
//   String _contactText = '';
//   bool _loadingUser = true;
//   bool _hasUser = false;

//   @override
//   void initState() {
//     super.initState();
//     final foodItemsData = Provider.of<FoodItems>(context, listen: false);
//     final storage = new FlutterSecureStorage();

//     _containsKey();
//     // while (_loadingUser) {
//     // }
//     // print("has user" + _hasUser.toString());
//     // if (_hasUser) {
//     //   Navigator.of(context).pushReplacementNamed('/home');
//     // }

//     // print(_currentUser);
//     // if (_currentUser != null) {
//     //   // _handleGetContact(_currentUser!);
//     //   foodItemsData.saveUser(_currentUser!);
//     //   Navigator.of(context).pushReplacementNamed('/home');
//     // }
//     _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
//       if (foodItemsData.isUserLoggedIn()) {
//         _currentUser = foodItemsData.getUser;
//       } else {
//         _handleSignOut();
//       }
//       setState(() {
//         _currentUser = account;
//       });
//       if (_currentUser != null) {
//         // _handleGetContact(_currentUser!);
//         if (!_currentUser!.email.endsWith("psgtech.ac.in")) {
//           showDialog(
//               context: context,
//               builder: ((context) {
//                 return AlertDialog(
//                   title: Text(
//                     "Invalid Email",
//                   ),
//                   content: Text("Please use your PSG Tech email to login"),
//                   actions: [
//                     TextButton(
//                       child: Text("OK"),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     )
//                   ],
//                 );
//               }));
//           _handleSignOut();
//           _currentUser = null;
//         } else {
//           storage.write(
//               key: "loggedInUserDisplayName", value: _currentUser?.displayName);
//           storage.write(
//               key: "loggedInUserPhotoUrl", value: _currentUser?.photoUrl);
//           storage.write(
//               key: "loggedInUserServerAuthCode",
//               value: _currentUser?.serverAuthCode);
//           storage.write(key: "loggedInUserEmail", value: _currentUser?.email);
//           storage.write(key: "loggedInUserId", value: _currentUser?.id);

//           Navigator.of(context).pushReplacementNamed('/home');
//         }
//       }
//     });
//     _googleSignIn.signInSilently();
//   }

//   Future<void> _containsKey() async {
//     final storage = new FlutterSecureStorage();

//     bool hasUser = await storage.containsKey(key: "loggedInUserEmail");

//     setState(() {
//       _loadingUser = false;
//       _hasUser = hasUser;
//     });
//   }

//   Future<void> _handleGetContact(GoogleSignInAccount user) async {
//     setState(() {
//       _contactText = 'Loading contact info...';
//     });
//     final http.Response response = await http.get(
//       Uri.parse('https://people.googleapis.com/v1/people/me/connections'
//           '?requestMask.includeField=person.names'),
//       headers: await user.authHeaders,
//     );
//     if (response.statusCode != 200) {
//       setState(() {
//         _contactText = 'People API gave a ${response.statusCode} '
//             'response. Check logs for details.';
//       });
//       print('People API ${response.statusCode} response: ${response.body}');
//       return;
//     }
//     final Map<String, dynamic> data =
//         json.decode(response.body) as Map<String, dynamic>;
//     final String? namedContact = _pickFirstNamedContact(data);
//     setState(() {
//       if (namedContact != null) {
//         _contactText = 'I see you know $namedContact!';
//       } else {
//         _contactText = 'No contacts to display.';
//       }
//     });
//   }

//   String? _pickFirstNamedContact(Map<String, dynamic> data) {
//     final List<dynamic>? connections = data['connections'] as List<dynamic>?;
//     final Map<String, dynamic>? contact = connections?.firstWhere(
//       (dynamic contact) => contact['names'] != null,
//       orElse: () => null,
//     ) as Map<String, dynamic>?;
//     if (contact != null) {
//       final Map<String, dynamic>? name = contact['names'].firstWhere(
//         (dynamic name) => name['displayName'] != null,
//         orElse: () => null,
//       ) as Map<String, dynamic>?;
//       if (name != null) {
//         return name['displayName'] as String?;
//       }
//     }
//     return null;
//   }

//   Future<void> _handleSignIn() async {
//     try {
//       await _googleSignIn.signIn();
//     } catch (error) {
//       print(error);
//     }
//   }

//   Future<void> _handleSignOut() => _googleSignIn.disconnect();

//   Widget _buildBody() {
//     final GoogleSignInAccount? user = _currentUser;
//     if (_loadingUser) {
//       return CircularProgressIndicator();
//     } else {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (_hasUser) Navigator.pushReplacementNamed(context, '/home');
//       });
//       return LoginUI();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _buildBody(),
//     );
//   }

//   Container LoginUI() {
//     return Container(
//       color: Colors.white,
//       child: Column(
//         children: [
//           Expanded(
//             child: SizedBox(),
//           ),
//           Expanded(
//             flex: 3,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Image(
//                   image: AssetImage('assets/images/Food_Illustration.png')),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 70),
//               child: Image(
//                   image: AssetImage('assets/images/PaperlessCanteen.png')),
//             ),
//           ),
//           Expanded(
//             child: SizedBox(),
//             flex: 1,
//           ),
//           Expanded(
//               child: Container(
//                 child: Column(children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           height: 67,
//                           margin: EdgeInsets.only(left: 34, right: 14),
//                           child: ElevatedButton(
//                             onPressed: () {},
//                             child: Text(
//                               "Sign In",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.black.withOpacity(0.8),
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(25),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         height: 67,
//                         margin: EdgeInsets.only(right: 34),
//                         child: ElevatedButton(
//                           onPressed: () {
//                             _handleSignIn();
//                           },
//                           child: Image(
//                             image: AssetImage('assets/icons/GoogleIcon.png'),
//                             width: 25,
//                             height: 25,
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.black.withOpacity(0.8),
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(25),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: 34, vertical: 14),
//                     width: double.infinity,
//                     height: 60,
//                     child: ElevatedButton(
//                       onPressed: () {},
//                       child: Text(
//                         "Sign Up",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(21),
//                             side: BorderSide(color: Colors.black, width: 2)),
//                       ),
//                     ),
//                   )
//                 ]),
//               ),
//               flex: 3),
//         ],
//       ),
//     );
//   }
// }
