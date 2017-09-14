//
//  BookingTableViewCell.swift
//  AnimationsProject
//
//  Created by Rama on 07/09/17.
//  Copyright © 2017 ongoStore. All rights reserved.
//

import UIKit

class BookingTableViewCell: UITableViewCell {
    var bgView = UIView()
    var headerLbl = UILabel()
    var detailCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Configure the view for the selected state
    
        self.customizeBgView()
         self.customizeDetailCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func customizeBgView(){
        let cellWidth = UIScreen.main.bounds.size.width
        let viewHeight:CGFloat = 260
        let cellFrame = CGRect(x: cellWidth/2, y: 0, width: cellWidth-20, height: viewHeight-10)
        

        self.headerLbl = UILabel.init(frame: CGRect(x:50
            , y: 0, width: 250, height: 30))
        self.headerLbl.font = UIFont(name:"Roboto-Bold", size:16)
        self.headerLbl.textAlignment = NSTextAlignment.center
        self.headerLbl.textColor = UIColor.black
       // self.headerLbl.layer.backgroundColor = UIColor.lightGray.cgColor
        self.addSubview(self.headerLbl)
    }
    
    func customizeDetailCollectionView(){
        
        let cellWidth = UIScreen.main.bounds.size.width
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left:0, bottom:0, right: 0)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.headerReferenceSize = CGSize.zero
        layout.footerReferenceSize = CGSize.zero
        
       // layout.itemSize = CXConstant.DetailCollectionCellSize
        self.detailCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.detailCollectionView.showsHorizontalScrollIndicator = false
        self.detailCollectionView.frame = CGRect(x: 8, y: self.headerLbl.frame.size.height, width: cellWidth-16, height: 50)
        
        // CXConstant.DetailCollectionViewFrame
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        detailCollectionView.register(UINib(nibName: "BookingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BookingCollectionViewCell")
        self.detailCollectionView.backgroundColor = UIColor.white
        self.addSubview(self.detailCollectionView)
        
    }
}
/*extension BookingTableViewCell {
    
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
    
}*/
extension BookingTableViewCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
         self.detailCollectionView.delegate = dataSourceDelegate
         self.detailCollectionView.dataSource = dataSourceDelegate
         self.detailCollectionView.tag = row
         self.detailCollectionView.setContentOffset(self.detailCollectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
         self.detailCollectionView.reloadData()
    }
    var collectionViewOffset: CGFloat {
        set {  self.detailCollectionView.contentOffset.x = newValue }
        get { return  self.detailCollectionView.contentOffset.x }
    }
}

