//
//  OfferFeaturedProductCell.swift
//  NowFloats
//
//  Created by apple on 01/09/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class OfferFeaturedProductCell: UITableViewCell {
    var bgView : UIView!
    var headerLbl: UILabel!
    var detailCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.backgroundColorOffer()
        //self.backgroundView?.backgroundColor = UIColor.clearColor()
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.customizeBgView()
        self.customizeDetailCollectionView()
        //self.detailCollectionView.reloadData()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func customizeBgView(){
        let cellWidth = UIScreen.main.bounds.size.width
        let viewHeight:CGFloat = CXConstant.RELATED_ARTICLES_CELL_HEIGHT-10
        let cellFrame = CGRect(x: 10, y: 5, width: cellWidth-20, height: viewHeight-5)
        
        
        
        self.bgView = UIView.init(frame: cellFrame)//CXConstant.DetailTableView_Width
        self.bgView.backgroundColor = UIColor.white
        self.bgView.layer.cornerRadius = 8.0
        //self.bgView.backgroundColor = CXAppConfig.sharedInstance.getAppBGColor()//UIColor.whiteColor()
        self.addSubview(self.bgView)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 25))
        view.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.bgView.addSubview(view)
        
        self.headerLbl = UILabel.init(frame: CGRect(x: 15, y: -3, width: self.bgView.frame.size.width, height: 25))
        self.headerLbl.font = UIFont(name:"Roboto-Bold", size:15)
        self.headerLbl.textAlignment = NSTextAlignment.left
        self.headerLbl.textColor = UIColor.black
        self.bgView.addSubview(self.headerLbl)
    }
    
    func customizeDetailCollectionView(){
        
        let cellWidth = UIScreen.main.bounds.size.width
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left:0, bottom:0, right: 0)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.headerReferenceSize = CGSize.zero
        layout.footerReferenceSize = CGSize.zero
        
        layout.itemSize = CXConstant.DetailCollectionCellSize
        self.detailCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.detailCollectionView.showsHorizontalScrollIndicator = false
        self.detailCollectionView.frame = CGRect(x: 8, y: self.headerLbl.frame.size.height+5, width: cellWidth-16, height: CXConstant.DetailCollectionViewFrame.size.height)
        
        // CXConstant.DetailCollectionViewFrame
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.detailCollectionView.register(OfferCollectionViewCell.self, forCellWithReuseIdentifier: "DetailCollectionViewCell")
        detailCollectionView.register(UINib(nibName: "OfferCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OfferCollectionViewCell")
        self.detailCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCellID")
        self.detailCollectionView.backgroundColor = UIColor.clear
        self.addSubview(self.detailCollectionView)
        
    }
}
extension OfferFeaturedProductCell {
    
    var collectionViewOffset: CGFloat {
        set {
            self.detailCollectionView.contentOffset.x = newValue
        }
        get {
            return detailCollectionView.contentOffset.x
        }
    }
    
    func setCollectionViewDataSourceDelegate(dataSource:UICollectionViewDataSource,delegate:UICollectionViewDelegate,forRow:Int){
        self.detailCollectionView.dataSource = dataSource
        self.detailCollectionView.delegate = delegate
        self.detailCollectionView.tag = forRow
        self.detailCollectionView.reloadData()
        
    }
    
    //    func setCollectionViewDataSourceDelegate<D: (UICollectionViewDataSource & UICollectionViewDelegate)>(_ dataSourceDelegate: D, forRow row: Int) {
    //
    //        self.detailCollectionView.delegate = dataSourceDelegate
    //        self.detailCollectionView.dataSource = dataSourceDelegate
    //        self.detailCollectionView.tag = row
    //        self.detailCollectionView.reloadData()
    //    }
    
}
