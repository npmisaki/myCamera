//
//  EffectViewController.swift
//  MyCamera
//
//  Created by Swift-Beginners.
//  Copyright © 2016年 Swift-Beginners. All rights reserved.
//

import UIKit

class EffectViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    // 画面遷移時に元の画像を表示
    effectImage.image = originalImage
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
  @IBOutlet weak var effectImage: UIImageView!
  
  // フィルタ名を列挙した配列(Array)
  // 0.モノクロ
  // 1.Chrome
  // 2.Fade
  // 3.Instant
  // 4.Noir
  // 5.Process
  // 6.Tonal
  // 7.Transfer
  // 8.Sepia Tone
  let filterArray = ["CIPhotoEffectMono",
                     "CIPhotoEffectChrome",
                     "CIPhotoEffectFade",
                     "CIPhotoEffectInstant",
                     "CIPhotoEffectNoir",
                     "CIPhotoEffectProcess",
                     "CIPhotoEffectTonal",
                     "CIPhotoEffectTransfer",
                     "CISepiaTone"
  ]
  
  // 選択中のエフェクト添字
  var filterSelectNumber = 0
  
  // エフェクト前画像
  // 前の画面より画像を設定
  var originalImage : UIImage?
  
  
  
  @IBAction func effectButton(_ sender: Any) {
    // フィルター名を指定
    let filterName = filterArray[filterSelectNumber]
    
    // 次の選択するエフェクト添字に更新
    filterSelectNumber += 1
    
    // 添字が配列の数と同じか？チェック
    if filterSelectNumber == filterArray.count {
      // 同じ場合は最後まで選択されたので先頭に戻す
      filterSelectNumber = 0
    }
    
    // 元々の画像の回転角度を取得
    let rotate = originalImage!.imageOrientation
    
    // UIImage形式の画像をCIImage形式の画像に変換
    let inputImage = CIImage(image: originalImage!)
    
    // フィルターの種類を引数で指定された種類を指定してCIFilterのインスタンスを取得
    let effectFilter = CIFilter(name: filterName)!
    
    // エフェクトのパラメータを初期化
    effectFilter.setDefaults()
    
    // インスタンスにエフェクトする元画像を設定
    effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
    
    // エフェクト後のCIImage形式の画像を取り出す
    let outputImage = effectFilter.outputImage
    
    // CIContextのインスタンスを取得
    let ciContext = CIContext(options: nil)
    
    // エフェクト後の画像をCIContext上に描画し、結果をcgImageとしてCGImage形式の画像を取得
    let cgImage = ciContext.createCGImage(outputImage!, from: outputImage!.extent)
    
    // エフェクト後の画像をCGImage形式の画像からUIImage形式の画像に回転角度を指定して変換しImageViewに表示
    effectImage.image = UIImage(cgImage: cgImage!, scale: 1.0, orientation: rotate)
  }
  
  
  @IBAction func closeButtonAction(_ sender: AnyObject) {
    // 画面を閉じて前の画面に戻る
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func shareButton(_ sender: Any) {
      // UIActivityViewControllerに表示している画像を渡す
      let controller = UIActivityViewController(activityItems: [effectImage.image!], applicationActivities: nil)
      
      // iPadで落ちてしまう対策
      controller.popoverPresentationController?.sourceView = view
      
      // UIActivityViewControllerを表示
      present(controller, animated: true, completion: nil)
  }
  
}
