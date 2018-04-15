//
//  SubstitutionBar.swift
//  Soccer
//
//  Created by Nate Gygi on 3/22/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

protocol SubstitutionBarDelegate: class {
    func oppTeamButtonPressed()
    func getPlayerNumber() -> [String]
    func getNumberOfPlayers() -> Int
    func playerSelected(number: Int)
}

class SubstitutionBar: UIControl, UICollectionViewDelegate, UICollectionViewDataSource, SubCellDelegate {
    
    func buttonPressed(number: Int) {
        delegate?.playerSelected(number: number)
    }
    
    
    weak var delegate: SubstitutionBarDelegate?
    
    let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    let opposingTeamButtonFrameWidth: CGFloat = 80.0
    let opposingTeamButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = Colors.color2
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib.init(nibName: "SubCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "SubCell")
        addSubview(collectionView)
        collectionView.frame = CGRect(x: bounds.minX + opposingTeamButtonFrameWidth, y: bounds.minY, width: bounds.width - opposingTeamButtonFrameWidth, height: bounds.height)
        collectionView.backgroundColor = Colors.color2
        
        opposingTeamButton.setTitle("Opp. Team", for: .normal)
        opposingTeamButton.frame = CGRect(x: bounds.minX, y: bounds.minY, width: opposingTeamButtonFrameWidth, height: bounds.height).insetBy(dx: 10, dy: 5)
        opposingTeamButton.backgroundColor = UIColor.white
        opposingTeamButton.setTitleColor(UIColor(red: 108.0/255.0, green: 12.0/255.0, blue: 12.0/255.0, alpha: 1.0), for: .normal)
        opposingTeamButton.titleLabel?.textAlignment = .center
        opposingTeamButton.titleLabel?.lineBreakMode = .byWordWrapping
        opposingTeamButton.titleLabel?.numberOfLines = 0
        opposingTeamButton.layer.cornerRadius = 10
        addSubview(opposingTeamButton)
        
        opposingTeamButton.addTarget(self, action: #selector(opposingTeamButtonPressed), for: .touchUpInside)
    }
    
    func setOpposingTeamButtonToSelected() {
        opposingTeamButton.backgroundColor = UIColor.red
    }
    
    func setOpposingTeamButtonToNotSelected() {
        opposingTeamButton.backgroundColor = UIColor.white
    }
    
    @objc func opposingTeamButtonPressed() {
       delegate!.oppTeamButtonPressed()
        setOpposingTeamButtonToSelected()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return delegate!.getNumberOfPlayers() + 1
        return delegate!.getNumberOfPlayers()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /*
        if indexPath.row == delegate!.getNumberOfPlayers() {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCell", for: indexPath) as? SubCell {
                cell.subButtonInit()
                return cell
            }
        }
         */
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCell", for: indexPath) as? SubCell {
            var numString = delegate!.getPlayerNumber()[indexPath.row]
            numString.removeFirst()
            cell.commonInit(number: Int(numString)!)
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }
    
}
