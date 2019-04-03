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
    fileprivate let apiURL = "https://dugongsoftware.github.io/GutShotFeed/tournaments.json"
    fileprivate let padding: CGFloat = 16
    
    var eventList = StoredEvents.sharedInstance.collection
    
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
        pushToEventDetailController()
    }
    
    var selectedEvent: EventModel?
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexData = eventList[indexPath.row]
        self.selectedEvent = indexData
        pushToEventDetailController()
    }
    
    fileprivate func pushToEventDetailController() -> Void {
        let vc = EventDetailController()
        if let selectedEvent = selectedEvent {
            vc.selectedEvent = selectedEvent
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 175)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventListCell
        cell.cellDetail = eventList[indexPath.row]
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
                    //let start = eventDictionary!["start"] as? String
                    
                    let eventDetails = EventDetailsViewModel(name: eventname!, description: location!);
                    
                    let eventModel = EventModel(json: eventDictionary!)
                    
                    //for j in 0...5 {
                        //calc date
                        //with future date!
//                        let eventModel = EventModel(eventname: _name ?? "", _start: start ?? "", _buyin: buyin ?? 0, _fee: fee ?? 0, _location: location ?? "", _type: type ?? "", _stack: stack ?? 0, _levels: levels ?? 0, _rebuys: rebuys ?? false)
//
                        self.eventList.append(eventModel!)
                    //}
                }
                
                self.collectionView.reloadData()
                SwiftSpinner.hide()
            }
        }
    }
}
