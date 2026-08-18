import Flutter
import UIKit
import flutter_web_auth_2

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  // Recibe el callback de Spotify (lavdapp://spotify-callback) y lo pasa
  // a flutter_web_auth_2 para completar el flujo OAuth PKCE.
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    if url.scheme == "lavdapp" {
      FlutterWebAuth2Plugin.handleCallback(url: url)
      return true
    }
    return super.application(app, open: url, options: options)
  }
}
