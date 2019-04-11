//
//  EventListCell.swift
//  BrisbanePoker
//
//  Created by AI on 29/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

import UIKit
import EventKit

protocol EventListCellDelegate {
    func presentSuccessPopUp()
}

class EventListCell: UITableViewCell {

    var delegate: EventListCellDelegate?
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
    
    lazy var saveToCalendarButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "calendar_logo"), for: .normal)
        button.addTarget(self, action: #selector(openCalendar), for: .touchUpInside)
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "share"), for: .normal)
        button.addTarget(self, action: #selector(sharePopUp), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHUD()
    }
    
    fileprivate func setupHUD() {
        addSubview(cellImageView)
        cellImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 90, height: 0)
        
        addSubview(eventTitleLabel)
        eventTitleLabel.anchor(top: topAnchor, left: cellImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 5, width: 0, height: 20)
        
        addSubview(eventDescriptionLabel)
        eventDescriptionLabel.anchor(top: eventTitleLabel.bottomAnchor, left: cellImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 5, width: 0, height: 20)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: eventDescriptionLabel.bottomAnchor, left: cellImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 5, width: 0, height: 20)
        
        addSubview(addressLabel)
        addressLabel.anchor(top: dateLabel.bottomAnchor, left: cellImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 5, width: 0, height: 20)
        
        addSubview(saveToCalendarButton)
        saveToCalendarButton.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 15, width: 30, height: 30)
        
        addSubview(shareButton)
        shareButton.anchor(top: nil, left: nil, bottom: bottomAnchor, right: saveToCalendarButton.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 10, width: 30, height: 30)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func openCalendar() {
        let eventStore : EKEventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                print("granted \(granted)")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = self.cellDetail?.name
                let strDate = self.cellDetail?.start
                event.startDate = strDate
                event.endDate = strDate
                event.notes = event.location
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                print("Saved Event")
                self.delegate?.presentSuccessPopUp()
            }
            else{
                print("failed to save event with error : error or  access not granted")
            }
        }
    }

    @objc func sharePopUp() {
        
        guard let event = cellDetail else {return}
        
        let textToShare = "Join me for Brisbane Poker Event - \(event.name) happening on \(Date.dateToString(date: event.start)) at \(event.location)!"
        let objectsToShare = [textToShare]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        let currentViewController:UIViewController=UIApplication.shared.keyWindow!.rootViewController!
        currentViewController.present(activityVC, animated: true, completion: nil)
    }
    
}

