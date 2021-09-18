import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../view/product_list.dart';
import '../../response_handler/bannerResponse.dart';
import '../../response_handler/brandResponse.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/locator.dart';
import '../../view_model/brand_page_view_model.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class BrandPage extends StatefulWidget {
  final BrandData brand;

  const BrandPage({Key key, @required this.brand}) : super(key: key);

  @override
  _BrandPageState createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  @override
  Widget build(BuildContext context) {
    log(widget.brand.name);
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back,
                color: Colors.black54,
              )),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Container(
              height: 35,
              child: Image.network(
                widget.brand.img,
              )),
        ),
        body: Container(
          child: ChangeNotifierProvider(
            create: (BuildContext context) => BrandPageViewModel(widget.brand),
            child: Consumer<BrandPageViewModel>(
                builder: (BuildContext context, value, Widget child) {
              return SingleChildScrollView(
                // child: ConstrainedBox(
                //   constraints: BoxConstraints(
                //       maxHeight: MediaQuery.of(context).size.height *
                //           (widget.brand.slug == 'go-sport' ? 1.1 : 1.55)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 10),
                      SliderBrandPage(viewModel: value),
                      SizedBox(height: 10),
                      SubBrandBrandPage(viewModel: value),
                      PickedBrandPage(viewModel: value, brandName: widget.brand.slug),
                      BrandVideo(viewModel: value),
                    ],
                  ),
              //  ),
              );
            }),
          ),
        ));
  }
}

class SliderBrandPage extends StatelessWidget {
  final BrandPageViewModel viewModel;

