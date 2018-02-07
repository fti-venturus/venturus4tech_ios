//
//  ChatController.swift
//  Venturus4Tech
//
//  Created by Gustavo Reder Cazangi on 21/07/17.
//  Copyright © 2017 Venturus. All rights reserved.
//

import UIKit

class ChatController : UIViewController, UITableViewDataSource {
    
    var userNick : String?;
    
    var msgs : [[String: Any]] = [];
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        //Remove os separadores de celulas vazias...
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func onSendClick(_ sender: Any) {
        var json : [String : Any] = [:];
        json["author"] = "Guca"
        json["message"] = "E ae, tudo bem?"
        json["time"] = "123456"
        msgs.append(json)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: msgs.count-1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula_chat", for: indexPath) as! ChatCell
        
        return cell
    }
 
    
}
