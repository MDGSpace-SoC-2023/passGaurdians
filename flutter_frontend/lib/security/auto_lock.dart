import 'package:flutter/material.dart';
import 'dart:async';

class AutoLock extends StatefulWidget {
  final Widget child;

  const AutoLock({Key? key, required this.child}) : super(key: key);

  @override
  _AutoLockState createState() => _AutoLockState();
}

class _AutoLockState extends State<AutoLock> {
  Timer? timer;
  final Duration inactivityDuration = Duration(seconds: 120);

  @override
  void initState() {
    super.initState();
    resetTimer();
  }

  void resetTimer() {
    if (timer != null) {
      timer!.cancel();
    }

    timer = Timer(inactivityDuration, () {
      Navigator.pushNamed(context, 'login');
    });
  }

  @override
  void didUpdateWidget(covariant AutoLock oldWidget) {
    super.didUpdateWidget(oldWidget);
    resetTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        resetTimer();
      },
      child: Listener(
        onPointerDown: (event) => resetTimer(),
        onPointerMove: (event) => resetTimer(),
        onPointerHover: (event) => resetTimer(),
        child: widget.child,
      ),
    );
  }
}
