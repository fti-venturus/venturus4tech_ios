//
//  ViewController.swift
//  Chat
//
//  Created by Arthur Jardim Giareta Conti on 07/02/2018.
//  Copyright © 2018 Arthur Jardim Giareta Conti. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var socket : SocketIOClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        socket = SocketIOClient(socketURL: URL(string: "http://localhost:3000")!, config: [])
        socket?.on(clientEvent: .connect, callback: { (data, socket) in
            self.textField.text = ""
            self.openChat()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openChat(){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "chat") as! ChatController
        vc.nick = textField.text
        vc.socket = socket
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onButtonClick(_ sender: UIButton) {
        socket?.connect()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

