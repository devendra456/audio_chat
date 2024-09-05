import 'dart:async';
import 'dart:io';

import 'package:audio_chat/src/widgets/flow_shader.dart';
import 'package:audio_chat/src/widgets/lottie_animation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../Utils/vibration_helper.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({
    super.key,
    required this.onAudioRecorded,
    this.showCancelSlider = true,
    this.showLockSlider = true,
    this.size = 55,
    this.lockerHeight = 200,
  });

  final void Function(String? path) onAudioRecorded;
  final bool showCancelSlider;
  final bool showLockSlider;
  final double size;
  final double lockerHeight;

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late VibrationHelper vibrationHelper;

  double timerWidth = 0;

  late Animation<double> buttonScaleAnimation;
  late Animation<double> timerAnimation;
  late Animation<double> lockerAnimation;

  DateTime? startTime;
  Timer? timer;
  String recordDuration = "00:00";
  late AudioRecorder record;

  bool isLocked = false;
  bool showLottie = false;

  late String documentPath;

  void getPath() async {
    documentPath = "${(await getApplicationDocumentsDirectory()).path}/";
  }

  void initController(){
    vibrationHelper = VibrationHelper();
    record = AudioRecorder();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    buttonScaleAnimation = Tween<double>(begin: 1, end: 2).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticInOut),
      ),
    );
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getPath();
    initController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timerWidth =
        MediaQuery.of(context).size.width - 2 * 6 - 4;
    timerAnimation =
        Tween<double>(begin: timerWidth + 6, end: 0)
            .animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );
    lockerAnimation =
        Tween<double>(begin:widget.lockerHeight + 6, end: 0)
            .animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    record.dispose();
    controller.dispose();
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if(widget.showLockSlider)
        lockSlider(),
        if(widget.showCancelSlider)
        cancelSlider(),
        audioButton(),
        if (isLocked) timerLocked(),
      ],
    );
  }

  Widget lockSlider() {
    return Positioned(
      bottom: -lockerAnimation.value,
      child: Opacity(
        opacity: (1/lockerAnimation.value).clamp(0, 1),
        child: Container(
          height:widget.lockerHeight,
          width:widget.size,
          decoration: const ShapeDecoration(shape: StadiumBorder(),color: Colors.white),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               FaIcon(FontAwesomeIcons.lock, size: 20),
               SizedBox(height: 8),
              FlowShader(
                flowColors:  [Colors.white, Colors.grey],
                child:  Column(
                  children: [
                    Icon(Icons.keyboard_arrow_up),
                    Icon(Icons.keyboard_arrow_up),
                    Icon(Icons.keyboard_arrow_up),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cancelSlider() {
    return Positioned(
      right: -timerAnimation.value,
      child: Opacity(
        opacity: (1/timerAnimation.value).clamp(0, 1),
        child: Container(
          height: widget.size,
          width: timerWidth,
          decoration: const ShapeDecoration(shape: StadiumBorder(),color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                showLottie ? const LottieAnimation() : Text(recordDuration),
                SizedBox(width: widget.size),
                const FlowShader(
                  flowColors:  [Colors.white, Colors.grey],
                  child:  Row(
                    children: [
                      Icon(Icons.keyboard_arrow_left),
                      Text("Slide to cancel")
                    ],
                  ),
                ),
               SizedBox(width: widget.size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget timerLocked() {
    return Positioned(
      right: 0,
      child: Container(
        height: widget.size,
        width: timerWidth,
        decoration: const ShapeDecoration(shape: StadiumBorder(),color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 25),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              vibrationHelper.vibrate();
              timer?.cancel();
              timer = null;
              startTime = null;
              recordDuration = "00:00";

              var filePath = await record.stop();
              widget.onAudioRecorded(filePath);
              setState(() {
                isLocked = false;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(recordDuration),
                const FlowShader(
                  flowColors:  [Colors.white, Colors.grey],
                  child:  Text("Tap lock to stop"),
                ),
                const Center(
                  child: FaIcon(
                    FontAwesomeIcons.lock,
                    size: 18,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget audioButton() {
    return GestureDetector(
      child: Transform.scale(
        scale: buttonScaleAnimation.value,
        child: Container(
          height: widget.size,
          width: widget.size,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
          child: const Icon(Icons.mic),
        ),
      ),
      onLongPressDown: (_) {
        debugPrint("onLongPressDown");
        controller.forward();
      },
      onLongPressEnd: (details) async {
        debugPrint("onLongPressEnd");

        if (isCancelled(details.localPosition, context) && widget.showCancelSlider) {
          vibrationHelper.vibrate();

          timer?.cancel();
          timer = null;
          startTime = null;
          recordDuration = "00:00";

          setState(() {
            showLottie = true;
          });

          Timer(const Duration(milliseconds: 1440), () async {
            controller.reverse();
            debugPrint("Cancelled recording");
            var filePath = await record.stop();
            debugPrint(filePath);
            File(filePath!).delete();
            debugPrint("Deleted $filePath");
            showLottie = false;
          });
        } else if (checkIsLocked(details.localPosition) && widget.showLockSlider) {
          controller.reverse();

          vibrationHelper.vibrate();
          debugPrint("Locked recording");
          debugPrint(details.localPosition.dy.toString());
          setState(() {
            isLocked = true;
          });
        } else {
          controller.reverse();

          vibrationHelper.vibrate();

          timer?.cancel();
          timer = null;
          startTime = null;
          recordDuration = "00:00";

          var filePath = await record.stop();
          widget.onAudioRecorded(filePath);
        }
      },
      onLongPressCancel: () {
        debugPrint("onLongPressCancel");
        controller.reverse();
      },
      onLongPress: () async {
        debugPrint("onLongPress");
        vibrationHelper.vibrate();
        if (await record.hasPermission()) {
          await record.start(
            const RecordConfig(
              encoder: AudioEncoder.aacEld,
              bitRate: 128000,
              sampleRate: 44100,
            ),
            path:
                "${documentPath}audio_${DateTime.now().millisecondsSinceEpoch}.m4a",
          );
          startTime = DateTime.now();
          timer = Timer.periodic(const Duration(seconds: 1), (_) {
            final minDur = DateTime.now().difference(startTime!).inMinutes;
            final secDur = DateTime.now().difference(startTime!).inSeconds % 60;
            String min = minDur < 10 ? "0$minDur" : minDur.toString();
            String sec = secDur < 10 ? "0$secDur" : secDur.toString();
            setState(() {
              recordDuration = "$min:$sec";
            });
          });
        }
      },
    );
  }

  bool checkIsLocked(Offset offset) {
    return (offset.dy < -35);
  }

  bool isCancelled(Offset offset, BuildContext context) {
    return (offset.dx < -(MediaQuery.of(context).size.width * 0.2));
  }
}