  const SliderBrandPage({Key key, @required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BannerData>>(
      future: viewModel.fetchSliderBannerData(), // async work
      builder:
          (BuildContext context, AsyncSnapshot<List<BannerData>> snapshot) {
        if (snapshot.hasData && snapshot.data.length>0) {
          List<BannerData> bannerData = snapshot.data;
          return CarouselSlider.builder(
            itemCount: bannerData.length,
            options: CarouselOptions(
              viewportFraction: 1,
              aspectRatio: 20 / 9,
              enlargeCenterPage: true,
              autoPlay: true,
            ),
            itemBuilder: (ctx, index, _index) {
              if (bannerData[index] != null) {
                return InkWell(
                  onTap: () async{


                    if (bannerData[index].link == null ||
                        bannerData[index].link == "") {

                    }
                    // else if(bannerData[index].link.contains(ApiEndpoint().brandLink)){
                    //   for(int i=0; i<Provider.of<BrandViewModel>(context).brandResponse.data.length;i++)
                    //   {
                    //     if(Provider.of<BrandViewModel>(context).brandResponse.data[i].name==bannerData[index].link.split(ApiEndpoint().brandLink)[1]){
                    //       locator<NavigationService>().pushNamed(routes.BrandPage,args: {"brandData":Provider.of<BrandViewModel>(context).brandResponse.data[i]});
                    //     }
                    //   }
                    // }
                    else{
                      locator<NavigationService>().push(MaterialPageRoute(
                          builder: (context) => ProductList("", "", "", "", "",
                              bannerData[index].link)));
                    }
                    },
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().radius(5))),
                      child: Container(
                        width: ScreenUtil().setWidth(380),
                        height: MediaQuery.of(context).size.height * 0.10,
                        child: Image.network(
                          bannerData[index].img.toString(),
                          width: ScreenUtil().setWidth(380),
                          height: MediaQuery.of(context).size.height * 0.10,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

class SubBrandBrandPage extends StatelessWidget {
  final BrandPageViewModel viewModel;

  const SubBrandBrandPage({Key key, @required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BrandResponse>(
      future: viewModel.fetchSubBrandData(), // async work
      builder: (BuildContext context, AsyncSnapshot<BrandResponse> snapshot) {
        if (snapshot.hasData) {
          BrandResponse bannerData = snapshot.data;
          print('view :: $bannerData');
          return Container(
            height: bannerData.data.length > 0 ? ScreenUtil().setWidth(61) : 0,
            margin: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(30), 0),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: bannerData.data.length,
                itemBuilder: (_, index) {
                  if (bannerData.data[index] != null) {
                    return
                      InkWell(
                          onTap: (){
                            if(bannerData.data[index].name==null || bannerData.data[index].name==""){

                            }
                            else{
                              locator<NavigationService>().push(MaterialPageRoute(
                                  builder: (context) => ProductList(
                                      "", "", bannerData.data[index].name,"","","")));
                            }
                          },
                          child:
                      Container(
                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                      width: ScreenUtil().setWidth(60),
                      height: ScreenUtil().setWidth(50),
                      //color: Colors.black,
                      decoration: new BoxDecoration(
                        color: Colors.transparent,
                        image: new DecorationImage(
                          fit: BoxFit.contain,
                          image: bannerData.data[index].img != null
                              ? NetworkImage(bannerData.data[index].img)
                              : NetworkImage(
                                  'https://next.anne.com/icon.png'),
                        ),
                      ),
                    ));
                  } else {
                    return SizedBox.shrink();
                  }
                }),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

class PickedBrandPage extends StatelessWidget {
  final BrandPageViewModel viewModel;
  final brandName;
  const PickedBrandPage({Key key, @required this.viewModel, this.brandName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log(brandName);
    return FutureBuilder<Map<String, List<BannerData>>>(
      future: viewModel.fetchPickedBannerData(),
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, List<BannerData>>> snapshot) {
        if (snapshot.hasData) {
          Map<String, List<BannerData>> data = snapshot.data;

          return
            // Expanded(
            // child:
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_, int index) {
                  final key = data.keys.elementAt(index);
                  return Container(
                    height: 220,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '$key',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                              itemBuilder: (_, int _index) {
                                BannerData banner = data[key][_index];
                                print(banner.link);
                                return InkWell(
                                    onTap: () async{

                                      if (banner.link == null ||
                                          banner.link == "") {

                                      }
                                      // else if(banner.link.contains(ApiEndpoint().brandLink)){
                                      //   for(int i=0; i<Provider.of<BrandViewModel>(context).brandResponse.data.length;i++)
                                      //   {
                                      //     if(Provider.of<BrandViewModel>(context).brandResponse.data[i].name==banner.link.split(ApiEndpoint().brandLink)[1]){
                                      //       locator<NavigationService>().pushNamed(routes.BrandPage,args: {"brandData":Provider.of<BrandViewModel>(context).brandResponse.data[i]});
                                      //     }
                                      //   }
                                      // }
                                      else{
                                        locator<NavigationService>().push(MaterialPageRoute(
                                            builder: (context) => ProductList("", "", "", banner.link.contains("parentBrand")?"":brandName, "",
                                                banner.link)));
                                      }
                                    },
                                    child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Image.network(
                                    '${banner.img}',
                                    fit: BoxFit.cover,
                                  ),
                                ));
                              },
                              itemCount: data[key].length,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  width: 6,
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: data.length);
         // );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

class BrandVideo extends StatelessWidget {
  final BrandPageViewModel viewModel;

  const BrandVideo({Key key, @required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BannerData>(
      future: viewModel.fetchVideoBannerData(), // async work
      builder: (BuildContext context, AsyncSnapshot<BannerData> snapshot) {
        if (snapshot.hasData) {
          BannerData bannerData = snapshot.data;
          print("banner data : ${bannerData.link}");
          return Container(
           // color: Colors.indigo,
            width: ScreenUtil().setWidth(380),
            height: 200,
            child: ChewieClass(
              videoPlayerController: VideoPlayerController.network(bannerData.img),
              looping: true,
            ),
            //height: MediaQuery.of(context).size.height * 0.10,
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

class ChewieClass extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;

  const ChewieClass(
      {Key key, @required this.videoPlayerController, this.looping})
      : super(key: key);

  @override
  _ChewieClassState createState() => _ChewieClassState();
}

class _ChewieClassState extends State<ChewieClass> {
  ChewieController _chewieController;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      //aspectRatio: widget.videoPlayerController.value.size.aspectRatio,
      aspectRatio: 20 / 9,
      autoInitialize: true,
      autoPlay: true,
      looping: widget.looping,
      showControls: false,
      showControlsOnInitialize: false,
      showOptions: false,
      errorBuilder: (context, errorMessage){
        return Center(
          child: Text(
            errorMessage,style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
    _chewieController.setVolume(0.0);
  }
  
  @override
  Widget build(BuildContext context) {
    return Chewie(controller: _chewieController,);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
  
}
