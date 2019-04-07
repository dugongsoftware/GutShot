//
//  HomeViewController.swift
//  Poker
//
//  Created by Lucas Cullen on 4/4/19.
//  Copyright © 2019 Bitcoin Brisbane. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var labLocation: UIView!
    @IBOutlet weak var tblEvents: UITableView!
    
    fileprivate let apiURL = "https://dugongsoftware.github.io/GutShotFeed/tournaments.json"
    //private var data: [String] = []
    
    private var data = [EventDetailsViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let eventDetailsViewModel = EventDetailsViewModel(name: "Q&A", description: "Monday", start: Date(), buyIn: 100, fee: 10)
        
        self.data.append(eventDetailsViewModel)
        
        tblEvents.delegate = self
        tblEvents.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")! //1.
        let text = data[indexPath.row]._name //2.
        cell.textLabel?.text = text //3.
        
        return cell //4.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
