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
      case "Planifier":
        {
          setState(() {
            colors = [
              Color(0xff6DC8F3),
              Color(0xff73A1F9),
            ];
          });
        }
        break;
      case "Demarrer":
        {
          setState(() {
            colors = [
              Color(0xffFFB157),
              Color(0xffFFA057),
            ];
          });
        }
        break;
      case "Terminer":
        {
          setState(() {
            colors = [Color(0xff42E695), Color(0xff3BB2B8)];
          });
        }
        break;
      case "Annuler":
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
                              Icons.calendar_month,
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
