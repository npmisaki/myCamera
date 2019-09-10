//
//  ViewController.swift
//  MyCamera
//
//  Created by Swift-Beginners.
//  Copyright © 2016年 Swift-Beginners. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UINavigationControllerDelegate , UIImagePickerControllerDelegate {
  
  override func viewDidLoad() {
   super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  override func viewDidAppear(_ animated: Bool) {
    pictureImage.image = captureImage
  }
  
  
  @IBOutlet weak var pictureImage: UIImageView!
  
  // カメラを起動するボタンをタップすると実行
  @IBAction func cameraButtonAction(_ sender: AnyObject) {
    // カメラかフォトライブラリーどちらから画像を取得するか選択する
    let alertController = UIAlertController(title: "確認", message: "選択してください", preferredStyle: .actionSheet)
    
    // カメラが利用可能かチェック
    if UIImagePickerController.isSourceTypeAvailable(.camera){
      // カメラを起動するための選択肢を定義
      let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler:  { (action:UIAlertAction) in
        // カメラを起動
        let ipc : UIImagePickerController = UIImagePickerController()
        ipc.sourceType = .camera
        ipc.delegate = self
        self.present(ipc, animated: true, completion: nil)
      })
      alertController.addAction(cameraAction)
    }
    
    // フォトライブラリーが利用可能かチェック
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
      // フォトライブラリーを起動するための選択肢を定義
      let photoLibraryAction = UIAlertAction(title: "フォトライブラリー", style: .default, handler: { (action:UIAlertAction) in
        // フォトライブラリーを起動
        let ipc : UIImagePickerController = UIImagePickerController()
        ipc.sourceType = .photoLibrary
        ipc.delegate = self
        self.present(ipc, animated: true, completion: nil)
      })
      alertController.addAction(photoLibraryAction)
    }
    
    // キャンセルの選択肢を定義
    let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    // iPadで落ちてしまう対策
    alertController.popoverPresentationController?.sourceView = view
    
    // 選択肢を画面に表示
    present(alertController, animated: true, completion: nil)
  }
  
  // SNSに投稿するボタンをタップすると実行
  @IBAction func SNSButtonAction(_ sender: AnyObject) {
    // 表示画像をアンラップしてシェア画像として取り出す
    if let shareImage = pictureImage.image {
      // UIActivityViewControllerに渡す配列を作成
      let shareItems = [shareImage]
      
      // UIActivityViewControllerにシェア画像を渡す
      let controller = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
      
      // iPadで落ちてしまう対策
      controller.popoverPresentationController?.sourceView = view
      
      // UIActivityViewControllerを表示
      present(controller, animated: true, completion: nil)
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    // (2)撮影した写真を、captureImageに渡す
    captureImage =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    // (3)モーダルビューを閉じる
    dismiss(animated: true, completion: {
      // (4)エフェクト画面に遷移
      self.performSegue(withIdentifier: "showEffectView", sender: nil)
    })
  }
  

  // 次の画面遷移するときに渡す画像を格納する場所
  var captureImage : UIImage?
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // 次の画面のインスタンスを取得
    let nextViewController = segue.destination as! EffectViewController
    
    // 次の画面のインスタンスに取得した画像を渡す
    nextViewController.originalImage = captureImage
  }
}

