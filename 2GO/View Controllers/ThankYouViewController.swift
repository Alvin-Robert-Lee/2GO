//
//  ThankYouViewController.swift
//  2GO
//
//  Created by Pat Khai on 11/6/18.
//  Copyright © 2018 Pat Khai. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController {

    @IBOutlet weak var thankyouLabel: UILabel!
    @IBOutlet weak var orderReadyLabel: UILabel!
    
    
    @IBAction func didTapOK(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        var cart = defaults.array(forKey:"cart") as! [String]
        cart.removeAll()
        defaults.set(cart, forKey: "cart")
        defaults.synchronize()
        self.performSegue(withIdentifier: "home", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
