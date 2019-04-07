//
//  HomeViewController.swift
//  Poker
//
//  Created by Lucas Cullen on 4/4/19.
//  Copyright © 2019 Bitcoin Brisbane. All rights reserved.
//

import UIKit

import SwiftyJSON
import Alamofire

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var detailViewController: DetailViewController? = nil
    
    @IBOutlet var labLocation: UIView!
    @IBOutlet weak var tblEvents: UITableView!
    
    fileprivate let apiURL = "https://dugongsoftware.github.io/GutShotFeed/tournaments.json"
    var eventDetailsList = StoredEvents.sharedInstance.collection

    override func viewDidLoad() {
        super.viewDidLoad()

        self.requestEventList()
        
        tblEvents.delegate = self
        tblEvents.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tblEvents.indexPathForSelectedRow {
                //let object = objects[indexPath.row] as! NSDate
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = nil //eventDetailsList
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventDetailsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!
        let text = self.eventDetailsList[indexPath.row]._name
        cell.textLabel?.text = text
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func requestEventList() {
        
        //SwiftSpinner.show("Fetching events...")
        
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
                    
                    //let type = eventDictionary!["type"] as? String
                    //let stack = eventDictionary!["stack"] as? Double
                    //let levels = eventDictionary!["levels"] as? Double
                    //let rebuys = eventDictionary!["rebuys"] as? Bool
                    
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
                        formatter.dateFormat = "yyyy/MM/dd HH:mm"
                        let f_value = eventDictionary!["f_value"] as? String
                        let _start = formatter.date(from: f_value!)
                        
                        let eventDetailsViewModel = EventDetailsViewModel(name: eventname!, description: location!, start: _start!, buyIn: buyin!, fee: fee!)
                        
                        self.eventDetailsList.append(eventDetailsViewModel)
                    }
                    
                    self.eventDetailsList = self.eventDetailsList.sorted(by: {$0._start.timeIntervalSince1970 < $1._start.timeIntervalSince1970})
                    
                    //let eventModel = EventModel(json: eventDictionary!)
                    //self.eventList.append(eventModel!)
                }
                
                self.tblEvents.reloadData()
                //SwiftSpinner.hide()
            }
        }
    }
}
