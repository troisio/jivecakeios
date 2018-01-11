import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var transaction: Transaction?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        self.captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            self.failed()
            return
        }

        if (self.captureSession.canAddInput(videoInput)) {
            self.captureSession.addInput(videoInput)
        } else {
            self.failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (self.captureSession.canAddOutput(metadataOutput)) {
            self.captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            self.failed()
            return
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.previewLayer.frame = view.layer.bounds
        self.previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(self.previewLayer)
        self.captureSession.startRunning()
    }
    
    func failed() {
        let controller = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(controller, animated: true)
        self.captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.captureSession?.isRunning == false) {
            self.captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.captureSession?.isRunning == true) {
            self.captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            guard let readableObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else { return }
            guard let id: String = readableObject.stringValue else { return }

            outer:
            for tree in ApplicationState.storage!.organizationTrees {
                for transaction in tree.transactions {
                    if transaction.id == id {
                        self.transaction = transaction
                        dump("found transaction with amount \(transaction.amount)")
                        self.performSegue(withIdentifier: "scannerToTransaction", sender: self)
                        break outer
                    }
                }
            }

            self.captureSession.stopRunning()
            
            if self.transaction == nil {
                let controller = UIAlertController(title: "Not Found", message: "Sorry, we can't find that transaction", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) -> Void in
                    self.captureSession.startRunning()
                }))
                self.present(controller, animated: true)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier ?? nil) == "scannerToTransaction" {
            let controller = segue.destination as! TransactionDetailViewController
            controller.transaction = self.transaction
            
            outerEvent:
            for tree in ApplicationState.storage!.organizationTrees {
                for event in tree.events {
                    if self.transaction?.eventId == event.id {
                        controller.event = event
                        break outerEvent
                    }
                }
            }

            outerItem:
            for tree in ApplicationState.storage!.organizationTrees {
                for item in tree.items {
                    if self.transaction?.itemId == item.id {
                        controller.item = item
                        break outerItem
                    }
                }
            }
            
            outerUser:
            for tree in ApplicationState.storage!.organizationTrees {
                for userInfo in tree.transactionUsers {
                    if self.transaction?.user_id == userInfo.sub {
                        controller.userInfo = userInfo
                        break outerUser
                    }
                }
            }
        }
    }
}
