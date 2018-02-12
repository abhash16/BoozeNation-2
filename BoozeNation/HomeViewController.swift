//
//  MenuViewController.swift
//  BoozeNation
//
//  Created by Starlord on 23/08/17.
//  Copyright © 2017 Starlord. All rights reserved.
//


import UIKit
import Firebase
var CurrentCityLocation = "delhi"
var selectedTabBar = 1
let reachability = Reachability()!
class HomeViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,iCarouselDelegate,iCarouselDataSource{

    func changeTab(){
        self.tabBarController?.selectedIndex = selectedTabBar
    }
    
    @IBOutlet weak var floatButton: UIButton!
    @IBOutlet weak var _pageControl: UIPageControl!
    @IBOutlet weak var contentTableview: UITableView!
    @IBAction func changeLocation(_ sender: Any) {
        self.snakbarcitydikhao()
    }
    override func viewWillAppear(_ animated: Bool) {
        let notificationNme = NSNotification.Name("NotificationIdf")
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.changeTab), name: notificationNme, object: nil)
    }
    override func viewDidLoad() {
       contentTableview.estimatedRowHeight = 320
        contentTableview.rowHeight = UITableViewAutomaticDimension
        super.viewDidLoad()
        carousel.addSubview(_pageControl)
       
        loadImagesFromDatabase()
        carousel.type = .linear
        carousel.isScrollEnabled=true
        startTimer()

        contentTableview.estimatedRowHeight = 180
        contentTableview.rowHeight = UITableViewAutomaticDimension
        self.navigationItem.titleView = UIImageView.init(image: UIImage(named: "boozenation_logo.png"))
        self.navigationItem.titleView?.contentMode = .scaleAspectFit
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 5.0;
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0;
        self.navigationController?.navigationBar.layer.masksToBounds = false;
        self.navigationController?.navigationBar.layer.shadowPath = UIBezierPath(roundedRect:        (self.navigationController?.navigationBar.bounds)!, cornerRadius:(self.navigationController?.navigationBar.layer.cornerRadius)!).cgPath;
        self.navigationController?.navigationBar.backgroundColor=UIColor.white

//        _scrollView.isPagingEnabled = true
//       // _scrollView.frame = CGRect(x: 0, y: 60, width: self.view.frame.size.width, height: 120)
//        _scrollView.contentSize = CGSize(width: self.view.frame.width*3, height: 127)
//        _scrollView.delegate = self
        
        
        floatButton.layer.cornerRadius=floatButton.frame.size.width/2
//        floatButton.layer.shadowColor = UIColor.gray.cgColor
//        floatButton.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        floatButton.layer.shadowRadius = 2.0;
//        floatButton.layer.shadowOpacity = 2.0;
        floatButton.layer.masksToBounds = false;
        floatButton.layer.shadowPath = UIBezierPath(roundedRect:floatButton.bounds, cornerRadius:floatButton.layer.cornerRadius).cgPath;
        

               
        
        
        //loadImages()
    }
//Scroll view relate::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    
    var dynamicImagesUrl=[String]()

    
    
    
    func loadImagesFromDatabase(){
        
        Database.database().reference().child("banners").child("\(CurrentCityLocation)").observe(.childAdded){(snapshot:DataSnapshot) in
            
            let itemImage = snapshot.childSnapshot(forPath:"image").value!

            self.dynamicImagesUrl.append(itemImage as! String)
            self.carousel.reloadData()
        }
}
    
    //banner work:::::::::::::::::::::::::::::::
    
    
    @IBOutlet weak var carousel: iCarousel!
    
  
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        _pageControl.numberOfPages = dynamicImagesUrl.count
        return dynamicImagesUrl.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let tempView=UIView(frame:CGRect(x: 0, y: 0, width: self.carousel.frame.size.width, height: self.carousel.frame.size.height))
        //tempView.backgroundColor = UIColor.red
        let myimage = UIImageView(frame:CGRect(x: 5, y: 5, width: self.carousel.frame.size.width-10, height: self.carousel.frame.size.height-10))
        myimage.contentMode = .redraw
        
        myimage.sd_setImage(with: URL(string: dynamicImagesUrl[index]))
        tempView.addSubview(myimage)
        return tempView
    }
    
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option==iCarouselOption.spacing{
            return value * 1.0
        }
        return value
    }
    
    
    func scrollToNextCell(){
        
        if carousel.currentItemIndex==dynamicImagesUrl.count-1{
            carousel.scroll(byNumberOfItems: 1, duration: 0.4)
            carousel.currentItemIndex=0
           _pageControl.currentPage = carousel.currentItemIndex
           
        
        }
        else{
            carousel.scroll(byNumberOfItems: 1, duration: 0.4)
             _pageControl.currentPage = carousel.currentItemIndex+1
           
        }
       

    }
    
    
    func startTimer() {
        
        _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(HomeViewController.scrollToNextCell), userInfo: nil, repeats: true);
        
        
        
    }
    
    
    
