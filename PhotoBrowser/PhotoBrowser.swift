//
//  PhotoBrowser.swift
//  PhotoBrowser-swift
//
//  Created by zhangweiwei on 2017/1/20.
//  Copyright © 2017年 pmec. All rights reserved.
//

import UIKit

public class PhotoBrowser: UIViewController {
    
    public var photos: [Photo]
    
    public var currentIndex: Int {
        didSet{
            
            pageLabel.text = "\(currentIndex + 1) / \(photos.count)"
        }
    }
    
    public var defaultPlaceholderImage: UIImage? {
        didSet{
            
            guard let defaultPlaceholderImage = defaultPlaceholderImage else {
                return
            }
            
            photos.forEach { (p) in
                p.placeholderImage = defaultPlaceholderImage
            }
            
        }
    }
    
    public init(photos: [Photo], currentIndex: Int, sourceImageViewClosure: ((Int)->(UIImageView))? = nil) {
        
        self.photos = photos
        self.sourceImageViewClosure = sourceImageViewClosure
        self.currentIndex = currentIndex
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        sourceImageViewClosure = nil
    }
    
    var sourceImageView: UIImageView? {
        return sourceImageViewClosure?(currentIndex)
    }
    
    var displayImageView: UIImageView? {
        
        let cell = collectionView.visibleCells.last as? PhotoCell
        return cell?.imageView
    }
    
    fileprivate var sourceImageViewClosure: ((Int)->(UIImageView))?
    
    fileprivate let presentPhotoTransition = PhotoTransition(style: .present)
    fileprivate let dismissPhotoTransition = PhotoTransition(style: .dismiss)
    
    fileprivate var isOriginalStatusBarHidden = true
    
    
    lazy var actionBtn: UIButton = {
        let actionBtn = UIButton()
        actionBtn.setImage(UIImage(name: "icon_action"), for: .normal)
        actionBtn.addTarget(self, action: #selector(PhotoBrowser.actionBtnClick), for: .touchUpInside)
        return actionBtn
    }()
    
    lazy var pageLabel: UILabel = {
        let pageLabel = UILabel()
        pageLabel.textColor = UIColor.white
        
        pageLabel.font = UIFont.boldSystemFont(ofSize: 16)
        pageLabel.textAlignment = .center
        pageLabel.text = "\(self.currentIndex + 1) / \(self.photos.count)"

        return pageLabel
    }()
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = self.view.bounds.size
        layout.sectionInset.right = layout.minimumLineSpacing
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.layout.itemSize.width + self.layout.minimumLineSpacing, height: self.layout.itemSize.height), collectionViewLayout: self.layout)
        
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: kPhotoCellReuseID)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black
        return backgroundView
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setupLayout()
        
        setupGesture()
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.isHidden = sourceImageView != nil
        
        isOriginalStatusBarHidden = UIApplication.shared.isStatusBarHidden
        
        UIApplication.shared.setStatusBarHidden(true, with: .fade)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.setStatusBarHidden(isOriginalStatusBarHidden, with: .fade)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        sourceImageView?.isHidden = false
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.isHidden = false
        sourceImageView?.isHidden = true
    }
    
    
    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension PhotoBrowser: UIViewControllerTransitioningDelegate {
    
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return dismissPhotoTransition
        
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return presentPhotoTransition
        
    }
    
}

extension PhotoBrowser: UIScrollViewDelegate {
    
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        sourceImageView?.isHidden = false
        
        currentIndex = Int((scrollView.contentOffset.x / scrollView.frame.width) + 0.5)
        
        
        sourceImageView?.isHidden = true
    }
    
}

extension PhotoBrowser: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPhotoCellReuseID, for: indexPath) as! PhotoCell
        
        cell.photo = photos[indexPath.item]
        
        
        return cell
    }
    
}

extension PhotoBrowser {
    
