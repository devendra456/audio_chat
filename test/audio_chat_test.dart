import 'package:flutter_test/flutter_test.dart';
import 'package:audio_chat/audio_chat.dart';
import 'package:audio_chat/audio_chat_platform_interface.dart';
import 'package:audio_chat/audio_chat_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAudioChatPlatform
    with MockPlatformInterfaceMixin
    implements AudioChatPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AudioChatPlatform initialPlatform = AudioChatPlatform.instance;

  test('$MethodChannelAudioChat is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAudioChat>());
  });

  test('getPlatformVersion', () async {
    AudioChat audioChatPlugin = AudioChat();
    MockAudioChatPlatform fakePlatform = MockAudioChatPlatform();
    AudioChatPlatform.instance = fakePlatform;

    expect(await audioChatPlugin.getPlatformVersion(), '42');
  });
}
