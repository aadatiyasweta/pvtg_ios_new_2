//
//  PaymentVC.swift
//  PVTG
//
//  Created by Techugo on 22/06/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit


// Check full documentation: http://mercadopago.github.io/px-ios/v4/
class PaymentVC: UIViewController {
//    private var checkout: MercadoPagoCheckout?
    
    // Collector Public Key
    private var publicKey : String = ""
    
    // Payer private key
    private var privateKey : String = ""
    
    // Preference ID
    private var preferenceId : String = "656525290-7bda964b-26d9-4352-a04c-1b04801627ee"
    
    @IBAction func initDefault(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

