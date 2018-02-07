//
//  ViewController.swift
//  Chat
//
//  Created by Arthur Jardim Giareta Conti on 07/02/2018.
//  Copyright © 2018 Arthur Jardim Giareta Conti. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onButtonClick(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "chat")
        self.present(vc, animated: true, completion: nil)
    }

}

