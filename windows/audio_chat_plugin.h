#ifndef FLUTTER_PLUGIN_AUDIO_CHAT_PLUGIN_H_
#define FLUTTER_PLUGIN_AUDIO_CHAT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace audio_chat {

class AudioChatPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  AudioChatPlugin();

  virtual ~AudioChatPlugin();

  // Disallow copy and assign.
  AudioChatPlugin(const AudioChatPlugin&) = delete;
  AudioChatPlugin& operator=(const AudioChatPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace audio_chat

#endif  // FLUTTER_PLUGIN_AUDIO_CHAT_PLUGIN_H_
