import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:anne/utility/graphQl.dart';
import 'package:anne/view_model/auth_view_model.dart';
import 'package:anne/view/cart_logo.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  TextEditingController _phone = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _fName = TextEditingController();
  TextEditingController _lName = TextEditingController();
  String selectedGender = "Male";

  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

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
          title: Center(
              // width: MediaQuery.of(context).size.width * 0.39,
              child: Text(
            "User Profile",
            style: TextStyle(
                color: Color(0xff616161),
                fontSize: ScreenUtil().setSp(
                  21,
                )),
            textAlign: TextAlign.center,
          )),
          actions: [
            Container(
                padding: EdgeInsets.only(right: 10.0),
                // width: MediaQuery.of(context).size.width * 0.35,
                child: CartLogo())
          ],
        ),
        body: GraphQLProvider(
            client: graphQLConfiguration.initailizeClient(),
            child: CacheProvider(
                child: Container(
                    color: Color(0xfff5f5f5),
                    height: MediaQuery.of(context).size.height,
                    child: Consumer<ProfileModel>(
                        builder: (BuildContext context, value, Widget child) {
                      return SingleChildScrollView(
                          child: Material(
                              color: Color(0xfff3f3f3),
                              // borderRadius: BorderRadius.circular(2),
                              child: Card(
                                  margin: EdgeInsets.fromLTRB(
                                      ScreenUtil().setWidth(21),
                                      ScreenUtil().setWidth(24),
                                      ScreenUtil().setWidth(22),
                                      ScreenUtil().setWidth(26)),
                                  elevation: 2,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        ScreenUtil().setWidth(14),
                                        ScreenUtil().setWidth(38),
                                        ScreenUtil().setWidth(13),
                                        ScreenUtil().setWidth(45)),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                            child: TextFormField(
                                          controller: _phone,
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              contentPadding: EdgeInsets.all(
                                                  ScreenUtil().setWidth(12)),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0),
                                              ),
                                              labelText: "Phone",
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
                                          controller: _fName,
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              contentPadding: EdgeInsets.all(
                                                  ScreenUtil().setWidth(12)),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0),
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
                                              contentPadding: EdgeInsets.all(
                                                  ScreenUtil().setWidth(12)),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0),
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
                                              contentPadding: EdgeInsets.all(
                                                  ScreenUtil().setWidth(12)),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0),
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
                                                fontSize:
                                                    ScreenUtil().setSp(12)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: ScreenUtil().setWidth(11),
                                        ),
                                        Container(
                                            padding: EdgeInsets.only(
                                                left:
                                                    ScreenUtil().setWidth(22)),
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
                                                          fontSize: ScreenUtil()
                                                              .setSp(15),
                                                          color: Color(
                                                              0xff5f5f5f)),
                                                    )),
                                                icon("Female"),
                                                InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedGender =
                                                            "Female";
                                                      });
                                                    },
                                                    child: Text(
                                                      ' Female    ',
                                                      style: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(15),
                                                          color: Color(
                                                              0xff5f5f5f)),
                                                    )),
                                                icon("Others"),
                                                InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedGender =
                                                            "Others";
                                                      });
                                                    },
                                                    child: Text(
                                                      ' Others',
                                                      style: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(15),
                                                          color: Color(
                                                              0xff5f5f5f)),
                                                    ))
                                              ],
                                            )),
                                        SizedBox(
                                          height: ScreenUtil().setWidth(43),
                                        ),
                                        Container(
                                          width: ScreenUtil().setWidth(344),
                                          height: ScreenUtil().setWidth(40),
                                          child: RaisedButton(
                                            padding: EdgeInsets.fromLTRB(
                                                0,
                                                ScreenUtil().setWidth(12),
                                                0,
                                                ScreenUtil().setWidth(10)),
                                            onPressed: () async {
                                              await Provider.of<ProfileModel>(
                                                      context,
                                                      listen: false)
                                                  .editProfile(
                                                      _phone.text,
                                                      _fName.text,
                                                      _lName.text,
                                                      _email.text,
                                                      selectedGender);
                                              await Provider.of<ProfileModel>(
                                                      context,
                                                      listen: false)
                                                  .getProfile();
                                            },
                                            color: Colors.blue,
                                            child: Text(
                                              "ADD ADDRESS",
                                              style: TextStyle(
                                                  fontSize: ScreenUtil().setSp(
                                                    18,
                                                  ),
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))));
                    })))));
  }

  icon(String s) {
    if (s == selectedGender) {
      return Icon(
        Icons.panorama_fish_eye,
        color: Colors.blue,
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
