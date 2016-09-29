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
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.customizeBgView()
        self.customizeDetailCollectionView()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customizeBgView(){
        let cellWidth = UIScreen.mainScreen().bounds.size.width
        let viewHeight:CGFloat = CXConstant.RELATED_ARTICLES_CELL_HEIGHT-10
        let cellFrame = CGRectMake(10, 0, cellWidth-20, viewHeight-10)
        
        
        self.bgView = UIView.init(frame: cellFrame)//CXConstant.DetailTableView_Width
        //self.bgView.backgroundColor = UIColor.redColor()
        //self.bgView.layer.borderWidth = 1.0
        //self.bgView.backgroundColor = CXAppConfig.sharedInstance.getAppBGColor()//UIColor.whiteColor()
        self.addSubview(self.bgView)
        
        self.headerLbl = UILabel.init(frame: CGRectMake(0, 0, self.bgView.frame.size.width, 30))
        self.headerLbl.font = UIFont(name:"Roboto-Bold", size:16)
        self.headerLbl.textAlignment = NSTextAlignment.Left
        self.headerLbl.textColor = UIColor.grayColor()
        self.bgView.addSubview(self.headerLbl)
        
    }
    
    func customizeDetailCollectionView(){
        
        let cellWidth = UIScreen.mainScreen().bounds.size.width
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left:0, bottom:0, right: 0)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.headerReferenceSize = CGSizeZero
        layout.footerReferenceSize = CGSizeZero
        
        layout.itemSize = CXConstant.DetailCollectionCellSize
        self.detailCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        self.detailCollectionView.showsHorizontalScrollIndicator = false
        self.detailCollectionView.frame = CGRectMake(8, self.headerLbl.frame.size.height, cellWidth-16, CXConstant.DetailCollectionViewFrame.size.height)
        
        // CXConstant.DetailCollectionViewFrame
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.detailCollectionView.registerClass(OfferCollectionViewCell.self, forCellWithReuseIdentifier: "DetailCollectionViewCell")
        detailCollectionView.registerNib(UINib(nibName: "OfferCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OfferCollectionViewCell")
        self.detailCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCellID")
        self.detailCollectionView.backgroundColor = UIColor.clearColor()
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
    
    func setCollectionViewDataSourceDelegate<D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>(dataSourceDelegate: D, forRow row: Int) {
        
        self.detailCollectionView.delegate = dataSourceDelegate
        self.detailCollectionView.dataSource = dataSourceDelegate
        self.detailCollectionView.tag = row
        self.detailCollectionView.reloadData()
    }
    
}
