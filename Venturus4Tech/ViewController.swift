//
//  ViewController.swift
//  Venturus4Tech
//
//  Created by Gustavo Reder Cazangi on 21/07/17.
//  Copyright © 2017 Venturus. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var socket : SocketIOClient?
    var manager : SocketManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textField.delegate = self
        manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
        
        socket = manager?.defaultSocket
        
        socket?.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket?.on("messages") {data, ack in
            if let msgList = data[0] as? [[String: Any]]  {
                self.openChat(messages: msgList)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onButtonClick(_ sender: Any) {
        socket?.connect()
    }
    
    func openChat(messages:[[String: Any]]) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "chat") as! ChatController
        vc.userNick = textField.text
        vc.msgs = messages
        vc.socket = socket
        textField.text = ""
        self.present(vc, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

