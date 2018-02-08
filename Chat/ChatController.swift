//
//  ChatController.swift
//  Chat
//
//  Created by Arthur Jardim Giareta Conti on 07/02/2018.
//  Copyright © 2018 Arthur Jardim Giareta Conti. All rights reserved.
//

import UIKit
import SocketIO
import AVFoundation

class ChatController : UIViewController, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var textMsg: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var msgs : [[String:Any]] = []
    var nick : String?
    var socket : SocketIOClient?
    var player : AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        textMsg.delegate = self
        getHistory()
        registerSocketEvents()
        if (isSoundEnabled()) {
            soundButton.setTitle("Som ON", for: .normal)
        } else {
            soundButton.setTitle("Som OFF", for: .normal)
        }
    }
    
    func registerSocketEvents(){
        socket?.on("message", callback: { (data, ack) in
            if let aMsg = data as? [[String:Any]]{
                for i in 0..<aMsg.count {
                    self.msgs.append(aMsg[i])
                    self.updateTableView()
                    
                }
                self.playSound()
            }
        })
    }
    
    func updateTableView(){
        let lastIndexPath = IndexPath(row: self.msgs.count-1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [lastIndexPath], with: .automatic)
        tableView.endUpdates()
        tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
    }
    
    func getHistory(){
        let url = URL(string: "http://localhost:3001/history")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard error == nil else {
                print("Error on response")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("No data was sent")
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: responseData)
            if let msgList = json as? [[String:Any]] {
                self.msgs.append(contentsOf: msgList)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath(row: self.msgs.count-1, section: 0), at: .bottom, animated: true)
                }
            }
            
        }
        task.resume()
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "msg_sound", withExtension: "mp3") else {
            print("error")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else {
                return
            }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func saveSoundPref() {
        let defaults = UserDefaults.standard
        defaults.set(!isSoundEnabled(), forKey: "audio")
    }
    
    func isSoundEnabled() -> Bool {
        let defaults = UserDefaults.standard
        let enabled = defaults.bool(forKey: "audio")
        return enabled
    }
    
    @IBAction func onSoundButton(_ sender: Any) {
        saveSoundPref()
        guard let button = sender as? UIButton else {
            return;
        }
        
        if (isSoundEnabled()) {
            button.setTitle("Som ON", for: .normal)
        } else {
            button.setTitle("Som OFF", for: .normal)
        }
    }
    
    @IBAction func onSendButton(_ sender: Any) {
        var json : [String:Any] = [:]
        json["author"] = nick
        json["message"] = textMsg.text
        socket?.emit("message", json)
        textMsg.text = ""
    }
    
    @IBAction func onExitButton(_ sender: Any) {
        socket?.off("message") //remover o listener de "message" do socket
        socket?.disconnect()
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula_chat", for: indexPath) as! ChatCell
        let row = indexPath.row
        let msg = msgs[row]
        let author = msg["author"] as? String
        
        cell.labelNickname.text = author
        if (author != nil){
            cell.labelInitial.text = "\(author!.characters.first!)"
        }
        cell.labelMsg.text = msg["message"] as? String
        cell.labelTime.text = msg["time"] as? String
        
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
