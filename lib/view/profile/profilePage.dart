// import 'package:flutter/material.dart';
//
//
// import 'package:provider/provider.dart';
// import '../../view_model/auth_view_model.dart';
//
// import '../../utility/theme.dart';
//
// class ProfilePage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _ProfilePage();
//   }
// }
//
// class _ProfilePage extends State<ProfilePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Stack(
//       children: [
//         Consumer<ProfileModel>(builder: (context, user, child) {
//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 Stack(children: [
//                   Container(
//                     child: Column(children: [
//                       SizedBox(
//                         height: 30,
//                       ),
//                       Container(
//                           margin: EdgeInsets.only(left: 18),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text("\n\n ${user.user.firstName ?? "User"}",
//                                   style: ThemeApp().heading2Theme(),
//                                   textAlign: TextAlign.left),
//                               Column(
//                                 children: [
//                                   _getImage(user.user.avatar),
//                                   Text(
//                                     '${user.user.phone}',
//                                     style: ThemeApp().textThemeSemiGrey(),
//                                   )
//                                 ],
//                               )
//                             ],
//                           ))
//                     ]),
//                   )
//                 ]),
//                 SizedBox(
//                   height: 10,
//                 ),
//
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Divider(
//                   height: 2,
//                   color: Colors.grey,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                     margin: EdgeInsets.only(left: 18, right: 18),
//                     child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Profile Details",
//                             style: ThemeApp().heading5SemiTheme(),
//                             textAlign: TextAlign.left,
//                           ),
//                           InkWell(
//                               onTap: () {},
//                               child: Icon(
//                                 Icons.edit,
//                                 color: Colors.deepPurpleAccent,
//                                 size: 18,
//                               ))
//                         ])),
//
//                 ListTile(
//                   title: TextFormField(
//                     initialValue: user.user.firstName ?? "",
//                     readOnly: true,
//                     validator: (value) {
//                       if (value.isEmpty) {
//                         return 'Required';
//                       }
//                       return null;
//                     },
//                     style: ThemeApp().textThemeGrey(),
//                   ),
//                   leading: Icon(
//                     Icons.perm_identity,
//                     color: Colors.deepPurpleAccent,
//                   ),
//                 ),
//                 ListTile(
//                   title: TextFormField(
//                     initialValue: user.user.email ?? "",
//                     readOnly: true,
//                     validator: (value) {
//                       if (value.isEmpty) {
//                         return 'Required';
//                       }
//                       return null;
//                     },
//                     style: ThemeApp().textThemeGrey(),
//                   ),
//                   leading: Icon(
//                     Icons.email,
//                     color: Colors.redAccent,
//                   ),
//                 ),
//                 ListTile(
//                     title: TextFormField(
//                       initialValue: user.user.address[0].address ?? "",
//                       readOnly: true,
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Required';
//                         }
//                         return null;
//                       },
//                       style: ThemeApp().textThemeGrey(),
//                     ),
//                     leading: KoukiconsLocation(
//                       height: 22,
//                     )
//
//                     //Icon(Icons.location_on, color: Colors.deepPurpleAccent,),
//                     ),
//                 ListTile(
//                   title: TextFormField(
//                     initialValue: user.user.gender ?? "",
//                     readOnly: true,
//                     validator: (value) {
//                       if (value.isEmpty) {
//                         return 'Required';
//                       }
//                       return null;
//                     },
//                     style: ThemeApp().textThemeGrey(),
//                   ),
//                   leading: Icon(
//                     Icons.code,
//                     color: Colors.redAccent,
//                   ),
//                   //Icon(Icons.cake, color: Colors.deepPurpleAccent,),
//                 ),
//                 // ListTile(
//                 //   title: TextFormField(
//                 //     readOnly: true,
//                 //     validator: (value) {
//                 //       if (value.isEmpty) {
//                 //         return 'Required';
//                 //       }
//                 //       return null;
//                 //     },
//                 //     style: ThemeApp().textThemeGrey(),
//                 //     controller: _birthday,
//                 //
//                 //   ),
//                 //   leading:
//                 //       KoukiconsGift(
//                 //         height: 22,
//                 //       )
//                 //
//                 //   //Icon(Icons.cake, color: Colors.deepPurpleAccent,),
//                 // ),
//                 ListTile(
//                   title: InkWell(
//                     child: Text(
//                       "Sign Out",
//                       style: ThemeApp().textThemeGrey(),
//                     ),
//                   ),
//                   leading:
//                       // KoukiconsGift(
//                       //   height: 22,
//                       // )
//
//                       Icon(
//                     Icons.settings_power,
//                     color: Colors.indigo,
//                   ),
//                 ),
//
//                 SizedBox(
//                   height: 10,
//                 )
//               ],
//             ),
//           );
//         }),
//       ],
//     ));
//   }
//
//   _getImage(avatar) {
//     return Container(
//         margin: EdgeInsets.all(12),
//         child: Column(children: <Widget>[
//           avatar != null
//               ? Container(
//                   decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       image: new DecorationImage(
//                           fit: BoxFit.fill, image: NetworkImage(avatar))),
//                   width: 100.0,
//                   height: 100.0,
//                   // child: new Image.file(
//                   //   _image,
//                   //   width: 100,
//                   //   height: 100,
//                   // )
//                 )
//               : Container(
//                   width: 100.0,
//                   height: 100.0,
//                   decoration: new BoxDecoration(
//                       shape: BoxShape.circle,
//                       image: new DecorationImage(
//                           fit: BoxFit.fill,
//                           image: new AssetImage("assets/images/user.png")))),
//         ]));
//   }
// }
