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
    
    var currentlySelectedButton: UIButton? = nil
    
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
        backgroundColor = Colors.red
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib.init(nibName: "SubCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "SubCell")
        addSubview(collectionView)
        collectionView.frame = CGRect(x: bounds.minX + opposingTeamButtonFrameWidth, y: bounds.minY, width: bounds.width - opposingTeamButtonFrameWidth, height: bounds.height)
        collectionView.backgroundColor = Colors.red
        
        opposingTeamButton.setTitle("Opp. Team", for: .normal)
        opposingTeamButton.frame = CGRect(x: bounds.minX, y: bounds.minY, width: opposingTeamButtonFrameWidth, height: bounds.height).insetBy(dx: 10, dy: 5)
        opposingTeamButton.backgroundColor = UIColor.white
        opposingTeamButton.setTitleColor(Colors.red, for: .normal)
        opposingTeamButton.titleLabel?.textAlignment = .center
        opposingTeamButton.titleLabel?.lineBreakMode = .byWordWrapping
        opposingTeamButton.titleLabel?.numberOfLines = 0
        opposingTeamButton.layer.cornerRadius = 10
        addSubview(opposingTeamButton)
        
        opposingTeamButton.addTarget(self, action: #selector(opposingTeamButtonPressed), for: .touchUpInside)
    }
    
    func setOpposingTeamButtonToSelected() {
        opposingTeamButton.backgroundColor = UIColor.darkGray
    }
    
    func setOpposingTeamButtonToNotSelected() {
        opposingTeamButton.backgroundColor = UIColor.white
    }
    
    @objc func opposingTeamButtonPressed() {
       delegate!.oppTeamButtonPressed()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return delegate!.getNumberOfPlayers() + 1
        return delegate!.getNumberOfPlayers()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCell", for: indexPath) as? SubCell {
            var numString = delegate!.getPlayerNumber()[indexPath.row]
            numString.removeFirst()
            cell.commonInit(number: Int(numString)!)
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }
    
    func buttonPressed(button: UIButton, number: Int) {
        delegate?.playerSelected(number: number)
        if currentlySelectedButton == nil {
            button.isSelected = true
            currentlySelectedButton = button
        }
        else {
            if currentlySelectedButton == button {
                button.isSelected = false
                currentlySelectedButton = nil
            }
            else {
                currentlySelectedButton!.isSelected = false
                button.isSelected = true
                currentlySelectedButton = button
            }
        }
    }
    
    func clearSelectedPlayer() {
        if currentlySelectedButton != nil {
            currentlySelectedButton?.isSelected = false
            currentlySelectedButton = nil
        }
    }
    
}
