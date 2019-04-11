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
import EventKit

class EventListController: UITableViewController, EventListCellDelegate {

    fileprivate let cellId = "cellId"
    fileprivate let headerId = "headerId"
    fileprivate let apiURL = "https://dugongsoftware.github.io/GutShot/Data/tournaments.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHUD()
        tableView.register(EventListCell.self, forCellReuseIdentifier: cellId)
        requestEventList()
    }
    
    fileprivate func setupHUD() {
        self.title = "GutShot Brisbane"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
    }
    
    var selectedEvent: EventModel?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // avoid grey animation
        let indexData = StoredEvents.sharedInstance.sectionCollection[indexPath.section][indexPath.row]
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(30)
    }
 
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Header"
        label.backgroundColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 20)
    
        switch section {
        case 0:
            label.text = " Next Event"
        case 1:
            label.text = " This Week"
        case 2:
            label.text = " This Month"
        default:
            label.text = " Coming Up"
        }
        return label
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EventListCell
        cell.cellDetail = StoredEvents.sharedInstance.sectionCollection[indexPath.section][indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StoredEvents.sharedInstance.sectionCollection[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return StoredEvents.sharedInstance.sectionCollection.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(110)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, -10, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0.03
        UIView.animate(withDuration: 0.2) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    
    func presentSuccessPopUp() {
        let _message = "Successfully saved to calendar."
        let alert = UIAlertController(title: "See you soon!", message: _message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
                self.sortIntoSections()
                self.tableView.reloadData()
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
    
    
    fileprivate func sortIntoSections() {
        var next = [EventModel]()
        var thisWeek = [EventModel]()
        var thisMonth = [EventModel]()
        var rest = [EventModel]()
        
        let weeklyRange = Date()...Date().addingTimeInterval(604800)
        let monthlyRange = Date()...Date().addingTimeInterval(2618784)
        
        var collection = StoredEvents.sharedInstance.collection
        let count = collection.count
        for index in 0...count-1 {
            let event = collection[index]
            if index == 0 { // fetch first event in the list
                next.append(event)
            } else if weeklyRange.contains(event.start) {
                thisWeek.append(event)
            } else if monthlyRange.contains(event.start) {
                thisMonth.append(event)
            } else {
                rest.append(event)
            }
        }
        
        StoredEvents.sharedInstance.sectionCollection.append(contentsOf: [next, thisWeek, thisMonth, rest])
    }
    
    
}
