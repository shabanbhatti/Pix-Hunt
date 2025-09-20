// import 'dart:async';


// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pix_hunt_project/Controllers/on%20sync%20after%20email%20verify%20riverpod/on_sync_after_email_verify.dart';
// import 'package:pix_hunt_project/Pages/Login%20Page/login_page.dart';
// import 'package:pix_hunt_project/main.dart';
// import 'package:pix_hunt_project/repository/auth%20repositoy/auth_provider_objects.dart';
// import 'package:pix_hunt_project/services/shared_preference_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<void> showEmailVerificationDialog(BuildContext context, String updatedEmail)async {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (dialogContext) {
//       return Consumer(
//         builder: (context, ref, _) {
//           Timer? timer;
//           var authRepo= ref.read(authRepositoryProviderObject);
//           timer = Timer.periodic(Duration(seconds: 4), (timer) async {
//             try {

//               var user= await authRepo.getCurrentuserWithReload();
              

//               if (user != null &&
//                   user.emailVerified &&
//                   user.email == updatedEmail) {
//                 timer.cancel();

//                 if (dialogContext.mounted) {
//                   Navigator.of(dialogContext).pop();
//                 }

//                 await ref
//                     .read(onSyncAfterEmailVerifyProvider.notifier)
//                     .syncEmailAfterVerification();
//               }
//             }  catch (e) {
//               if (e == 'user-token-expired') {
//                 timer.cancel();

//                 if (dialogContext.mounted) {
//                   Navigator.of(dialogContext).pop();
//                 }

//                 if (context.mounted) {
//                   showDialog(
//                     context: context,
//                     builder:
//                         (_) => AlertDialog(
//                           title: Text('Email Verified'),
//                           content: Text(
//                             'Please login again to continue with new Email.',
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () async {
//                                 try {
                                  
                                      
//                                   await authRepo.signOut();
                                  
//                                     await SpService.setBool('logged', false);

//           Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil(
//                                 LoginPage.pageName,
//                                 (route) => false,
//                               );
        
                                  
//                                 } catch (e) {
//                                   print(
//                                     '${e.toString()}-------------------------',
//                                   );
//                                 }
//                               },
//                               child: Text('OK'),
//                             ),
//                           ],
//                         ),
//                   );
//                 }
//               } else {
//                 print('Unhandled error: $e');
//               }
//             }
//           });

//           return PopScope(
//             onPopInvokedWithResult: (didPop, result) {
//               timer?.cancel();
//             },
//             child: Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     CupertinoActivityIndicator(radius: 16),
//                     SizedBox(height: 20),
//                     Text(
//                       'Verification link has been sent to $updatedEmail in the spam folder.',
//                       style: TextStyle(
//                         color: Colors.green,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }
