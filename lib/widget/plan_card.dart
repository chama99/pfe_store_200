import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class PlanCard extends StatefulWidget {
  final String? subject;
  final String? client;
  final String? startTime;
  final String? status;
  const PlanCard(
      {Key? key, this.subject, this.client, this.startTime, this.status})
      : super(key: key);

  @override
  _PlanCardState createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  List<Color> colors = [
    Color(0xff6DC8F3),
    Color(0xff73A1F9),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.status) {
      case "Planifiée":
        {
          setState(() {
            colors = [
              Color(0xff6DC8F3),
              Color(0xff73A1F9),
            ];
          });
        }
        break;
      case "Démarrée":
        {
          setState(() {
            colors = [
              Color(0xffFFB157),
              Color(0xffFFA057),
            ];
          });
        }
        break;
      case "Termineé":
        {
          setState(() {
            colors = [Color(0xff42E695), Color(0xff3BB2B8)];
          });
        }
        break;
      case "Annuleé":
        {
          setState(() {
            colors = [Color(0xffFF5B95), Color(0xffF8556D)];
          });
        }
        break;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: <Widget>[
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                    colors: colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                boxShadow: [
                  BoxShadow(
                    color: colors[0],
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              top: 0,
              child: CustomPaint(
                size: const Size(100, 150),
                painter: CustomCardShapePainter(24, colors[1], colors[0]),
              ),
            ),
            Positioned.fill(
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.subject!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          widget.client!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Avenir',
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Text(
                                widget.startTime!.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          widget.client!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Avenir',
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        // RatingBar(rating: items[index].rating),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceInfo {
  final String name;
  final String category;
  final String location;
  final double rating;
  final Color startColor;
  final Color endColor;

  PlaceInfo(this.name, this.startColor, this.endColor, this.rating,
      this.location, this.category);
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// import '../../main.dart';

// class MealsListView extends StatefulWidget {
//   const MealsListView(
//       {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
//       : super(key: key);

//   final AnimationController? mainScreenAnimationController;
//   final Animation<double>? mainScreenAnimation;

//   @override
//   _MealsListViewState createState() => _MealsListViewState();
// }

// class _MealsListViewState extends State<MealsListView>
//     with TickerProviderStateMixin {
//   AnimationController? animationController;
//   List<MealsListData> mealsListData = MealsListData.tabIconsList;

//   @override
//   void initState() {
//     animationController = AnimationController(
//         duration: const Duration(milliseconds: 2000), vsync: this);
//     super.initState();
//   }

//   Future<bool> getData() async {
//     await Future<dynamic>.delayed(const Duration(milliseconds: 50));
//     return true;
//   }

//   @override
//   void dispose() {
//     animationController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: widget.mainScreenAnimationController!,
//       builder: (BuildContext context, Widget? child) {
//         return FadeTransition(
//           opacity: widget.mainScreenAnimation!,
//           child: Transform(
//             transform: Matrix4.translationValues(
//                 0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
//             child: Container(
//               height: 216,
//               width: double.infinity,
//               child: ListView.builder(
//                 padding: const EdgeInsets.only(
//                     top: 0, bottom: 0, right: 16, left: 16),
//                 itemCount: mealsListData.length,
//                 scrollDirection: Axis.horizontal,
//                 itemBuilder: (BuildContext context, int index) {
//                   final int count =
//                       mealsListData.length > 10 ? 10 : mealsListData.length;
//                   final Animation<double> animation =
//                       Tween<double>(begin: 0.0, end: 1.0).animate(
//                           CurvedAnimation(
//                               parent: animationController!,
//                               curve: Interval((1 / count) * index, 1.0,
//                                   curve: Curves.fastOutSlowIn)));
//                   animationController?.forward();

//                   return MealsView(
//                     mealsListData: mealsListData[index],
//                     animation: animation,
//                     animationController: animationController!,
//                   );
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class MealsView extends StatelessWidget {
//   const MealsView(
//       {Key? key, this.mealsListData, this.animationController, this.animation})
//       : super(key: key);
//   final String? subject;
//   final String?
//   final AnimationController? animationController;
//   final Animation<double>? animation;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: animationController!,
//       builder: (BuildContext context, Widget? child) {
//         return FadeTransition(
//           opacity: animation!,
//           child: Transform(
//             transform: Matrix4.translationValues(
//                 100 * (1.0 - animation!.value), 0.0, 0.0),
//             child: SizedBox(
//               width: 130,
//               child: Stack(
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(
//                         top: 32, left: 8, right: 8, bottom: 16),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         boxShadow: <BoxShadow>[
//                           BoxShadow(
//                               color: HexColor(mealsListData!.endColor)
//                                   .withOpacity(0.6),
//                               offset: const Offset(1.1, 4.0),
//                               blurRadius: 8.0),
//                         ],
//                         gradient: LinearGradient(
//                           colors: <HexColor>[
//                             HexColor(mealsListData!.startColor),
//                             HexColor(mealsListData!.endColor),
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: const BorderRadius.only(
//                           bottomRight: Radius.circular(8.0),
//                           bottomLeft: Radius.circular(8.0),
//                           topLeft: Radius.circular(8.0),
//                           topRight: Radius.circular(54.0),
//                         ),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.only(
//                             top: 54, left: 16, right: 16, bottom: 8),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Text(
//                               mealsListData!.titleTxt,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontFamily: FitnessAppTheme.fontName,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                                 letterSpacing: 0.2,
//                                 color: FitnessAppTheme.white,
//                               ),
//                             ),
//                             Expanded(
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.only(top: 8, bottom: 8),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: <Widget>[
//                                     Text(
//                                       mealsListData!.meals!.join('\n'),
//                                       style: TextStyle(
//                                         fontFamily: FitnessAppTheme.fontName,
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 10,
//                                         letterSpacing: 0.2,
//                                         color: FitnessAppTheme.white,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             mealsListData?.kacl != 0
//                                 ? Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: <Widget>[
//                                       Text(
//                                         mealsListData!.kacl.toString(),
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           fontFamily: FitnessAppTheme.fontName,
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 24,
//                                           letterSpacing: 0.2,
//                                           color: FitnessAppTheme.white,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 4, bottom: 3),
//                                         child: Text(
//                                           'kcal',
//                                           style: TextStyle(
//                                             fontFamily:
//                                                 FitnessAppTheme.fontName,
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 10,
//                                             letterSpacing: 0.2,
//                                             color: FitnessAppTheme.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 : Container(
//                                     decoration: BoxDecoration(
//                                       color: FitnessAppTheme.nearlyWhite,
//                                       shape: BoxShape.circle,
//                                       boxShadow: <BoxShadow>[
//                                         BoxShadow(
//                                             color: FitnessAppTheme.nearlyBlack
//                                                 .withOpacity(0.4),
//                                             offset: Offset(8.0, 8.0),
//                                             blurRadius: 8.0),
//                                       ],
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(6.0),
//                                       child: Icon(
//                                         Icons.add,
//                                         color: HexColor(mealsListData!.endColor),
//                                         size: 24,
//                                       ),
//                                     ),
//                                   ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 0,
//                     left: 0,
//                     child: Container(
//                       width: 84,
//                       height: 84,
//                       decoration: BoxDecoration(
//                         color: FitnessAppTheme.nearlyWhite.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 0,
//                     left: 8,
//                     child: SizedBox(
//                       width: 80,
//                       height: 80,
//                       child: Image.asset(mealsListData!.imagePath),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }


// // import 'package:flutter/material.dart';

// // class Card extends StatelessWidget {
// //   final status 
// //   const Card({ Key? key, MaterialColor status = Colors.blue, DateTime startTime,   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return  Center(
// //             child: Padding(
// //               padding: const EdgeInsets.all(16.0),
// //               child: Stack(
// //                 children: <Widget>[
// //                   Container(
// //                     height: 150,
// //                     decoration: BoxDecoration(
// //                       borderRadius: BorderRadius.circular(24),
// //                       gradient: LinearGradient(colors: [
// //                         items[index].startColor,
// //                         items[index].endColor
// //                       ], begin: Alignment.topLeft, end: Alignment.bottomRight),
// //                       boxShadow: [
// //                         BoxShadow(
// //                           color: items[index].endColor,
// //                           blurRadius: 12,
// //                           offset: Offset(0, 6),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   Positioned(
// //                     right: 0,
// //                     bottom: 0,
// //                     top: 0,
// //                     child: CustomPaint(
// //                       size: Size(100, 150),
// //                       painter: CustomCardShapePainter(_borderRadius,
// //                           items[index].startColor, items[index].endColor),
// //                     ),
// //                   ),
// //                   Positioned.fill(
// //                     child: Row(
// //                       children: <Widget>[
// //                         Expanded(
// //                           child: Image.asset(
// //                             'assets/icon.png',
// //                             height: 64,
// //                             width: 64,
// //                           ),
// //                           flex: 2,
// //                         ),
// //                         Expanded(
// //                           flex: 4,
// //                           child: Column(
// //                             mainAxisSize: MainAxisSize.min,
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: <Widget>[
// //                               Text(
// //                                 items[index].name,
// //                                 style: TextStyle(
// //                                     color: Colors.white,
// //                                     fontFamily: 'Avenir',
// //                                     fontWeight: FontWeight.w700),
// //                               ),
// //                               Text(
// //                                 items[index].category,
// //                                 style: TextStyle(
// //                                   color: Colors.white,
// //                                   fontFamily: 'Avenir',
// //                                 ),
// //                               ),
// //                               SizedBox(height: 16),
// //                               Row(
// //                                 children: <Widget>[
// //                                   Icon(
// //                                     Icons.location_on,
// //                                     color: Colors.white,
// //                                     size: 16,
// //                                   ),
// //                                   SizedBox(
// //                                     width: 8,
// //                                   ),
// //                                   Flexible(
// //                                     child: Text(
// //                                       items[index].location,
// //                                       style: TextStyle(
// //                                         color: Colors.white,
// //                                         fontFamily: 'Avenir',
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                         Expanded(
// //                           flex: 2,
// //                           child: Column(
// //                             mainAxisSize: MainAxisSize.min,
// //                             children: <Widget>[
// //                               Text(
// //                                 items[index].rating.toString(),
// //                                 style: TextStyle(
// //                                     color: Colors.white,
// //                                     fontFamily: 'Avenir',
// //                                     fontSize: 18,
// //                                     fontWeight: FontWeight.w700),
// //                               ),
// //                               RatingBar(rating: items[index].rating),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// //   }
// // }



// // class PlaceInfo {
// //   final String name;
// //   final String category;
// //   final String location;
// //   final double rating;
// //   final Color startColor;
// //   final Color endColor;

// //   PlaceInfo(this.name, this.startColor, this.endColor, this.rating,
// //       this.location, this.category);
// // }

// // class CustomCardShapePainter extends CustomPainter {
// //   final double radius;
// //   final Color startColor;
// //   final Color endColor;

// //   CustomCardShapePainter(this.radius, this.startColor, this.endColor);

// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     var radius = 24.0;

// //     var paint = Paint();
// //     paint.shader = ui.Gradient.linear(
// //         Offset(0, 0), Offset(size.width, size.height), [
// //       HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
// //       endColor
// //     ]);

// //     var path = Path()
// //       ..moveTo(0, size.height)
// //       ..lineTo(size.width - radius, size.height)
// //       ..quadraticBezierTo(
// //           size.width, size.height, size.width, size.height - radius)
// //       ..lineTo(size.width, radius)
// //       ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
// //       ..lineTo(size.width - 1.5 * radius, 0)
// //       ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
// //       ..close();

// //     canvas.drawPath(path, paint);
// //   }

// //   @override
// //   bool shouldRepaint(CustomPainter oldDelegate) {
// //     return true;
// //   }
// // }