/*func loadImages(){
                let imagesforScrollView = [UIImage(named: "banner_1.jpg"),UIImage(named: "Bira.jpg"),UIImage(named: "beer.png")]
                for i in 0..<imagesforScrollView.count{
                    let imageView = UIImageView(image: imagesforScrollView[i])
                    imageView.contentMode = .scaleAspectFit
                    imageView.frame.size.width = self.view.frame.width ; imageView.frame.size.height = 120
                    imageView.frame.origin.x = self.view.frame.width * CGFloat(i)
                    _scrollView.addSubview(imageView)
                }
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(moveImages), userInfo: nil, repeats: true)
  }
func moveImages(){
                    let pageWidth:CGFloat = self._scrollView.frame.width
                    let maxWidth:CGFloat = pageWidth * 3
                    let contentOffset:CGFloat = self._scrollView.contentOffset.x
                    
                    var slideToX = contentOffset + pageWidth
                    
                    if  contentOffset + pageWidth == maxWidth{
                        slideToX = 0
                    }
                    self._scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self._scrollView.frame.height), animated: true)
    
}
    
    
func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = carousel.contentOffset.x/carousel.frame.size.width
        _pageControl.currentPage = Int(page)
}*/
//TableView Delegate and DataSource::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1{
          return 1
        }
        else {
            return 4
        }
    }
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! HomeCell
            cell._cView.sizeToFit()
            cell._cView.layoutSubviews()
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
            return  cell
        }
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventsCell", for: indexPath)
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
            return cell
            
        }
        else{
            if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "promotionCell0", for: indexPath)
            return  cell
            }
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "promotionCell1", for: indexPath)
                return  cell
            }
            if indexPath.row == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "promotionCell2", for: indexPath)
                return  cell
            }
            else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "socialCell", for: indexPath) as! SocialCell
                cell._facebookIV.isUserInteractionEnabled = true;cell._instagramIV.isUserInteractionEnabled = true
                cell._twitterIV.isUserInteractionEnabled = true;cell._googleIV.isUserInteractionEnabled = true
            
        cell._facebookIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(facebookURL)))
        cell._twitterIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(twitterURL)))
        cell._instagramIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(instagramURL)))
        cell._googleIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(googleURL)))
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
            return  cell
            }
            
    }
}
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            print("\n\ndafaaf :\(self.view.frame.height/3.2)\n\n")
            return 214
        }
        if indexPath.section == 1{
            return 80
        }
        else{
            if indexPath.row == 0 {
                return 111
            }
            if indexPath.row == 1{
                return 103
            }
            if indexPath.row == 2{
                return 161
            }
            else{
                return 64
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 5, width: tableView.frame.width, height: 30))
        headerLabel.layer.cornerRadius = 5.0
        ;headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        headerLabel.backgroundColor = UIColor.white
        headerLabel.textAlignment = .center;headerLabel.textColor = UIColor(red: 254/255, green: 99/255, blue: 0/255, alpha: 0.8)
        headerView.backgroundColor = UIColor.groupTableViewBackground
        headerView.addSubview(headerLabel)
        headerLabel.font = UIFont.boldSystemFont(ofSize: 15) 
        if section == 0 {
            headerLabel.text = "Booze Menu"; return headerView
        }
        if section == 1{
            headerLabel.text = "Events"; return headerView
        }
        else {
            headerLabel.text = "Offers And Contests"; return headerView
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0{
                let cell = tableView.cellForRow(at: indexPath)
                UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [],
                               animations: {
                cell!.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                                
                },
                               completion: { finished in
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                    cell!.transform = CGAffineTransform(scaleX: 1, y: 1)
                                },
                                               completion: { finished in
                                                //pastItem = currentStripItem
    currentStripItem = "event".lowercased() ; collectionClicked = true
    let notificationNme = NSNotification.Name("NotificationIdf");NotificationCenter.default.post(name: notificationNme, object: nil)
                                }
                                )
                }
                )            }
        }
    }
    
}
class SocialCell:UITableViewCell{
    @IBOutlet weak var _facebookIV: UIImageView!
    @IBOutlet weak var _twitterIV: UIImageView!
    @IBOutlet weak var _instagramIV: UIImageView!
    @IBOutlet weak var _googleIV: UIImageView!

}

