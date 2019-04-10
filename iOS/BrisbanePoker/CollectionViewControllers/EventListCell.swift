//
//  EventListCell.swift
//  BrisbanePoker
//
//  Created by AI on 29/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

import UIKit

class EventListCell: UICollectionViewCell {
    
    var cellDetail: EventModel? {
        didSet{
            setupCellDetails()
        }
    }
    
    fileprivate func setupCellDetails() {
        guard let detail = self.cellDetail else {return}
        eventTitleLabel.text = detail.name
        eventDescriptionLabel.text = detail.description
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d h:mma"
        dateLabel.text = dateFormatter.string(from: detail.start)
        addressLabel.text = detail.location

        if detail.imageURL != "" {
            cellImageView.loadImage(urlString: detail.imageURL)
        } else {
            cellImageView.image = #imageLiteral(resourceName: "POKER")
        }
        
    }
    
    let cellImageView: CustomImageView = {
        var iv = CustomImageView()
        iv.image = #imageLiteral(resourceName: "POKER")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let eventTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "Event title: "
        return label
    }()
    
    let eventDescriptionLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Event description: "
        return label
    }()
    
    let dateLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Date: "
        return label
    }()
    
    let addressLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Address: "
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHUD()
    }
    
    fileprivate func setupHUD() {
        addSubview(cellImageView)
        cellImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 90, height: 0)
        
        addSubview(eventTitleLabel)
        eventTitleLabel.anchor(top: topAnchor, left: cellImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 5, width: 0, height: 20)
        
        addSubview(eventDescriptionLabel)
        eventDescriptionLabel.anchor(top: eventTitleLabel.bottomAnchor, left: cellImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 5, width: 0, height: 20)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: eventDescriptionLabel.bottomAnchor, left: cellImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 5, width: 0, height: 20)
        
        addSubview(addressLabel)
        addressLabel.anchor(top: dateLabel.bottomAnchor, left: cellImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 5, width: 0, height: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
