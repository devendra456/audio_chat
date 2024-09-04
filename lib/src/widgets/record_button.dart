import 'dart:async';
import 'dart:io';

import 'package:audio_chat/src/widgets/flow_shader.dart';
import 'package:audio_chat/src/widgets/lottie_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({
    super.key,
    required this.onAudioRecorded,
  });

  final void Function(String? path) onAudioRecorded;

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton>
    with SingleTickerProviderStateMixin {
  static const double size = 55;
  late AnimationController controller;

  final double lockerHeight = 200;
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
        MediaQuery.of(context).size.width - 2 * 10 - 4;
    timerAnimation =
        Tween<double>(begin: timerWidth + 10, end: 0)
            .animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );
    lockerAnimation =
        Tween<double>(begin: lockerHeight + 10, end: 0)
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
        lockSlider(),
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
          height: lockerHeight,
          width: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // color: Colors.black,
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const FaIcon(FontAwesomeIcons.lock, size: 20),
              const SizedBox(height: 8),
              FlowShader(
                flowColors: const [Colors.white, Colors.grey],
                direction: Axis.vertical,
                child: const Column(
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
          height: size,
          width: timerWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // color: Colors.black,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                showLottie ? const LottieAnimation() : Text(recordDuration),
                const SizedBox(width: size),
                FlowShader(
                  duration: const Duration(seconds: 3),
                  flowColors: const [Colors.white, Colors.grey],
                  child: const Row(
                    children: [
                      Icon(Icons.keyboard_arrow_left),
                      Text("Slide to cancel")
                    ],
                  ),
                ),
                const SizedBox(width: size),
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
        height: size,
        width: timerWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 25),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              Vibrate.feedback(FeedbackType.success);
              timer?.cancel();
              timer = null;
              startTime = null;
              recordDuration = "00:00";

              var filePath = await record.stop();
              // AudioState.files.add(filePath!);
              // Globals.audioListKey.currentState!
              //     .insertItem(AudioState.files.length - 1);
              debugPrint("====================>  $filePath");
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
                FlowShader(
                  duration: const Duration(seconds: 3),
                  flowColors: const [Colors.white, Colors.grey],
                  child: const Text("Tap lock to stop"),
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
          height: size,
          width: size,
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

        if (isCancelled(details.localPosition, context)) {
          Vibrate.feedback(FeedbackType.heavy);

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
        } else if (checkIsLocked(details.localPosition)) {
          controller.reverse();

          Vibrate.feedback(FeedbackType.heavy);
          debugPrint("Locked recording");
          debugPrint(details.localPosition.dy.toString());
          setState(() {
            isLocked = true;
          });
        } else {
          controller.reverse();

          Vibrate.feedback(FeedbackType.success);

          timer?.cancel();
          timer = null;
          startTime = null;
          recordDuration = "00:00";

          var filePath = await record.stop();
          // AudioState.files.add(filePath!);
          // Globals.audioListKey.currentState!
          //     .insertItem(AudioState.files.length - 1);
          widget.onAudioRecorded(filePath);
          debugPrint("====================>  $filePath");
        }
      },
      onLongPressCancel: () {
        debugPrint("onLongPressCancel");
        controller.reverse();
      },
      onLongPress: () async {
        debugPrint("onLongPress");
        Vibrate.feedback(FeedbackType.success);
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