//collectionView with DAARU::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
class HomeCell:UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var _cView: UICollectionView!
    let daaruName=["Beer","Whiskey","Vodka","Rum","Wine","Cocktail","Mocktail","Specials"]
var daaruImages = ["beer.png","whiskey.png","vodka.png","rum.png","wine.png","cocktail.png","mocktails.png","specials-2.png"]
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daaruName.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "daarucell", for: indexPath) as! collectionCell
        cell.daaruName.text = daaruName[indexPath.item]
        cell.daaruImage.image = UIImage(named: daaruImages[indexPath.item])
        return cell
    }
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(daaruName[indexPath.item]," daaru")
        let cell = collectionView.cellForItem(at: indexPath)
        
    UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [],
                                   animations: {
                                    cell!.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                                    
        },
                                   completion: { finished in
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                                                                cell!.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    },
                                                                completion: { finished in
        //pastItem = currentStripItem
        currentStripItem = self.daaruName[indexPath.item].lowercased() ; collectionClicked = true
    let notificationNme = NSNotification.Name("NotificationIdf");NotificationCenter.default.post(name: notificationNme, object: nil)
                                    }
                                    )
        }
        )
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.sizeToFit()
        return CGSize(width: 92, height: 96)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
}

class collectionCell: UICollectionViewCell {
    @IBOutlet weak var daaruName: UILabel!
    @IBOutlet weak var daaruImage: UIImageView!
    
}



















































extension UIViewController{
    
    func facebookURL(){
        if UIApplication.shared.canOpenURL(URL(string: "fb://profile/Booze-Nation-1358615470859384")!){
         UIApplication.shared.open(URL(string: "fb://profile/Booze-Nation-1358615470859384")!, options: [:], completionHandler: nil)
        }
        else{
            UIApplication.shared.open(URL(string: "https://www.facebook.com/Booze-Nation-1358615470859384/")!, options: [:], completionHandler: nil)}
 }
    func twitterURL(){
        if UIApplication.shared.canOpenURL(URL(string: "twitter://user?screen_name=theboozenation")!){
            UIApplication.shared.open(URL(string: "twitter://user?screen_name=theboozenation")!, options: [:], completionHandler: nil)}
        else{
            UIApplication.shared.open(URL(string: "https://twitter.com/theboozenation")!, options: [:], completionHandler: nil)}
    }
    func instagramURL(){
        if UIApplication.shared.canOpenURL(URL(string: "instagram://user?username=theboozenation")!){
            UIApplication.shared.open(URL(string: "instagram://user?username=theboozenation")!, options: [:], completionHandler: nil)}
        else{
            UIApplication.shared.open(URL(string: "https://www.instagram.com/theboozenation/")!, options: [:], completionHandler: nil)}
    }
    func googleURL(){
        if UIApplication.shared.canOpenURL(URL(string: "gplus://plus.google.com/114867779232107565712")!){
            UIApplication.shared.open(URL(string: "gplus://plus.google.com/114867779232107565712")!, options: [:], completionHandler: nil)}
        else{
            UIApplication.shared.open(URL(string:"https://plus.google.com/114867779232107565712")!, options: [:], completionHandler: nil)}
    }
    
    
}


