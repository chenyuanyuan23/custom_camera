import Flutter
import UIKit
import AVFoundation

//UIImagePickerControllerDelegate, UINavigationControllerDelegate
public class SwiftCustomCameraPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "custom_camera", binaryMessenger: registrar.messenger())
        let instance = SwiftCustomCameraPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "takePhotoAndVideo") {
            let dict = call.arguments as! NSDictionary
            let sourceType = dict["source_type"] as! Int
            let faceType = dict["face_type"] as! Int
            let animated = dict["animated"] as? Int
            let appType = dict["appType"] as? Int
            let flashType = dict["flashType"] as? Int 
            let themeColor = dict["theme_color"] as? NSString
            
            let cameraVC = SLShotViewController()
            cameraVC.flutterResult = result
            cameraVC.sourceType = sourceType
            cameraVC.faceType = faceType
            cameraVC.appType = appType ?? 0
            cameraVC.modalPresentationStyle = .overFullScreen
            cameraVC.flashType = flashType ?? 0
            cameraVC.themeColor = themeColor ?? "#FF92C6"
            
            if let anim = animated, anim == 1 {
                UIApplication.shared.keyWindow!.rootViewController!.present(cameraVC, animated: true)
            } else {
                UIApplication.shared.keyWindow!.rootViewController!.present(cameraVC, animated: false)
            }
        } else if (call.method == "destory") {
            if (true == UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.isKind(of: SLShotViewController.self)) {
                UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.dismiss(animated: true)
            }
        }
    }
    
}
