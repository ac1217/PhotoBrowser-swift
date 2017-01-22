//
//  ViewController.swift
//  PhotoBrowser-swift
//
//  Created by zhangweiwei on 2017/1/20.
//  Copyright © 2017年 pmec. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    let photos = [
    
        Photo(urlString: "http://img2.3lian.com/2014/f4/86/d/134.jpg"),
        Photo(urlString: "http://ww2.sinaimg.cn/crop.0.0.980.300/b70b4830gw1ejuw3tbjtpj20r808c43f.jpg"),
        Photo(urlString: "http://img2.3lian.com/2014/f4/86/d/134.jpg"),
        Photo(urlString: "https://www.baidu.com/img/baidu_jgylogo3.gif"),
        Photo(urlString: "http://img2.3lian.com/2014/f4/86/d/134.jpg"),
        Photo(urlString: "http://pic2.cxtuku.com/00/02/31/b945758fd74d.jpg"),
    
    
    ]
    
    @IBOutlet weak var iv2: UIImageView!

    @IBOutlet weak var iv3: UIImageView!
    @IBOutlet weak var iv1: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        iv1.kf.setImage(with: URL(string: "http://img2.3lian.com/2014/f4/86/d/134.jpg"))
        iv2.kf.setImage(with: URL(string: "http://img2.3lian.com/2014/f4/86/d/134.jpg"))
        iv3.kf.setImage(with: URL(string: "http://ww2.sinaimg.cn/crop.0.0.980.300/b70b4830gw1ejuw3tbjtpj20r808c43f.jpg"))
        
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let pb = PhotoBrowser(photos: photos, currentIndex: 0) { (index) -> (UIImageView) in
            return self.iv1
        }
        pb.indicatorStyle = .pageControl
//        pb.indicatorPosition = .top
//        let pb = PhotoBrowser(photos: photos, currentIndex: 0)
        
        present(pb, animated: true, completion: nil)
        
    }


}

