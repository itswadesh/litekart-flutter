// import 'package:flutter/material.dart';
// import 'package:pankhuri/service/preload_data/videos_provider.dart';
// import 'package:pankhuri/values/colors.dart';
// import 'package:pankhuri/view_model/notification_view_model.dart';
// import 'package:provider/provider.dart';
//
// class PushNotificationDialog extends StatelessWidget {
//   final screen, chatId, userProfile, magazine, source, interactionType;
//
//   PushNotificationDialog(this.screen, this.chatId, this.userProfile,
//       this.magazine, this.source, this.interactionType);
//
//   @override
//   Widget build(BuildContext context) {
//     VideosProvider videosProvider = Provider.of<VideosProvider>(context);
//     /*if (source == 'product') {
//       videosProvider.currentVideo = int.parse(id);
//     }*/
//     return Scaffold(
//       body: ChangeNotifierProvider(
//         create: (BuildContext context) => NotificationViewModel(screen, chatId,
//             userProfile, magazine, source, interactionType, videosProvider),
//         child: Consumer<NotificationViewModel>(
//           builder: (context, model, child) => getProgress(model),
//         ),
//       ),
//     );
//   }
// }
//
// Widget getProgress(NotificationViewModel model) {
//   return model.loading
//       ? Center(
//           child: Container(
//             child: CircularProgressIndicator(
//               valueColor:
//                   new AlwaysStoppedAnimation<Color>(AppColors.secondaryElement),
//             ),
//           ),
//         )
//       : Container();
// }
