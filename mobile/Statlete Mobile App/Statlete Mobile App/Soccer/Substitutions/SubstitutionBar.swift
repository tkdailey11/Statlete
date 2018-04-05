//
//  SubstitutionBar.swift
//  Soccer
//
//  Created by Nate Gygi on 3/22/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class SubstitutionBar: UIControl, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    let numbers: [Int] = [3, 5, 7, 13, 15, 17, 23, 25, 28, 29, 31, 35, 37]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = UIColor.black
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib.init(nibName: "SubCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "SubCell")
        addSubview(collectionView)
        collectionView.frame = bounds
        collectionView.backgroundColor = UIColor.black
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCell", for: indexPath) as? SubCell {
            cell.commonInit(number: numbers[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
}
