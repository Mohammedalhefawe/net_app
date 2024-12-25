import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:web1/constants/icons_svg.dart';

class AnimatedButtonDemo extends StatefulWidget {
  final void Function()? onPressed;
  const AnimatedButtonDemo({super.key, this.onPressed});

  @override
  _AnimatedButtonDemoState createState() => _AnimatedButtonDemoState();
}

class _AnimatedButtonDemoState extends State<AnimatedButtonDemo> {
  bool _isHovered = false; 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true), 
        onExit: (_) => setState(() => _isHovered = false), 
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            side: _isHovered
                ? BorderSide.none
                : BorderSide(color: Theme.of(context).primaryColor, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: _isHovered
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            shadowColor: Colors.transparent, 
            elevation: 0, 
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "add_new_file".tr,
                style: TextStyle(
                  color: _isHovered
                      ? Colors.white
                      : Colors.white60,
                  fontSize: 17,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? Colors.white30
                      : Colors.white12, 
                  borderRadius: BorderRadius.circular(6),
                ),
                child: SvgPicture.string(
                  addIcon,
                  width: 18,
                  height: 18,
                  color: _isHovered
                      ? Colors.white
                      : Colors.white60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
