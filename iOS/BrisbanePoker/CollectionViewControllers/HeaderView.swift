//
//  HeaderView.swift
//  BrisbanePoker
//
//  Created by AI on 29/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    let headerColorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainBlue()
        return view
    }()
    
    let whatsHappeningLabel: UILabel = {
        let label = UILabel()
        label.text = "What's Happening in"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Brisbane", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 45)])
        attributedText.append(NSAttributedString(string: "  tonight ?", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]))
        label.attributedText = attributedText
        label.textColor = .white
        return label
    }()
    
    let popularEventView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    let popularLabel: UILabel = {
        let label = UILabel()
        label.text = "Popular in Brisbane"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHUD()
    }
    
    func setupHUD() {
        
        addSubview(headerColorView)
        headerColorView.anchor(top: superview?.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 275)
        
        addSubview(whatsHappeningLabel)
        whatsHappeningLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 70, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 200, height: 30)
        
        addSubview(locationLabel)
        locationLabel.anchor(top: whatsHappeningLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        addSubview(popularEventView)
        popularEventView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 10, paddingRight: 15, width: 0, height: 225)
        setupPopularEventView()
        
        addSubview(popularLabel)
        popularLabel.anchor(top: nil, left: leftAnchor, bottom: popularEventView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 0, height: 20)
    }
    
    fileprivate func setupPopularEventView() {
        
        popularEventView.layer.borderColor = UIColor.lightGray.cgColor
        popularEventView.layer.borderWidth = 0.5
        
        popularEventView.addSubview(popularEventImageView)
        popularEventImageView.anchor(top: popularEventView.topAnchor, left: popularEventImageView.leftAnchor, bottom: nil, right: popularEventImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 175)
        popularEventImageView.clipsToBounds = true
        
        popularEventView.addSubview(popularEventNameLabel)
        popularEventNameLabel.anchor(top: popularEventImageView.bottomAnchor, left: popularEventView.leftAnchor, bottom: nil, right: popularEventView.rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 20)
        
        popularEventView.addSubview(popularEventAddressLabel)
        popularEventAddressLabel.anchor(top: popularEventNameLabel.bottomAnchor, left: popularEventView.leftAnchor, bottom: nil, right: popularEventView.rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 20)
    }
    
    let popularEventImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "POKER")
        return iv
    }()
    
    let popularEventNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Monday Poker Night"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let popularEventAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "Precinct Fortitude Valley"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
