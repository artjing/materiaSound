//
//  DepthSoundViewController.swift
//  MaterialSound
//
//  Created by 董静 on 4/8/21.
//  Copyright © 2021 Doyoung Gwak. All rights reserved.
//

import UIKit
import Vision

class DepthSoundViewController: UIViewController {

    var videoPreview :UIView!
    
    var drawingView : DrawingHeatmapView!
    
    var videoCapture: VideoCapture!
    
    let estimationModel = FCRNFP16()
    
    var request : VNCoreMLRequest?
    
    var visionModel : VNCoreMLModel?
    
    let postProcessor = HeatmapPostProcessor()
    
    var patch : PDPatch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setUI()
        setUpModel()
        setUpCamera()
        patch = PDPatch.init(file: "material.pd")
        patch?.onPatch(1)
        patch?.changeNoise(1)
        runga()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.videoCapture.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.videoCapture.stop()
    }
    
    func setUI(){
        
        videoPreview = UIView()
        videoPreview.frame = CGRect(x: 0, y: 0, width: view.width, height: view.width)
        view.addSubview(videoPreview)
        drawingView = DrawingHeatmapView()
        drawingView.frame = CGRect(x: 100, y: videoPreview.bottom + 15, width: view.width - 200, height:  view.width - 200)
        view.addSubview(drawingView)
        
    }
    
    func setUpCamera(){
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 50
        videoCapture.setUp(sessionPreset: .vga640x480) { sucess in
            if sucess {
                if let previewLayer = self.videoCapture.previewLayer {
                    self.videoPreview.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                self.videoCapture.start()
            }
        }
    }
    
    func setUpModel(){
        if let visionModel = try? VNCoreMLModel(for: estimationModel.model) {
            self.visionModel = visionModel
            request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
            request!.imageCropAndScaleOption = .scaleFill
        }else{
            fatalError()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizePreviewLayer()
    }
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = videoPreview.bounds
    }
    
}

extension DepthSoundViewController: VideoCaptureDelegate{
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?) {
        if let pixelBuffer = pixelBuffer {
            predict(with: pixelBuffer)
        }
    }
}

extension DepthSoundViewController {
    func predict(with pixelBuffer: CVPixelBuffer) {
        guard let request = request else {
            fatalError()
        }
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try?handler.perform([request])
    }
    
    func visionRequestDidComplete(request:VNRequest, error: Error? ){
        if let observations = request.results as? [VNCoreMLFeatureValueObservation], let heatmap = observations.first?.featureValue.multiArrayValue {
            
            let convertHeatmap = postProcessor.convertTo2DArray(from: heatmap)
            DispatchQueue.main.async { [weak self] in
                var num = Float(self!.drawingView.totalDepth)
                self?.patch?.changeNoise(num)
                self?.drawingView.heatmap = convertHeatmap
            }
        }
    }
}
