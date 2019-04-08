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
    fileprivate let apiURL = "https://dugongsoftware.github.io/GutShotFeed/v2/tournaments.json"
    fileprivate let padding: CGFloat = 16
    
    var eventList = StoredEvents.sharedInstance.collection
    var eventDetailsList = StoredEvents.sharedInstance.collection
    
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
        self.selectedEvent = eventList[0]
        //pushToEventDetailController()
    }
    
    var selectedEvent: EventDetailsViewModel?
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexData = eventDetailsList[indexPath.row]
        self.selectedEvent = indexData
        
        //pushToEventDetailController()
        
        let _message = "FEATURE COMING SOON " + indexData._name;
        let alert = UIAlertController(title: "Would you like to register?", message: _message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Call", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Fold", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func pushToEventDetailController() -> Void {
        let vc = EventDetailController()
        
        //TODO: LOAD FULL EVENT
        if let selectedEvent = selectedEvent {
            //vc.selectedEvent = selectedEvent
        }
        
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 175)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return eventList.count
        return eventDetailsList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventListCell
        //cell.cellDetail = eventList[indexPath.row]
        cell.cellDetail = eventDetailsList[indexPath.row]
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
                
                for i in 0...count-1 {
                    let event = swiftyJsonVar[i]
                    let eventDictionary = event.dictionaryObject
                    
                    //do the rest of the properties from json
                    let eventname = eventDictionary!["name"] as? String
                    let buyin = eventDictionary!["buyin"] as? Double
                    let fee = eventDictionary!["fee"] as? Double
                    let location = eventDictionary!["location"] as? String
                    
                    let type = eventDictionary!["type"] as? String
                    let stack = eventDictionary!["stack"] as? Double
                    let levels = eventDictionary!["levels"] as? Double
                    let rebuys = eventDictionary!["rebuys"] as? Bool
                    
                    let start = eventDictionary!["start"] as? String
                    
                    let start_string = start!.components(separatedBy: ":")
                    let frequency = eventDictionary!["frequency"] as? String

                    if (frequency == "weekly") {
                        
                        let calendar = Calendar(identifier: .gregorian)
                        let weekday = eventDictionary!["f_value"] as? Int
                        let _components = DateComponents(calendar: calendar, weekday: weekday)
                        
                        let nextEvent = calendar.nextDate(after: Date(), matching: _components, matchingPolicy: .nextTimePreservingSmallerComponents)
                        
                        for i in 0...5 {
                            var dateComponent = DateComponents()
                            dateComponent.day = 7 * i
                            dateComponent.hour = Int(start_string[0])
                            dateComponent.minute = Int(start_string[1])
                            
                            let futureDate = Calendar.current.date(byAdding: dateComponent, to: nextEvent!)
                            
                            let eventDetailsViewModel = EventDetailsViewModel(name: eventname!, description: location!, start: futureDate!, buyIn: buyin!, fee: fee!)
                            
                            self.eventDetailsList.append(eventDetailsViewModel)
                        }
                    }
                    
                    if (frequency == "once") {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy/MM/dd"
                        let f_value = eventDictionary!["f_value"] as? String
                        let _start = formatter.date(from: f_value!)
                        
                        var dateComponent = DateComponents()
                        dateComponent.hour = Int(start_string[0])
                        dateComponent.minute = Int(start_string[1])
                        
                        let _realStart = Calendar.current.date(byAdding: dateComponent, to: _start!)
                        
                        if (_realStart! > Date()) {
                            let eventDetailsViewModel = EventDetailsViewModel(name: eventname!, description: location!, start: _realStart!, buyIn: buyin!, fee: fee!)
                            
                            self.eventDetailsList.append(eventDetailsViewModel)
                        }
                    }
                    
                    self.eventDetailsList = self.eventDetailsList.sorted(by: {$0._start.timeIntervalSince1970 < $1._start.timeIntervalSince1970})
                    
                    //let eventModel = EventModel(json: eventDictionary!)
                    //self.eventList.append(eventModel!)
                }
                
                self.collectionView.reloadData()
                SwiftSpinner.hide()
            }
        }
    }
}
