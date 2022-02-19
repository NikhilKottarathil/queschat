import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCircle extends StatelessWidget {
  double radius;

  ShimmerCircle({Key key, this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: ClipOval(
        child: ColoredBox(
          color: Colors.white,
          child: SizedBox(
            height: radius*2,
            width: radius*2,
          ),
        ),
      ),
      baseColor: Colors.black12,
      enabled: true,
      highlightColor: Colors.white,
      loop: 3,
    );
  }
}
class ShimmerRectangle extends StatelessWidget {
  double height,width;

  ShimmerRectangle({Key key, this.height,this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: ColoredBox(
        color: Colors.white,
        child: SizedBox(
          height: height,
          width: width!=null?width:double.infinity,
        ),
      ),
      baseColor: Colors.black12,
      enabled: true,
      highlightColor: Colors.white,
      loop: 3,
    );
  }
}
