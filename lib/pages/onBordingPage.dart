// import 'package:app/pages/homePage.dart';
// import 'package:flutter/material.dart';
// import 'package:app/utils/common.dart';

// class Onbordingpage extends StatelessWidget {
//   const Onbordingpage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xff6791FF),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(
//             child: ClipOval(
//               child: Container(
//                 width: 320,
//                 height: 320,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage('images/doctor.png'),
//                     fit: BoxFit.cover,
//                     alignment: Alignment.topCenter,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 40, top: 15, right: 40),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "let's \nconsult the \nbest doctor",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 35,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Gap(10, 10),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Skip",
//                         style: TextStyle(color: Colors.white70, fontSize: 16),
//                       ),
//                       Row(
//                         children: [
//                           Icon(Icons.circle, size: 8, color: Colors.white38),
//                           Gap(0, 6),
//                           Icon(Icons.circle, size: 8, color: Colors.white),
//                           Gap(0, 6),
//                           Icon(Icons.circle, size: 8, color: Colors.white38),
//                         ],
//                       ),
//                       Transform.rotate(
//                         angle: 0.785398,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const HomePage(),
//                               )
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             padding: EdgeInsets.zero,
//                             elevation: 4,
//                             fixedSize: Size(60, 60),
//                             shadowColor: Colors.black26,
//                           ),
//                           child: Transform.rotate(
//                             angle: -0.785398,
//                             child: Text(
//                               "Go",
//                               style: TextStyle(
//                                 color: Colors.orangeAccent,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/pages/homePage.dart';
import 'package:app/pages/signUpPage.dart';
import 'package:app/utils/common.dart';

class Onbordingpage extends StatelessWidget {
  const Onbordingpage({super.key});

  Future<void> checkLoginStatus(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUpPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff6791FF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ClipOval(
              child: Container(
                width: 320,
                height: 320,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/doctor.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 15, right: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Let's \nconsult the \nbest doctor",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(10, 10),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Skip",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.circle, size: 8, color: Colors.white38),
                          Gap(0, 6),
                          const Icon(Icons.circle, size: 8, color: Colors.white),
                          Gap(0, 6),
                          const Icon(Icons.circle, size: 8, color: Colors.white38),
                        ],
                      ),
                      Transform.rotate(
                        angle: 0.785398, // 45 degrees
                        child: ElevatedButton(
                          onPressed: () => checkLoginStatus(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.zero,
                            elevation: 4,
                            fixedSize: const Size(60, 60),
                            shadowColor: Colors.black26,
                          ),
                          child: Transform.rotate(
                            angle: -0.785398,
                            child: const Text(
                              "Go",
                              style: TextStyle(
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
