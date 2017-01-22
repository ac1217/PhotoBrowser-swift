//
//  PhotoCell.swift
//  PhotoBrowser-swift
//
//  Created by zhangweiwei on 2017/1/20.
//  Copyright © 2017年 pmec. All rights reserved.
//

import UIKit
import Kingfisher

let kPhotoCellReuseID = "PhotoCell"

class PhotoCell: UICollectionViewCell {
    
    var photo: Photo? {
        didSet{
            
            if let image = photo?.image {
                
                imageView.image = image
                layoutImageView()
            }else {
                
                activityIndicatorView.startAnimating()
                imageView.kf.setImage(with: photo?.url, placeholder: photo?.placeholderImage, progressBlock: { (receivedSize, totalSize) in
                    
                }) { (_, _, _, _) in
                    
                    self.activityIndicatorView.stopAnimating()
                    self.layoutImageView()
                    
                }
                
            }
            
        }
    }
    
    func didZoom() {
        
        if scrollView.zoomScale == self.scrollView.maximumZoomScale {
            
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
            
        }else {
            
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = false
        scrollView.frame = self.contentView.bounds
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        
        return scrollView
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.center = self.contentView.center
        return activityIndicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        contentView.addSubview(activityIndicatorView)
        
    }
    
    
    
    func layoutImageView() {
        
        scrollView.zoomScale = 1
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 2
        scrollView.contentSize = CGSize.zero
        
        let imageSize = imageView.image?.size ?? CGSize.zero
        let size = imageView.image?.sizeWithScreenWidth ?? CGSize.zero
        let width = size.width
        let height = size.height
        
        if width < imageSize.width {
            scrollView.maximumZoomScale = imageSize.width / width
        }
        
        imageView.frame.size = CGSize(width: width, height: height)
        
        scrollView.contentSize = imageView.frame.size
        
        scrollViewDidZoom(scrollView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
extension PhotoCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let imageViewSize = imageView.frame.size
        
        let width = imageViewSize.width
        let height = imageViewSize.height
        
        var insetH = (scrollView.frame.width - width) * 0.5
        var insetV = (scrollView.frame.height - height) * 0.5
        
        
        if insetH < 0 {
            insetH = 0
        }
        
        if insetV < 0 {
            insetV = 0
        }
        
        scrollView.contentInset = UIEdgeInsets(top: insetV, left: insetH, bottom: insetV, right: insetH)

        
    }
    
}
