import 'package:flutter/material.dart';

class SmallCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final int value;
  final Color color1;
  final Color color2;

  SmallCard({@required this.icon,@required this.title,@required this.value,@required this.color1,@required this.color2});

  @override
  _SmallCardState createState() => _SmallCardState();
}

class _SmallCardState extends State<SmallCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          Container(
            width: 140,
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(colors: [
                  widget.color1,
                  widget.color2,
                ]),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[400],
                      offset: Offset(1.0, 1.0),
                      blurRadius: 4
                  )
                ]
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(widget.icon, color: Colors.white, size: 25,),
                    SizedBox(width: 5),
                    Text(widget.title, style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300),)
                  ],
                ),
                Text(widget.value.toString(), style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.w400),)
              ],
            ),
          )

        ],
      ),
    );
  }
}