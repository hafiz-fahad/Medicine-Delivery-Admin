import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JustifiedDropDown extends StatefulWidget {
  final List dropDownList;
  final String controller;
  final onchange;
  final double height;
  final double width;
  final String hintText;
  final double opacityOfDropDownBox;
  final Color dropDownBoxColor;
  final Color dropDownBarColor;
  final double dropDownListTextSize;
  final Color dropDownListTextColor;

  JustifiedDropDown({
    this.dropDownList,
    this.controller,
    this.onchange,
    this.height,
    this.width,
    this.hintText,
    this.opacityOfDropDownBox,
    this.dropDownBarColor,
    this.dropDownBoxColor,
    this.dropDownListTextSize,
    this.dropDownListTextColor
  });
  @override
  _JustifiedDropDownState createState() => _JustifiedDropDownState();
}

class _JustifiedDropDownState extends State<JustifiedDropDown>
    with SingleTickerProviderStateMixin{

  GlobalKey _key;
  bool isMenuOpen = false;
  Offset buttonPosition;
  Size buttonSize;
  OverlayEntry _overlayEntry;
  BorderRadius _borderRadius;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _borderRadius = BorderRadius.circular(10);
    _key = LabeledGlobalKey("button_icon");
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  findButton() {
    RenderBox renderBox = _key.currentContext.findRenderObject();
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    _overlayEntry.remove();
    _animationController.reverse();
    isMenuOpen = !isMenuOpen;
    print("$isMenuOpen state");
  }

  void openMenu() {
    findButton();
    _animationController.forward();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context).insert(_overlayEntry);
    isMenuOpen = !isMenuOpen;
    print("$isMenuOpen state");

  }

  Future<bool> _onWillPop() {
    if(_overlayEntry != null && isMenuOpen == true){
      closeMenu();
      _overlayEntry = null;
      return Future.value(false);
    }
    return Future.value(true);
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: (){
            closeMenu();
          },
          child: Stack(
            children: <Widget>[
              Positioned(
                top: buttonPosition.dy + buttonSize.height,
                left: buttonPosition.dx,
                width: buttonSize.width,
                child: Material(
                  color: Colors.transparent,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ClipPath(
                      clipper: ArrowClipper(),
                      child: Container(
                        width: 17,
                        height: 17,
                        color: widget.dropDownBoxColor==null
                            ?Colors.white.withOpacity(widget.opacityOfDropDownBox == null
                            ?0.9
                            :widget.opacityOfDropDownBox)
                            :widget.dropDownBoxColor.withOpacity(widget.opacityOfDropDownBox == null
                            ?0.9
                            :widget.opacityOfDropDownBox),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: buttonPosition.dy + buttonSize.height,
                left: buttonPosition.dx,
                width: buttonSize.width,
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Container(
                      height: widget.dropDownList.length * (buttonSize.height/1.5),
                      decoration: BoxDecoration(
                        color: widget.dropDownBoxColor==null
                            ?Colors.white.withOpacity(widget.opacityOfDropDownBox == null
                            ?0.9
                            :widget.opacityOfDropDownBox)
                            :widget.dropDownBoxColor.withOpacity(widget.opacityOfDropDownBox == null
                            ?0.9
                            :widget.opacityOfDropDownBox),
                        borderRadius: _borderRadius,
                      ),
                      child: Theme(
                        data: ThemeData(
                          iconTheme: IconThemeData(
                            color: Colors.black,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(widget.dropDownList.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                widget.onchange(widget.dropDownList[index]);
                                closeMenu();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 14.0,top: 14.0),
                                child: Container(
                                  width: buttonSize.width,
                                  child: AutoSizeText("${widget.dropDownList[index]}",
                                    style: TextStyle(
                                        fontSize: widget.dropDownListTextSize == null
                                            ?15
                                            :widget.dropDownListTextSize,
                                        color: widget.dropDownListTextColor == null
                                            ?Colors.black
                                            :widget.dropDownListTextColor
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        key: _key,
        child: SizedBox(
            height: widget.height == null
                ?50
                :widget.height,
            width: widget.width == null
                ?double.infinity
                :widget.width,
            child: Material(
              color: widget.dropDownBarColor == null
                  ?Colors.white
                  :widget.dropDownBarColor,
              elevation: 4,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              shadowColor: Colors.black87.withOpacity(0.8),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Theme(
                  isMaterialAppTheme: true,
                  data: ThemeData(
                      iconTheme: IconThemeData(color: Colors.black)
                  ),
                  child: InkWell(
                    onTap: (){
                      if (isMenuOpen) {
                        closeMenu();
                      } else {
                        openMenu();
                      }
                    },
                    child: Container(
                      child: Center(
                          child: ListTile(
                            title: widget.controller == null
                                ?Padding(
                              padding: const EdgeInsets.only(bottom: 11.0),
                              child:
                              AutoSizeText(widget.hintText,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15
                                ),
                              ),
                            )
                                :Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: AutoSizeText(widget.controller,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15
                                ),
                              ),
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: AnimatedIcon(
                                icon: AnimatedIcons.view_list,color: Colors.black,
                                progress: _animationController,
                              ),
                            ),
                          )

                      ),
                    ),
                  ),
                ),
              ),
            )
        ),
      ),
    );
  }
}

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, size.height / 2);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}