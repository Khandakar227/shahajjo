//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <geolocator_windows/geolocator_windows.h>
#include <torch_flashlight/torch_flashlight_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  GeolocatorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("GeolocatorWindows"));
  TorchFlashlightPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("TorchFlashlightPluginCApi"));
}
