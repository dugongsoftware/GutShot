//
//  EventDetailController.swift
//  BrisbanePoker
//
//  Created by AI on 30/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

import UIKit
import MapKit
import EventKit

class EventDetailController: UIViewController {
    
    var selectedEvent: EventModel? {
        didSet{
            setupTexts()
        }
    }
    
    fileprivate func setupTexts() {
        guard let event = selectedEvent else { return }
        eventNameLabel.text = event.name
        //calendarLabel.text = formatToString(str: event.start!)
        locationLabel.text = event.location
    }
    
    let eventImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "POKER")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let eventNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Poker Night in Brisbane"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .black
        return label
    }()
    
    let calendarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "calendar_logo")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let calendarLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    let locationImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "location_logo")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "back_icon"), for: .normal)
        button.tintColor = .lightGray
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    let saveToCalendarButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.mainBlue()
        button.setTitle("Add to Calendar", for: .normal)
        button.addTarget(self, action: #selector(saveToCalendar), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    
    let directionsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.mainBlue()
        button.setTitle("Directions", for: .normal)
        button.addTarget(self, action: #selector(giveDirections), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    
    @objc func saveToCalendar() {
        openCalendar()
    }
    
    @objc func giveDirections() {
        openGoogleMaps()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHUD()
    }
    
    fileprivate func setupHUD() {
        view.backgroundColor = UIColor.groupTableViewBackground
        
        view.addSubview(eventImageView)
        eventImageView.anchor(top: view.superview?.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.height*0.35)
        
        view.addSubview(eventNameLabel)
        eventNameLabel.anchor(top: eventImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 45)
        
        view.addSubview(calendarImageView)
        view.addSubview(locationImageView)
        calendarImageView.anchor(top: eventNameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 25, paddingBottom: 0, paddingRight: 15, width: 40, height: 40)
        locationImageView.anchor(top: calendarImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 35, paddingLeft: 25, paddingBottom: 0, paddingRight: 15, width: 40, height: 40)
        
        view.addSubview(calendarLabel)
        view.addSubview(locationLabel)
        calendarLabel.anchor(top: eventNameLabel.bottomAnchor, left: calendarImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 25, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
        locationLabel.anchor(top: calendarImageView.bottomAnchor, left: locationImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 35, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
        
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 45, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        let stackView = UIStackView(arrangedSubviews: [directionsButton, saveToCalendarButton])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 0, height: 45)
    }
    
}


extension EventDetailController {
    
    //GOOGLE MAPS
    fileprivate func openGoogleMaps() {
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {

            let address = selectedEvent?.location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let urlString = "comgooglemaps://?saddr=&daddr=" + address! + "&directionsmode=driving&zoom=17"
            
            UIApplication.shared.open(URL(string: urlString)!, options: [:])
            
        } else {
            //opening in apple maps
            let address = selectedEvent?.location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let urlString = "http://maps.apple.com/?daddr=" + address! + "&dirflg=r"
            
            UIApplication.shared.open(URL(string: urlString)!, options: [:])
        }
    }
    
    //CALENDAR
    fileprivate func openCalendar() {
        let eventStore : EKEventStore = EKEventStore()

        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                print("granted \(granted)")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                
                event.title = self.selectedEvent?.name
                let strDate = self.selectedEvent?.start
                event.startDate = strDate
                event.endDate = strDate
                event.notes = self.selectedEvent?.location
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                print("Saved Event")
            }
            else{
                print("failed to save event with error : error or  access not granted")
            }
        }
    }
}
