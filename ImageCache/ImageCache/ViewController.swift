//
//  ViewController.swift
//  ImageCache
//
//  Created by 박상우 on 2022/01/18.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestImage()
    }
    
    private func requestImage() {
        let imageUrl = "https://img3.yna.co.kr/photo/cms/2019/04/09/12/PCM20190409000012005_P2.jpg"
        ImageCacheManager.shared.loadImage(url: URL(string: imageUrl)) { data in
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
}

