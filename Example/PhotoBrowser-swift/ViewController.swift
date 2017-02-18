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
    
        Photo(urlString: "http://www.sznews.com/photo/images/attachement/jpg/site3/20150316/4437e6297838167069b219.jpg"),
        Photo(urlString: "http://www.sd.xinhuanet.com/news/2014-06/09/1111055665_14023066590331n.jpg"),
        Photo(urlString: "http://images.china.cn/attachement/jpg/site1000/20140910/001ec9591e621579f4bc06.jpg"),
        Photo(urlString: "http://s6.sinaimg.cn/mw690/002JP5eOgy6IS2UThFb45&690"),
        Photo(urlString: "http://img1.gtimg.com/ent/pics/hv1/21/57/1675/108931431.jpg"),
    
    
    ]
    
    @IBOutlet weak var iv2: UIImageView!

    @IBOutlet weak var iv3: UIImageView!
    @IBOutlet weak var iv1: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        iv1.kf.setImage(with: URL(string: "http://www.sznews.com/photo/images/attachement/jpg/site3/20150316/4437e6297838167069b219.jpg"))
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

