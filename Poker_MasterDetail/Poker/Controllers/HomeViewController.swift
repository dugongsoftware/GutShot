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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //
    }
}
