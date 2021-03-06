//
//  MenuViewController.swift
//  2GO
//
//  Created by Pat Khai on 10/17/18.
//  Copyright © 2018 Pat Khai. All rights reserved.
//

import UIKit
import AlamofireImage
import ParseUI
import PKHUD

class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuDescription: UILabel!
    @IBOutlet weak var menuTitle: UILabel!
    @IBOutlet weak var menuCost: UILabel!
    @IBOutlet weak var subView: UIView!

    @IBOutlet weak var menuImage: PFImageView!
    @IBOutlet weak var addCartButton: UIButton!
    
    var restaurant: Restaurant!
    var menu: MenuItem!
    var counterItem = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTitle.text = menu.name
        menuImage.file = menu.photo
        menuDescription.text = menu.menuItemDescription
        menuCost.text = "$\(menu.price)"
        subView.layer.cornerRadius = 5
        subView.clipsToBounds = true
        self.tabBarController?.tabBar.isHidden = false
     
        subViewEdit()
        menuImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300)
        menuImage.contentMode = .scaleAspectFill
        menuImage.clipsToBounds = true
        view.insertSubview(subView, aboveSubview: menuImage!)
        editButton()
        
        // Do any additional setup after loading the view.
    }
    
    func editButton() {
        addCartButton.layer.cornerRadius = 8
    
    }
    
    func subViewEdit() {
        subView.layer.cornerRadius = 8
        subView.layer.shadowRadius = 3.0
        subView.layer.shadowOpacity = 2.0
        subView.layer.shadowColor = UIColor.gray.cgColor
        subView.layer.shadowOffset = CGSize(width: 0, height: 5.0)
    
    }

    @IBAction func addtoCart(_ sender: UIButton) {
        let objectId = menu.objectId!
        let defaults = UserDefaults.standard
       
        var cart = defaults.array(forKey:"cart") as! [String]
        
        if defaults.string(forKey: "currentRestaurant") == nil || cart.count == 0{
            let currentId = restaurant.objectId
            defaults.set(currentId, forKey: "currentRestaurant")
        } else {
            let currentRestaurant = defaults.string(forKey: "currentRestaurant")
            if(currentRestaurant != restaurant.objectId) {
                // Ask if user wants to clear cart to add item from another restaurant?
                // if Yes, change restaurant to currentId
                let messageTitle = "Clear your cart?"
                let alertController = UIAlertController(title: messageTitle, message: "You can only order from one restaurant at a time", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                    let currentId = self.restaurant.objectId!
                    defaults.set(currentId,forKey: "currentRestaurant")
                    var cart = defaults.array(forKey:"cart") as! [String]
                    for item in cart {
                        defaults.removeObject(forKey: item)
                    }
                    cart.removeAll()
                    cart.append(objectId)
                    defaults.set(cart, forKey: "cart")
                    defaults.set(1, forKey: objectId)
                    defaults.synchronize()
                }
                let cancelAction = UIAlertAction(title: "No", style: .default) { (action) in
                }
                alertController.addAction(OKAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
                return
            }
        }
        if !cart.contains(objectId) {
            cart.append(objectId)
            defaults.set(cart, forKey: "cart")
            defaults.set(1,forKey: objectId)
            defaults.synchronize()
        } else {
            var amount = defaults.integer(forKey: objectId)
            amount+=1
            defaults.set(amount,forKey:objectId)
        }
        
        // show PKHUD
        PKHUD.sharedHUD.contentView = PKHUDSuccessView(title: "Added")
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 0.3, completion: { (success) in
        })
        
    }
    
    @IBAction func exitOnTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func alertControl(_ title: String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            // optional code for what happens after the alert controller has finished presenting
            
        }
    }
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 376 - (scrollView.contentOffset.y + 300)
        let height = min(max(y, 60), 400)
        menuImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
    }
    
    
}
