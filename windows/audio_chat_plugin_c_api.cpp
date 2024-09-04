#include "include/audio_chat/audio_chat_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "audio_chat_plugin.h"

void AudioChatPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  audio_chat::AudioChatPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
