import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../constants/styles.dart';

class MaxheightClipper extends StatefulWidget {
  final Widget child;
  final double maxHeight;
  final double minHeight;
  final double fadeEffectHeight;

  const MaxheightClipper({Key key, @required this.maxHeight,@required this.minHeight, @required this.child, this.fadeEffectHeight = 72}) : super(key: key);

  @override
  _MaxheightClipperState createState() => _MaxheightClipperState();
}

class _MaxheightClipperState extends State<MaxheightClipper> {
  var _size = Size.zero;

  @override
  Widget build(BuildContext context) {
    return  ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: widget.maxHeight,
          minHeight: widget.minHeight
        ),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              MeasureSize(
                onChange: (size) => setState(() => _size = size),
                child: widget.child,
                // child: Container(height: 2000,width: 100,),
              ),
              if (_size.height >= widget.maxHeight)
                Positioned(
                  bottom: 0,
                  left: 0,
                  width: _size.width,
                  child: _buildOverflowIndicator(),
                ),
              // Positioned(
              //   top: 0,
              //   left: 0,
              //   right: 0,
              //   child: MeasureSize(
              //     onChange: (size) => setState(() => _size = size),
              //     child: widget.child,
              //     // child: Container(height: 2000,width: 100,),
              //   ),
              // ),
              // if (_size.height >= widget.maxHeight)
              //   Positioned(
              //     bottom: 0,
              //     left: 0,
              //     width: _size.width,
              //     child: _buildOverflowIndicator(),
              //   ),
            ],
          ),
        ),
      );



  }

  Widget _buildOverflowIndicator() {
      return Container(
        height: widget.fadeEffectHeight,
        padding: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0,0.2,0.3,0.6,1],
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.8),
              Colors.white.withOpacity(1),

              Colors.white.withOpacity(1),
              Colors.white.withOpacity(1),
            ],
            tileMode: TileMode.repeated,
          ),
        ),
        child: Center(child: Text('View More',style: TextStyle(fontSize:18,color: AppColors.PrimaryColor,fontFamily: 'NunitoSans',fontWeight: FontWeight.bold),)),
        // child: Row(
        //   crossAxisAlignment: CrossAxisAlignment.end,
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     Text("Read More",
        //       style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: AppColors.PrimaryColor),)
        //   ],
        // ),
      );
    }

}

typedef void OnWidgetSizeChange(Size size);

class MeasureSizeRenderObject extends RenderProxyBox {
  Size oldSize;
  final OnWidgetSizeChange onChange;

  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = child.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    Key key,
    @required this.onChange,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }
}