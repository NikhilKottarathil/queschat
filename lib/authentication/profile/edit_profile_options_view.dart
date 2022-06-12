// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:queschat/authentication/forgot_password/forgot_password_bloc.dart';
// import 'package:queschat/authentication/forgot_password/forgot_password_view.dart';
// import 'package:queschat/authentication/profile/edit_profile/edit_profile_view.dart';
// import 'package:queschat/authentication/profile/profile_bloc.dart';
// import 'package:queschat/authentication/profile/profile_events.dart';
// import 'package:queschat/authentication/profile/profile_state.dart';
// import 'package:queschat/constants/styles.dart';
// import 'package:queschat/repository/auth_repo.dart';
// import 'package:queschat/router/app_router.dart';
// import 'package:queschat/uicomponents/appbars.dart';
//
// class EditProfileOptionView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create:(context)=> profileBloc,
//       child: Scaffold(
//         appBar: appBarWithBackButton(
//             context: context,
//             titleString: 'Profile',
//             action: () {
//               Navigator.of(context).pop();
//             }),
//         body: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: BlocBuilder<ProfileBloc, ProfileState>(
//             builder: (context, state) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Row(
//                       children: [
//                         CircleAvatar(
//                           radius: MediaQuery.of(context).size.width * .1,
//                           backgroundImage: NetworkImage(
//                               state.imageUrl),
//                           backgroundColor: Colors.transparent,
//                         ),
//                         SizedBox(
//                           width: 16,
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               state.name,
//                               style:
//                                   TextStyles.mediumRegularTextSecondary,
//                             ),
//                             Text(
//                               state.phoneNumber,
//                               style: TextStyles.smallRegularTextTertiary,
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                   dividerDefault,
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'General',
//                           style: TextStyles.smallRegularTextTertiary,
//                         ),
//                         SizedBox(
//                           height: 12,
//                         ),
//                         TextButton(
//                           style: TextButton.styleFrom(
//                             primary: Colors.white,
//                           ),
//                           child: Text(
//                             'Change Profile Picture',
//                             style: TextStyles.smallMediumTextSecondary,
//                           ),
//                           onPressed: () {
//                             profileBloc.add(
//                                 ChangeProfilePicture(context: context));
//                           },
//                         ),
//                         dividerDefault,
//                         TextButton(
//                           style: TextButton.styleFrom(
//                             primary: Colors.white,
//                           ),
//                           child: Text(
//                             'Edit Profile',
//                             style: TextStyles.smallMediumTextSecondary,
//                           ),
//                           onPressed: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (_) => EditProfileView(),
//                               ),
//                             );
//                           },
//                         ),
//                         dividerDefault,
//                         TextButton(
//                           style: TextButton.styleFrom(
//                             primary: Colors.white,
//                           ),
//                           child: Text(
//                             'Manage Password',
//                             style: TextStyles.smallMediumTextSecondary,
//                           ),
//                           onPressed: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (_) => BlocProvider(
//                                     create: (_) => ForgotPasswordBloc(
//                                       authRepo: context.read<AuthRepository>(),
//                                     ),
//                                   child: ForgotPasswordView(),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         dividerDefault,
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
