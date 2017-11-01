//
//  ViewController.swift
//  CIColorCurvesExample
//
//  Created by Prasanth Veerina on 10/31/17.
//  Copyright © 2017 Prasanth Veerina. All rights reserved.
//

import UIKit


struct RGB {
    var r : Float32
    var g: Float32
    var b : Float32
}

struct InputCurves {
    var shadows : RGB
    var midtones : RGB
    var highlights : RGB
}

enum ToneRange {
    case shadows
    case midtones
    case highlights
}

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var rSlider: UISlider!
    @IBOutlet var gSlider: UISlider!
    @IBOutlet var bSlider: UISlider!
    
    var context : CIContext!
    var currentMode : ToneRange = .shadows
    var filter : CIFilter?
    var inputCurves = InputCurves(shadows: RGB(r:0, g:0, b:0), midtones: RGB(r:0.5, g:0.5, b:0.5), highlights: RGB(r:1, g:1, b:1))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = CIContext(options:nil)
        let ciImage = CIImage(cgImage: (imageView.image?.cgImage)!)
        filter = CIFilter(name: "CIColorCurves")
        filter?.setDefaults()
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
    
        updateImage()
        updateSliders()
    }
    
    func updateImage() {
        let data = NSData(bytes: &inputCurves, length:MemoryLayout<InputCurves>.size) as Data
        filter?.setValue(data, forKey: "inputCurvesData")
        
        if let outputImage = filter?.outputImage {
            let cgimg = context.createCGImage(outputImage, from: outputImage.extent)
            let newImage = UIImage(cgImage: cgimg!)
            self.imageView.image = newImage
        }
    }
    
    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentMode = .shadows
        case 1:
            currentMode = .midtones
        case 2:
            currentMode = .highlights
        default:
            currentMode = .shadows
        }
        
        updateSliders()
        
    }
    
    func updateSliders() {
        switch currentMode {
        case .shadows:
            rSlider.value = inputCurves.shadows.r
            gSlider.value = inputCurves.shadows.g
            bSlider.value = inputCurves.shadows.b
        case .midtones:
            rSlider.value = inputCurves.midtones.r
            gSlider.value = inputCurves.midtones.g
            bSlider.value = inputCurves.midtones.b
        case .highlights:
            rSlider.value = inputCurves.highlights.r
            gSlider.value = inputCurves.highlights.g
            bSlider.value = inputCurves.highlights.b
        }
    }
    
    @IBAction func rSliderChanged(_ sender: UISlider) {
        switch currentMode {
        case .shadows:
            inputCurves.shadows.r = Float32(sender.value)
        case .midtones:
            inputCurves.midtones.r = Float32(sender.value)
        case .highlights:
            inputCurves.highlights.r = Float32(sender.value)
        }
        
        updateImage()
    }
    
    @IBAction func gSliderChanged(_ sender: UISlider) {
        switch currentMode {
        case .shadows:
            inputCurves.shadows.g = Float32(sender.value)
        case .midtones:
            inputCurves.midtones.g = Float32(sender.value)
        case .highlights:
            inputCurves.highlights.g = Float32(sender.value)
        }
        
        updateImage()
    }
    
    @IBAction func bSliderChanged(_ sender: UISlider) {
        switch currentMode {
        case .shadows:
            inputCurves.shadows.b = Float32(sender.value)
        case .midtones:
            inputCurves.midtones.b = Float32(sender.value)
        case .highlights:
            inputCurves.highlights.b = Float32(sender.value)
        }
        
        updateImage()
    }
}

