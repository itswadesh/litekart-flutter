

import 'package:anne/components/widgets/loading.dart';
import 'package:anne/response_handler/channelResponse.dart';
import 'package:anne/values/colors.dart';
import 'package:anne/view_model/channel_view_model.dart';
import 'package:anne/view_model/settings_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LiveCommercePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LiveCommerceState();
  }

}

class _LiveCommerceState extends State<LiveCommercePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
        children: [
          SingleChildScrollView(
            child:  Column(
              children: [
                Container(
                    color: AppColors.primaryElement,
                    width: double.infinity,
                    height: ScreenUtil().setWidth(200)
                ),
        Transform.translate(offset: Offset(0,ScreenUtil().setWidth(-40)),
          child: Column(children :[
                Container(
                  height: ScreenUtil().setWidth(400),
                  child: StreamList(),)
            ])),
            ]),
          ),
          Align(
            alignment: Alignment.topCenter,
            child : Container(
              color: AppColors.primaryElement,
              width: double.infinity,
              height: ScreenUtil().setWidth(100)
            )
          )
        ],
      ),),
    );
  }
}

class StreamList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StreamList();
  }
}

class _StreamList extends State<StreamList>{
  @override
  Widget build(BuildContext context) {
    return Consumer<ChannelViewModel>(
        builder: (BuildContext context, value, Widget child) {
      if (value.status == "loading") {
        Provider.of<ChannelViewModel>(context, listen: false)
            .fetchChannelData("","","","","","","");
        if(Provider.of<SettingViewModel>(context).status=="loading"||Provider.of<SettingViewModel>(context).status=="error"){
          Provider.of<SettingViewModel>(context,
            listen: false)
            .fetchSettings();
        }
        return Loading();
      } else if (value.status == "empty") {
        return SizedBox.shrink();
      } else if (value.status == "error") {
        return SizedBox.shrink();
      } else {
    return Container(
      height: ScreenUtil().setWidth(400),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: value.channelResponse.data.length,
          itemBuilder: (BuildContext context, index){
          return StreamCard(value.channelResponse.data[index]);
      }),
    );}});
  }
}

class StreamCard extends StatelessWidget{
  final ChannelData channelData;
  StreamCard(this.channelData);
  @override
  Widget build(BuildContext context) {
   return Container(
     height: ScreenUtil().setWidth(400),
     width: ScreenUtil().setWidth(250),
     padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
     decoration: BoxDecoration(
       border: Border.all(color: AppColors.primaryElement2,width: 5),
       borderRadius: BorderRadius.circular(ScreenUtil().radius(25),),
     image: DecorationImage(
         image: NetworkImage(channelData.img)
     ),
     ),

   );
  }

}