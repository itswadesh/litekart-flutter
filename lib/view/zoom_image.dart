import 'package:anne/view/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/locator.dart';

class ZoomImage extends StatefulWidget {
  final List<String>? imageLinks;
  final int? index;

  ZoomImage(this.imageLinks, this.index);

  @override
  _ZoomImageState createState() => _ZoomImageState();
}

class _ZoomImageState extends State<ZoomImage> {
  PageController? pageController;

  @override
  void initState() {
    pageController = PageController(
        initialPage: widget.index!, keepPage: true, viewportFraction: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            PageView.builder(
              itemCount: widget.imageLinks!.length,
              itemBuilder: (_, int index) {
                return widget.imageLinks![index].contains("https://www.youtube.com/")?
                //Column(children: [
                  //SizedBox(height: ScreenUtil().setWidth(175),),
                  YoutubeVideoPlayClass(widget.imageLinks![index])

                //],)
                    : PinchZoom(
                    child: Image.network(
                      widget.imageLinks![index],
                      errorBuilder: ((context,object,stackTrace){
                        return Image.asset("assets/images/logo.png");
                      }),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.contain,
                    ),
                    resetDuration: const Duration(milliseconds: 100),
                    maxScale: 2.5);
              },
              controller: pageController,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  pageController!.previousPage(duration: Duration(milliseconds: 100), curve: Curves.easeIn);
                },
                child: Container(
                  margin: EdgeInsets.only(
                      left: 10),
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: ScreenUtil().setWidth(40),
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  pageController!.nextPage(duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
                },
                child: Container(
                  margin: EdgeInsets.only(
                      right: 10),
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: ScreenUtil().setWidth(40),
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  locator<NavigationService>().pop();
                },
                child: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 15, right: 15),
                  width: 30,
                  height: 30,
                  child: Icon(
                    Icons.close,
                    size: ScreenUtil().setWidth(30),
                    color: Colors.black,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
