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
        eventNameLabel.text = detail.name
        dateLabel.text = formatToString(str: detail.start!)
        addressLabel.text = detail.location
    }
    
    let cellImageView: UIImageView = {
        var iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "POKER")
        iv.contentMode = .scaleAspectFill
        //iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        return iv
    }()
    
    let eventNameLabel: UILabel = {
        var label = UILabel()
        label.text = "Event Name"
        return label
    }()
    
    let dateLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 8)
        label.text = "Date: "
        return label
    }()
    
    let addressLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 8)
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
        
        addSubview(eventNameLabel)
        eventNameLabel.anchor(top: topAnchor, left: cellImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 5, width: 0, height: 20)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: eventNameLabel.bottomAnchor, left: cellImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 5, width: 0, height: 20)
        
        addSubview(addressLabel)
        addressLabel.anchor(top: dateLabel.bottomAnchor, left: cellImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 5, width: 0, height: 20)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EventListCell {
    func formatToString(str: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "HH:mm"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "h:mm a"
        
        let date = dateFormatterGet.date(from: str)
        return dateFormatterPrint.string(from: date!)
    }
}
