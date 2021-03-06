//
//  OrderViewController.swift
//  2GO
//
//  Created by Pat Khai on 11/6/18.
//  Copyright © 2018 Pat Khai. All rights reserved.
//

import UIKit
import PKHUD
import Parse

class OrderViewController: UIViewController {

    @IBOutlet weak var itemLabel: UILabel!
    
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var taxAmountLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var lineImage: UIImageView!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var weAcceptLabel: UILabel!
    @IBOutlet weak var paymentMethodLabel: UIImageView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var expireLabel: UILabel!
    @IBOutlet weak var securityCodeLabel: UILabel!
    
    @IBOutlet weak var cardNameText: UITextField!
    @IBOutlet weak var cardNumberText: UITextField!
    
    @IBOutlet weak var expireText: UITextField!
    @IBOutlet weak var securityText: UITextField!
    
    @IBOutlet weak var checkoutButton: UIButton!
    
    var phoneNumber: String!
    var buyerName: String!
    var restaurantId: String!
    var cart: [OrderItem]!
    var subtotal: Double!
    
    var enabledColor = UIColor.init(red: 1.0, green: 0.576, blue: 0.0, alpha: 1.0)
    
    
    func disableButton() {
        checkoutButton.isEnabled = false
        checkoutButton.backgroundColor = UIColor.gray
    }
    
    func enableButton() {
        checkoutButton.backgroundColor = enabledColor
        checkoutButton.isEnabled = true
    }
    
    func checkPaymentFields() -> Bool {
        /*
        let nameTextCount = cardNameText.text?.count ?? 0
        if( nameTextCount == 0) {
            return false
        }
                
        if(securityText.text!.count < 3) {
            return false
        }
        
        if(expireText.text!.count < 3) {
            return false
        }*/
        return true
    }
    
    func verifyFields() {
        if(checkPaymentFields()) {
            enableButton()
        } else {
            disableButton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableButton()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        let sfSalesTax = 0.085
        let tax = sfSalesTax * subtotal
        let total = subtotal + tax
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        let nsNumberTax = NSNumber.init(value:tax)
        let nsNumbersubTotal = NSNumber.init(value:subtotal)
        let nsNumberTotal = NSNumber.init(value:total)
        
        let subtotalString = currencyFormatter.string(from: nsNumbersubTotal)!
        let taxString = currencyFormatter.string(from: nsNumberTax)!
        let totalString = currencyFormatter.string(from: nsNumberTotal)!

        subtotalLabel.text = subtotalString
        taxAmountLabel.text = taxString
        totalAmountLabel.text = totalString
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func didTapCheckout(_ sender: UIButton) {
        
        let newOrder = Order()
        newOrder.phoneNumber = phoneNumber
        newOrder.buyerName = buyerName
        newOrder.restaurantID = restaurantId
        
        // newOrder.addUniqueObject(cart, forKey: "order")
        
        for orderItem in cart {
            orderItem.addUniqueObject(newOrder, forKey: "order")
        }
        
        // show PKHUD
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()

        PFObject.saveAll(inBackground: cart) { (success: Bool, error: Error?) in
            if success {
                PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                PKHUD.sharedHUD.hide(afterDelay: 0.3, completion: { (success) in
                    self.performSegue(withIdentifier: "thankyou", sender: nil)
                })
            } else {
                print("save all orderItems in cart in background error: \(error!)")
            }
        }
        
    }
    
    
    @IBAction func onNameEdit(_ sender: UITextField) {
        verifyFields()
    }
    
    @IBAction func onSecurityCodeChange(_ sender: UITextField) {
        if( sender.text!.count > 4) {
            sender.text?.removeLast()
        }
        verifyFields()
    }
    
    @IBAction func onExpirationEdit(_ sender: UITextField) {
        if( sender.text!.count > 5) {
            sender.text?.removeLast()
        }
        verifyFields()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)


        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