    func setupUI() {
        
        view.backgroundColor = UIColor.clear
        view.addSubview(backgroundView)
        view.addSubview(collectionView)
        view.addSubview(pageLabel)
        view.addSubview(actionBtn)
        
        collectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .left, animated: false)
        
    }
    
    func setupGesture() {
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowser.doubleTap))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowser.singleTap))
        
        view.addGestureRecognizer(singleTap)
        
        singleTap.require(toFail: doubleTap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(PhotoBrowser.longPress(_:)))
        view.addGestureRecognizer(longPress)
        
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(PhotoBrowser.pan(_:)))
        view.addGestureRecognizer(pan)
    }
    
    func setupLayout() {
        
        backgroundView.frame = view.bounds
        
        actionBtn.frame.size = CGSize(width: 44, height: 44)
        actionBtn.frame.origin.x = view.bounds.width - actionBtn.frame.width
        actionBtn.frame.origin.y = view.bounds.height - actionBtn.frame.height
        
        pageLabel.frame.size.height = actionBtn.frame.size.height
        pageLabel.frame.size.width = view.bounds.width
        pageLabel.frame.origin.y = view.bounds.height - pageLabel.frame.height
        
    }
    
}

extension PhotoBrowser {
    
    func pan(_ pan: UIPanGestureRecognizer) {
        
        let transition = pan.translation(in: view)
        
        let cell = collectionView.visibleCells.last
        
        switch pan.state {
        case .began:
            break
        case .ended, .cancelled, .failed, .possible:
            
            if transition.y > 30 {
                
                dismiss(animated: true, completion: nil)
                
            }else {
                
                UIView.animate(withDuration: 0.25, animations: {
                    
                    self.backgroundView.alpha = 1
                    cell?.transform = CGAffineTransform.identity
                })
                
            }
            
        case .changed:
            
            let scale = 1 - transition.y / UIScreen.main.bounds.height
            
            var transform = CGAffineTransform(translationX: transition.x, y: transition.y)
                
            if transition.y > 0 {
                transform = transform.concatenating(CGAffineTransform(scaleX: scale, y: scale))
            }
            
            backgroundView.alpha = scale
            
            cell?.transform = transform

            
        }
        
        
    }
    
    func doubleTap() {
        
        let cell = collectionView.visibleCells.last as? PhotoCell
        
        cell?.didZoom()
        
    }
    
    func singleTap() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func longPress(_ longPress: UILongPressGestureRecognizer) {
        
        
        if longPress.state == .began {
            
            actionBtnClick()
        }
    }
    
    func actionBtnClick() {
        
        let alertC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        alertC.addAction(UIAlertAction(title: "保存图片", style: .default, handler: { (_) in
            
            if let cell = self.collectionView.visibleCells.last as? PhotoCell, let image = cell.imageView.image {
                
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowser.image(image:didFinishSavingWithError:contextInfo:)), nil)
                
            }
            
        }))
        
        present(alertC, animated: true, completion: nil)
        
    }
    
    func image(image: UIImage, didFinishSavingWithError: Error?, contextInfo: Any?) {
    
        let hud = UILabel()
        hud.layer.cornerRadius = 5
        hud.textAlignment = .center
        hud.textColor = UIColor.white
        hud.font = UIFont.systemFont(ofSize: 14)
        hud.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        hud.clipsToBounds = true
        
        if didFinishSavingWithError == nil {
            
            hud.text = "保存成功"
        }else {
            hud.text = "保存失败"
        }
        
        hud.sizeToFit()
        hud.frame.size.width += 30
        hud.frame.size.height += 20
        
        hud.center = view.center
        hud.alpha = 0
        
        view.addSubview(hud)
        
        UIView.animate(withDuration: 0.25, animations: { 
            hud.alpha = 1
        }) { (_) in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: { 
                
                UIView.animate(withDuration: 0.25, animations: { 
                    hud.alpha = 0
                }, completion: { (_) in
                    hud.removeFromSuperview()
                })
                
            })
            
        }
        
    }
    
}


