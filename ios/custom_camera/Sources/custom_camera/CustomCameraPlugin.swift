import Flutter
import UIKit
import AVFoundation
#if SWIFT_PACKAGE
// SPM: 拆 OC target，需要显式 import
import custom_camera_internal
#endif
// CocoaPods: OC 头由 podspec 单 target 的 umbrella header 自动透出，Swift 直接可见

//UIImagePickerControllerDelegate, UINavigationControllerDelegate
@objc(CustomCameraPlugin)
public class CustomCameraPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "custom_camera", binaryMessenger: registrar.messenger())
        let instance = CustomCameraPlugin()
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
            
            let cameraVC = PortraitLockShotViewController()
            cameraVC.flutterResult = result
            cameraVC.sourceType = sourceType
            cameraVC.faceType = faceType
            cameraVC.appType = appType ?? 0
            // 必须 .overFullScreen：.fullScreen 会让下面的 FlutterViewController 走 viewDidDisappear 停帧，
            // 松手/拍完回到 Flutter 时先露出拍摄前的旧帧（聊天页）再出预览页，表现为闪一下。#28425
            // 竖屏锁不再靠相机 VC 当朝向归属者（#21580 原做法），改为临时收窄 Flutter 根 VC 的朝向，见 lockFlutterPortrait。
            cameraVC.modalPresentationStyle = .overFullScreen
            cameraVC.flashType = flashType ?? 0
            cameraVC.themeColor = themeColor ?? "#FF92C6"
            
            let rootVC = UIApplication.shared.keyWindow!.rootViewController!
            cameraVC.restoreOrientationMask = CustomCameraPlugin.lockFlutterPortrait(rootVC)
            cameraVC.startObservingDartOrientation()
            let presentAnimated = (animated ?? 0) == 1
            // FlutterViewController 收到朝向通知后在主队列异步执行 requestGeometryUpdate，
            // 这里也异步 present，保证先发出转竖请求再弹相机。
            DispatchQueue.main.async {
                rootVC.present(cameraVC, animated: presentAnimated)
            }
        } else if (call.method == "destory") {
            if (true == UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.isKind(of: SLShotViewController.self)) {
                UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.dismiss(animated: true)
            }
        }
    }

    // MARK: - 竖屏锁（#21580 / #28425）

    // Flutter 引擎 SystemChrome.setPreferredOrientations 用的通知，FlutterViewController 监听它
    // 更新 supportedInterfaceOrientations 并 requestGeometryUpdate。
    // 注意：这是引擎内部通知名，不是公开 API，依据 Flutter 3.47.x 引擎
    // shell/platform/darwin/ios/framework/Source/FlutterPlatformPlugin.mm:37-40。升级 Flutter 必须复查这两个字符串。
    static let flutterOrientationNotification =
        Notification.Name("io.flutter.plugin.platform.SystemChromeOrientationNotificationName")
    static let flutterOrientationKey = "io.flutter.plugin.platform.SystemChromeOrientationNotificationKey"

    static let selfPostMarker = NSObject()

    static func postFlutterOrientation(_ mask: UIInterfaceOrientationMask) {
        // object 用自己的标记，便于区分 Dart 侧（引擎 post 时 object 为 nil）发的朝向变更。
        NotificationCenter.default.post(
            name: flutterOrientationNotification,
            object: selfPostMarker,
            userInfo: [flutterOrientationKey: NSNumber(value: mask.rawValue)])
    }

    /// .overFullScreen 下朝向由根 FlutterViewController 决定（横屏直播间里它只允许 landscapeRight），
    /// 相机自身的 supportedInterfaceOrientations 不生效。这里临时把根 VC 收窄为竖屏，
    /// 返回原 mask，相机关闭后原样还回；根 VC 本来就只允许竖屏时返回 nil 不动。
    static func lockFlutterPortrait(_ rootVC: UIViewController) -> NSNumber? {
        guard rootVC is FlutterViewController else { return nil }
        let saved = rootVC.supportedInterfaceOrientations
        if saved == .portrait { return nil }
        postFlutterOrientation(.portrait)
        return NSNumber(value: saved.rawValue)
    }
}

/// 相机关闭（被 dismiss）后把根 FlutterViewController 的朝向还原成弹出前的值。
class PortraitLockShotViewController: SLShotViewController {
    var restoreOrientationMask: NSNumber?
    private var dartChangedOrientation = false
    private var orientationObserver: NSObjectProtocol?

    /// 相机期间监听同一引擎朝向通知：不是本插件发的（Dart 调了 setPreferredOrientations）就记下，
    /// dismiss 后不再还原，以 Dart 的最新设置为准。
    func startObservingDartOrientation() {
        guard restoreOrientationMask != nil, orientationObserver == nil else { return }
        orientationObserver = NotificationCenter.default.addObserver(
            forName: CustomCameraPlugin.flutterOrientationNotification, object: nil, queue: nil
        ) { [weak self] note in
            if (note.object as AnyObject?) !== CustomCameraPlugin.selfPostMarker {
                self?.dartChangedOrientation = true
            }
        }
    }

    deinit {
        if let o = orientationObserver { NotificationCenter.default.removeObserver(o) }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard isBeingDismissed else { return }
        if let o = orientationObserver {
            NotificationCenter.default.removeObserver(o)
            orientationObserver = nil
        }
        guard let raw = restoreOrientationMask else { return }
        restoreOrientationMask = nil
        if dartChangedOrientation { return }
        CustomCameraPlugin.postFlutterOrientation(UIInterfaceOrientationMask(rawValue: raw.uintValue))
    }
}
