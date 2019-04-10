//
//  EventListController.swift
//  BrisbanePoker
//
//  Created by AI on 30/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner

class EventListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    fileprivate let headerId = "headerId"
    fileprivate let apiURL = "https://dugongsoftware.github.io/GutShot/Data/tournaments.json"
    fileprivate let padding: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViewLayout()
        setupCollectionView()
        
        requestEventList()
    }
    
    fileprivate func setupCollectionViewLayout() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func setupCollectionView() {
        navigationController?.isNavigationBarHidden = true
        collectionView.bounces = false
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(EventListCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HeaderView
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(tapDetected))
        header.addGestureRecognizer(tapGestureRecognizer)
        
        return header
    }
    
    @objc func tapDetected() {
        //self.selectedEvent = eventList[0]
        //pushToEventDetailController()
    }
    
    var selectedEvent: EventModel?
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexData = StoredEvents.sharedInstance.collection[indexPath.row]
        self.selectedEvent = indexData
        
        //pushToEventDetailController()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d h:mma"
        
        let _message = "FEATURE COMING SOON " + indexData.name + " starting at " + formatter.string(from: indexData.start)
        let alert = UIAlertController(title: "Would you like to register?", message: _message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Call", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Fold", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func pushToEventDetailController() -> Void {
        /*
        let vc = EventDetailController()
        
        //TODO: LOAD FULL EVENT
        if let selectedEvent = selectedEvent {
            vc.selectedEvent = selectedEvent
        }
        
        self.navigationController?.pushViewController(vc, animated: true)*/
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 175)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(StoredEvents.sharedInstance.collection.count)
        return StoredEvents.sharedInstance.collection.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventListCell
        cell.cellDetail = StoredEvents.sharedInstance.collection[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 2 * padding, height: 100)
    }
}

extension EventListController {
    
    func requestEventList() {
        
        SwiftSpinner.show("Fetching events")
        
        Alamofire.request(apiURL).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                let count = swiftyJsonVar.count
                var events = [EventModel]() // temporary event-keeping array.
                
                //Loop through JSON entry ...
                for i in 0...count-1 {
                    let event = swiftyJsonVar[i]
                    let eventDictionary = event.dictionaryObject
                    let generatedEvents = self.generateEvents(dictionary: eventDictionary!) // generate Events based on if it's weekly, once, etc.
                    events += generatedEvents // add to event-keeping array
                }
                StoredEvents.sharedInstance.collection = events.sorted(by: {$0.start.timeIntervalSince1970 < $1.start.timeIntervalSince1970}) //store to master array, sorted by date
                self.collectionView.reloadData()
                SwiftSpinner.hide()
            }
        }
    }
    
    // This function will determine if passed json entry is a weekly or a one-time event and generate a single or multiple events accordingly.
    fileprivate func generateEvents(dictionary: [String: Any]) -> [EventModel] {
        var eventCollection = [EventModel]()
        let frequency = dictionary["frequency"] as! String
        let startTime = dictionary["start"] as! String
        let disabledEventDates = dictionary["disableEventDates"] as? [String] ?? []

        switch frequency {
        // EVENT IS A WEEKLY EVENT. Will return 5 events.
        case "weekly":
            let f_value = dictionary["f_value"] as! Int
            for i in 0...4 { // next 5 week's events will be fetched
                let eventDate = Calendar.fetch5NextWeekDates(i: i, weekday: f_value, startTime: startTime)
                if let newEvent = EventModel(json: dictionary, startDate: eventDate), !disabledEventDates.contains(Date.dateToString(date: eventDate)) { // only add the event if it is not included in disabledEvent list.
                    eventCollection.append(newEvent)
                }
            }
        // EVENT IS A ONE-TIME EVENT. Will return 1 event.
        default:
            let f_value = dictionary["f_value"] as! String
            let eventDate = Calendar.fetchOneTimeDate(dateString: f_value, startTime: startTime)
            if let newEvent = EventModel(json: dictionary, startDate: eventDate), eventDate > Date() { // don't add past events
                eventCollection.append(newEvent)
            }
        }
        return eventCollection
    }
    
}
