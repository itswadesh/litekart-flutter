// import 'package:flutter/material.dart';
// import '../../utility/theme.dart';
// import '../home.dart';
// import '../order_history.dart';
// import 'accountDrawer.dart';
//
// class AccountPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _AccountPage();
//   }
// }
//
// class _AccountPage extends State<AccountPage> {
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: AppBar(
//           backgroundColor: Colors.white,
//           automaticallyImplyLeading: false,
//           title: Container(
//             child: ListTile(
//                 leading: Transform.translate(
//                   offset: const Offset(-15.0, 0.0),
//                   child: InkWell(
//                     onTap: () => scaffoldKey.currentState.openDrawer(),
//                     child: Container(
//                         child: Icon(
//                       Icons.menu,
//                       color: Colors.black54,
//                     )),
//                   ),
//                 ),
//                 title: Text(
//                   "Account",
//                   style: ThemeApp().heading5BoldThemeGrey(),
//                   textAlign: TextAlign.center,
//                 ),
//                 trailing: Transform.translate(
//                     offset: const Offset(15.0, 0.0),
//                     child: Icon(
//                       Icons.shopping_cart,
//                       size: 24,
//                       color: Colors.black54,
//                     ))),
//           )),
//       drawer: AccountDrawer(),
//       body: Container(
//         color: Color(0xfff5f5f5),
//         height: MediaQuery.of(context).size.height,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                   width: double.infinity,
//                   margin: EdgeInsets.fromLTRB(15, 15, 15, 30),
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.of(context).pushReplacement(
//                           MaterialPageRoute(builder: (context) => Home()));
//                     },
//                     child: Text(
//                       "Back to Home",
//                       style: TextStyle(
//                           decoration: TextDecoration.underline,
//                           color: Colors.blue,
//                           fontSize: 13),
//                       textAlign: TextAlign.start,
//                     ),
//                   )),
//               Container(
//                 child: Card(
//                   elevation: 0,
//                   margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
//                   child: Container(
//                     child: ListTile(
//                       title: Text(
//                         "Complete your profile information and get two gift cards",
//                         style:
//                             TextStyle(color: Color(0xffee7625), fontSize: 13),
//                       ),
//                       trailing: InkWell(
//                         child: Container(
//                             decoration: BoxDecoration(
//                                 color: Colors.grey,
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(10))),
//                             child: Icon(
//                               Icons.close,
//                               size: 18,
//                               color: Colors.white,
//                             )),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               getProfileCard(
//                   icon: Icons.lock_open,
//                   title: "Login Settings",
//                   subtitle:
//                       "\nEdit login details, password setup , edit first and last name , number",
//                   onTap: () {}),
//               getProfileCard(
//                   icon: Icons.archive,
//                   title: "Your Orders",
//                   subtitle:
//                       "\nAll orders, tracking orders, return items, manage orders",
//                   onTap: () {
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => OrderHistory()));
//                   }),
//               getProfileCard(
//                   icon: Icons.payments_outlined,
//                   title: "Payments",
//                   subtitle:
//                       "\nEdit login details, password setup , edit first and last name , number",
//                   onTap: () {}),
//               getProfileCard(
//                   icon: Icons.shopping_bag,
//                   title: "Gift Cards",
//                   subtitle:
//                       "\nManage gift cards, use cards, Redeem and refer to earn ",
//                   onTap: () {}),
//               getProfileCard(
//                   icon: Icons.credit_card,
//                   title: "Tablez Rewards",
//                   subtitle:
//                       "\nManage you earn points, redeem, share, refer to earn points",
//                   onTap: () {}),
//               getProfileCard(
//                   icon: Icons.notifications,
//                   title: "Notifications",
//                   subtitle: "\nManage , delete , schedule your notifications",
//                   onTap: () {}),
//               Card(
//                 elevation: 0,
//                 margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
//                 child: Container(
//                   padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
//                   child: Column(
//                     children: [
//                       Container(
//                         width: double.infinity,
//                         child: Text(
//                           "FAQ's",
//                           style: ThemeApp().heading5BoldThemeGrey(),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Container(
//                         width: double.infinity,
//                         child: Text(
//                             "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book.",
//                             style: TextStyle(color: Colors.grey, fontSize: 15)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               Container(
//                 padding: EdgeInsets.all(20),
//                 width: double.infinity,
//                 color: Color(0xffba8638),
//                 child: Text(
//                   "© 2020 Tablez India Private Limited",
//                   style: TextStyle(color: Colors.white),
//                   textAlign: TextAlign.center,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   getProfileCard(
//       {IconData icon,
//       String title,
//       String subtitle,
//       GestureTapCallback onTap}) {
//     return Card(
//       elevation: 0,
//       margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
//       child: Container(
//         padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
//         child: ListTile(
//           onTap: onTap,
//           leading: Icon(
//             icon,
//             color: Color(0xffba8638),
//             size: 70,
//           ),
//           title: Text(
//             title,
//             style: TextStyle(color: Color(0xffba8638), fontSize: 25),
//           ),
//           subtitle: Text(subtitle),
//         ),
//       ),
//     );
//   }
// }
