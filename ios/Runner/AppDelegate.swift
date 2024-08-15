import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private var result: FlutterResult?

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let imagePickerChannel = FlutterMethodChannel(name: "image_picker_package", binaryMessenger: controller.binaryMessenger)

        imagePickerChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard call.method == "pickImage" else {
                result(FlutterMethodNotImplemented)
                return
            }
            self?.result = result
            let source = call.arguments as! Int
            self?.showImagePicker(source: source)
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func showImagePicker(source: Int) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = (source == 0) ? .camera : .photoLibrary
        window?.rootViewController?.present(imagePickerController, animated: true, completion: nil)
    }

    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let imageURL = info[.imageURL] as? URL {
                self.result?(imageURL.path)
            } else {
                self.result?(FlutterError(code: "UNAVAILABLE", message: "Image not available", details: nil))
            }
        }
    }
}
