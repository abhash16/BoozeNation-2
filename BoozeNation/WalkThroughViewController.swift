//
//  WalkThroughViewController.swift
//  BoozeNation
//
//  Created by Bimlesh Singh on 03/09/17.
//  Copyright © 2017 Abhishek Chaudhary. All rights reserved.
//

import UIKit
import Canvas

class WalkThroughViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet var animationView: CSAnimationView!
    
    @IBOutlet weak var prevbuttn: UIButton!
    @IBOutlet weak var nextbuttn: UIButton!
    @IBOutlet weak var getstarted: UIButton!
    @IBOutlet weak var pagecontrol: UIPageControl!
    
    @IBOutlet weak var walkthroughcollectionview: UICollectionView!
    fileprivate var currentPage: Int = 0
  
    
    var index = 0
    var WTimagename = ["tuto1.png","tuto2.png","newtuto3.png","tuto4.png"]
    fileprivate var pageSize: CGSize {
        let layout = self.walkthroughcollectionview.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
    
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    fileprivate var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        prevbuttn.isHidden = true
        getstarted.isHidden = true
        prevbuttn.layer.cornerRadius = 15
        prevbuttn.layer.masksToBounds = true
        nextbuttn.layer.cornerRadius = 15
        nextbuttn.layer.masksToBounds = true
        getstarted.layer.cornerRadius = 10
        getstarted.layer.masksToBounds  = true
        
        
        
        walkthroughcollectionview.delegate = self
        walkthroughcollectionview.dataSource = self
       self.setupLayout()

        NotificationCenter.default.addObserver(self, selector: #selector(WalkThroughViewController.rotationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    fileprivate func setupLayout() {
        let layout = self.walkthroughcollectionview.collectionViewLayout as! UPCarouselFlowLayout
//        layout.sectionInset = UIEdgeInsets(top: 05, left: 10, bottom: 20, right: 10)

        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 30)
    }

    
    
    @objc fileprivate func rotationDidChange() {
        guard !orientation.isFlat else { return }
        let layout = self.walkthroughcollectionview.collectionViewLayout as! UPCarouselFlowLayout
        let direction: UICollectionViewScrollDirection = UIDeviceOrientationIsPortrait(orientation) ? .horizontal : .horizontal
        layout.scrollDirection = direction
        if currentPage > 0 && currentPage < 4{
            let indexPath = IndexPath(item: currentPage, section: 0)
            let scrollPosition: UICollectionViewScrollPosition = UIDeviceOrientationIsPortrait(orientation) ? .centeredHorizontally : .centeredHorizontally
            self.walkthroughcollectionview.scrollToItem(at: indexPath, at: scrollPosition, animated: false)
        }
    }
    

    
    
     // MARK: - Card Collection Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WTimagename.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalkThroughCollectionCell", for: indexPath) as! WalkThroughCollectionViewCell
        
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        cell.layer.shadowRadius = 10.0
        cell.layer.shadowOpacity = 0.8
        cell.WTImage.image = UIImage(named: WTimagename[indexPath.item])
              return cell
           }
   
     // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.walkthroughcollectionview.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
       
     sethidden()
        
    }
    
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
   
    
    {
    let pageWidth = scrollView.frame.width - 100
        self.currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        self.pagecontrol.currentPage = self.currentPage
       
       
                //print(currentPage)
    }
  
    @IBAction func tutonext(_ sender: Any) {
     
        self.walkthroughcollectionview.contentOffset.x += 280
        
        let indexPath = IndexPath(item: currentPage, section: 0)
       let scrollPosition: UICollectionViewScrollPosition = UIDeviceOrientationIsPortrait(orientation) ? .centeredHorizontally : .centeredVertically
        self.walkthroughcollectionview.scrollToItem(at: indexPath, at: scrollPosition, animated: true)
        
    sethidden()

    }
    
    
    
    
    @IBAction func tutoprev(_ sender: Any) {
        
    
        self.walkthroughcollectionview.contentOffset.x -= 280
        
        let indexPath = IndexPath(item: currentPage, section: 0)
        let scrollPosition: UICollectionViewScrollPosition = UIDeviceOrientationIsPortrait(orientation) ? .centeredHorizontally : .centeredVertically
        self.walkthroughcollectionview.scrollToItem(at: indexPath, at: scrollPosition, animated: true)

        sethidden()
        
        
    }
    
    
    
    
       @IBAction func tutoends(_ sender: Any) {
//        let userdefault = UserDefaults.standard
//        userdefault.set(true, forKey: "DisplayedWalkThrough")
//        self.dismiss(animated: true, completion: nil)
//        

    }
    
    func sethidden(){
        
        
        
        var visibleRect = CGRect()
        
        visibleRect.origin = walkthroughcollectionview.contentOffset
        visibleRect.size = walkthroughcollectionview.bounds.size
        
        let visiblePoint =  CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        let visibleIndexPath: IndexPath = walkthroughcollectionview.indexPathForItem(at: visiblePoint)!
        if visibleIndexPath.item == 0
        {
            prevbuttn.isHidden = true
            getstarted.isHidden = true
            nextbuttn.isHidden = false
        }else if visibleIndexPath.item == 1
        {
            prevbuttn.isHidden = false
            nextbuttn.isHidden = false
            getstarted.isHidden = true
            
        }else if visibleIndexPath.item == 2
        {
            nextbuttn.isHidden = false
            prevbuttn.isHidden = false
            getstarted.isHidden = true
        }
        else if visibleIndexPath.item == 3
        {
            nextbuttn.isHidden = true
            getstarted.isHidden = false
            prevbuttn.isHidden = false
            animationView.startCanvasAnimation()
            
        }
        
    }
    
    
}
