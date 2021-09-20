import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../../components/base/tz_dialog.dart';
import '../../enum/tz_dialog_type.dart';
import '../../utility/graphQl.dart';
import '../../values/colors.dart';
import '../../view_model/auth_view_model.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  TextEditingController _phone = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _fName = TextEditingController();
  TextEditingController _lName = TextEditingController();
  String selectedGender = "Male";

  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  File _image;
  final picker = ImagePicker();
  var image;
  _pickImageFromGallery() async {
    image =
    await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  @override
  void initState() {
    if (Provider.of<ProfileModel>(context, listen: false).user == null) {
      Provider.of<ProfileModel>(context, listen: false).getProfile();
    }
    _phone.text =
        Provider.of<ProfileModel>(context, listen: false).user.phone ?? "";
    _email.text =
        Provider.of<ProfileModel>(context, listen: false).user.email ?? "";
    _fName.text =
        Provider.of<ProfileModel>(context, listen: false).user.firstName ?? "";
    _lName.text =
        Provider.of<ProfileModel>(context, listen: false).user.lastName ?? "";
    selectedGender =
        Provider.of<ProfileModel>(context, listen: false).user.gender ??
            selectedGender;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black54,
            ),
          ),
          title:  Text(
            "Edit Profile",
            style: TextStyle(
                color: Color(0xff616161),
                fontSize: ScreenUtil().setSp(
                  21,
                )),
            textAlign: TextAlign.center,
          ),

        ),
        body: GraphQLProvider(
            client: graphQLConfiguration.initailizeClient(),
            child: CacheProvider(
                child: Container(
                    color: Color(0xfff5f5f5),
                    height: MediaQuery.of(context).size.height,
                    child: Consumer<ProfileModel>(
                        builder: (BuildContext context, value, Widget child) {
                          return Stack(children: [
                            SingleChildScrollView(
                              child: Container(

                                child:  Column(
                                  children: [
                                  Image.asset("assets/images/backgroundProfile.jpg",width: MediaQuery.of(context).size.width,),
                                Transform.translate(offset: Offset(0,ScreenUtil().setWidth(-60)),
                                  child:
                                  Container(
                                    padding: EdgeInsets.fromLTRB(
                                        ScreenUtil().setWidth(20),
                                        ScreenUtil().setHeight(0),
                                        ScreenUtil().setWidth(20),
                                        ScreenUtil().setHeight(45)),
                                    child:
                                  Column(children:[
                                    _getImage(value.user.avatar),
                                    // InkWell(
                                    //     onTap: (){
                                    //
                                    //     },
                                    //     child:  Container(
                                    //       height: ScreenUtil().setWidth(120),
                                    //       width: ScreenUtil().setWidth(120),
                                    //       child: Card(
                                    //         child: Container(
                                    //             height: ScreenUtil().setWidth(120),
                                    //             width: ScreenUtil().setWidth(120),
                                    //             child: value.user.avatar!=null? Image.network(value.user.avatar):Image.asset("assets/images/user.png")
                                    //         ),
                                    //       ),)),
                                    SizedBox(height: ScreenUtil().setWidth(20),),
                                    Container(
                                        child: TextFormField(
                                          readOnly: true,
                                          controller: _phone,
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              contentPadding:
                                              EdgeInsets.all(ScreenUtil().setWidth(12)),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.transparent, width: 0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.transparent, width: 0),
                                              ),
                                              // hintText: "Phone",
                                              // hintStyle: TextStyle(
                                              //     color: Colors.grey,
                                              //     fontSize: ScreenUtil().setSp(
                                              //       15,
                                              //     ))
                                          ),
                                        )),
                                    SizedBox(
                                      height: ScreenUtil().setWidth(25),
                                    ),
                                    Container(
                                        child: TextFormField(
                                          controller: _fName,
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              contentPadding:
                                              EdgeInsets.all(ScreenUtil().setWidth(12)),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey, width: 1.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey, width: 1.0),
                                              ),
                                              labelText: "First Name",
                                              labelStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: ScreenUtil().setSp(
                                                    15,
                                                  ))),
                                        )),
                                    SizedBox(
                                      height: ScreenUtil().setWidth(25),
                                    ),
                                    Container(
                                        child: TextFormField(
                                          controller: _lName,
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              contentPadding:
                                              EdgeInsets.all(ScreenUtil().setWidth(12)),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey, width: 1.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey, width: 1.0),
                                              ),
                                              labelText: "Last Name",
                                              labelStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: ScreenUtil().setSp(
                                                    15,
                                                  ))),
                                        )),
                                    SizedBox(
                                      height: ScreenUtil().setWidth(25),
                                    ),
                                    Container(
                                        child: TextFormField(
                                          controller: _email,
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              contentPadding:
                                              EdgeInsets.all(ScreenUtil().setWidth(12)),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey, width: 1.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey, width: 1.0),
                                              ),
                                              labelText: "Email",
                                              labelStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: ScreenUtil().setSp(
                                                    15,
                                                  ))),
                                        )),
                                    SizedBox(
                                      height: ScreenUtil().setWidth(22),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(22)),
                                      child: Text(
                                        "Gender",
                                        style: TextStyle(
                                            color: Color(0xffb0b0b0),
                                            fontSize: ScreenUtil().setSp(12)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setWidth(11),
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(22)),
                                        child: Row(
                                          children: [
                                            icon("Male"),
                                            InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedGender = "Male";
                                                  });
                                                },
                                                child: Text(
                                                  ' Male    ',
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil().setSp(15),
                                                      color: Color(0xff5f5f5f)),
                                                )),
                                            icon("Female"),
                                            InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedGender = "Female";
                                                  });
                                                },
                                                child: Text(
                                                  ' Female    ',
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil().setSp(15),
                                                      color: Color(0xff5f5f5f)),
                                                )),
                                            icon("Others"),
                                            InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedGender = "Others";
                                                  });
                                                },
                                                child: Text(
                                                  ' Others',
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil().setSp(15),
                                                      color: Color(0xff5f5f5f)),
                                                ))
                                          ],
                                        )),
                                    SizedBox(
                                      height: ScreenUtil().setWidth(43),
                                    ),

                                  ],
                                ),
                              ))
                              ])
                              )),
                            
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: InkWell(
                                onTap: () async {
                                  TzDialog _dialog =
                                  TzDialog(context, TzDialogType.progress);
                                  _dialog.show();
                                  await Provider.of<ProfileModel>(context,
                                      listen: false)
                                      .editProfile(
                                      _phone.text,
                                      _fName.text,
                                      _lName.text,
                                      _email.text,
                                      selectedGender,_image);
                                  if(value.editStatus) {
                                    await Provider.of<ProfileModel>(context,
                                        listen: false)
                                        .getProfile();
                                    _dialog.close();
                                    final snackBar = SnackBar(
                                        content: Text(
                                            'Profile Updated Successfully !!'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                  else{
                                    _dialog.close();
                                    final snackBar = SnackBar(
                                        content: Text(
                                            'Profile Not Updated. Please Try Again !!'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(8)),
                                    width: double.infinity,
                                    color: Color(0xffffffff),
                                    child: Container(
                                  margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(8),left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
                                  height: 43,
                                  width: MediaQuery.of(context).size.width * 0.80,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryElement,
                                    // border: Border.all(
                                    //     color: AppColors.primaryElement,
                                    //     width: 1),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Update Profile",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xffffffff),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                            )
                          ]);
                        })))));
  }

  _getImage(avatar) {
    return Container(
        margin: EdgeInsets.all(12),
        child: Column(children: <Widget>[
          _image != null
              ? InkWell(
              onTap: () {
                _pickImageFromGallery();
              },
              child: Container(
                  height: ScreenUtil().setWidth(120),
                  width: ScreenUtil().setWidth(120),
                  child: Card(
                      child: Container(
                          height: ScreenUtil().setWidth(120),
                          width: ScreenUtil().setWidth(120),
                          child: Image.file(
                    _image,
                  )))))
              : InkWell(
              onTap: () {
                _pickImageFromGallery();
              },
              child:  Container(
          height: ScreenUtil().setWidth(120),
          width: ScreenUtil().setWidth(120),
          child: Card(
            child: Container(
                height: ScreenUtil().setWidth(120),
                width: ScreenUtil().setWidth(120),
                child: avatar!=null? Image.network(avatar):Image.asset("assets/images/user.png")
            ),
          ),)),
        ]));
  }


  icon(String s) {
    if (s == selectedGender) {
      return Icon(
        Icons.circle,
        color: AppColors.primaryElement,
        size: ScreenUtil().setWidth(18),
      );
    } else {
      return InkWell(
          onTap: () {
            print(s);
            setState(() {
              selectedGender = s;
            });
          },
          child: Icon(
            Icons.panorama_fish_eye,
            color: Colors.grey,
            size: ScreenUtil().setWidth(18),
          ));
    }
  }
}
