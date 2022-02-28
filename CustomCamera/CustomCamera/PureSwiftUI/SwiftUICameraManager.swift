//
//  SwiftUICameraManager.swift
//  CustomCamera
//
//  Created by vliu on 25/2/2022.
//

import AVFoundation

class SwiftUICameraManager: ObservableObject {
    
//    @Published var error: CameraError?
    let session = AVCaptureMultiCamSession()
    private let sessionQueue = DispatchQueue(label: "com.raywenderlich.SessionQ")
    private let videoOutput = AVCaptureVideoDataOutput()
//    private let photoOutput = AVCapturePhotoOutput()
    private var status = Status.unconfigured
    private var deviceWide: AVCaptureDevice?
    private var deviceUltra: AVCaptureDevice?
    
    
//    var maxZoomFactor: CGFloat {
//        get {
//            guard let camera = device else { return 1.0 }
//            return camera.maxAvailableVideoZoomFactor
//        }
//    }
//
//    var minZoomFactor: CGFloat {
//        get {
//            guard let camera = device else { return 1.0 }
//            return camera.minAvailableVideoZoomFactor
//        }
//    }
    
    enum Status {
        case unconfigured
        case configured
        case unauthorized
        case failed
    }

    static let shared = SwiftUICameraManager()

    private init() {
        configure()
    }

    private func configure() {
        checkPermissions()
        sessionQueue.async {
          self.configureCaptureSession()
          self.session.startRunning()
        }
        
    }
    
//    private func set(error: CameraError?) {
//      DispatchQueue.main.async {
//        self.error = error
//      }
//    }
    
    func set(_ delegate: AVCaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue) {
      sessionQueue.async {
        self.videoOutput.setSampleBufferDelegate(delegate, queue: queue)
      }
    }
    
    private func checkPermissions() {
     
      switch AVCaptureDevice.authorizationStatus(for: .video) {
          case .notDetermined:
              sessionQueue.suspend()
              AVCaptureDevice.requestAccess(for: .video) { authorized in
                if !authorized {
                    self.status = .unauthorized
//                    self.set(error: .deniedAuthorization)
                }
                self.sessionQueue.resume()
            }

          case .restricted:
              status = .unauthorized
//              set(error: .restrictedAuthorization)
          case .denied:
              status = .unauthorized
//              set(error: .deniedAuthorization)

          case .authorized:
              break

          @unknown default:
              status = .unauthorized
//              set(error: .unknownAuthorization)
      }
    }
    
    private func configureCaptureSession() {
        session.beginConfiguration()
        
        defer {
            session.commitConfiguration()
        }
        
        deviceWide = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        deviceUltra = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back)

        guard let wideCamera = deviceWide else { return }
        guard let ultraCamera = deviceUltra else { return }

        do {
            let wideCameraInput = try AVCaptureDeviceInput(device: wideCamera)
            let ultraCameraInput = try AVCaptureDeviceInput(device: ultraCamera)

            if session.canAddInput(wideCameraInput) {
                session.addInput(wideCameraInput)
            }
            
            
            if session.canAddInput(ultraCameraInput) {
                session.addInput(ultraCameraInput)
            }
            
            if session.canAddOutput(videoOutput) {
                session.addOutput(videoOutput)

                videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]

                let videoConnection = videoOutput.connection(with: .video)
                videoConnection?.videoOrientation = .portrait
//                videoConnection?.videoScaleAndCropFactor = 1
            }
            
        } catch {
            debugPrint(error.localizedDescription)
          return
        }
    }
    
//    func zoom(_ scale: CGFloat) {
//        guard let camera = device else {
////            set(error: .cameraUnavailable)
//            status = .failed
//            return
//        }
//        do {
//               try camera.lockForConfiguration()
//            camera.ramp(toVideoZoomFactor: scale, withRate: 2)
//                camera.unlockForConfiguration()
//           } catch {
//               print(error)
//           }
//    }
//    
//    func showInfo() {
//        let videoConnection = videoOutput.connection(with: .video)
//        print(videoConnection?.videoScaleAndCropFactor)
//    }
}
