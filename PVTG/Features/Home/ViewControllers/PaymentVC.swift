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
        //         runMercadoPagoCheckout()
        //         runMercadoPagoCheckoutWithLifecycle()
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
//    func doPayment(){
//        let items: [PXItem] = [PXItem.init(title: "Regalo", quantity: 1, unitPrice: 200)]
//        let check = PXCheckoutPreference.init(siteId: "MCO", payerEmail: "email@example.com", items: items)
//        let paymentProcessor : PXPaymentProcessor = CustomPaymentProcessor()
//        let payment = PXPaymentConfiguration.init(paymentProcessor: paymentProcessor)
//        let builder = MercadoPagoCheckoutBuilder(publicKey: "TEST-4763b824-93d7-4ca2-a7f7-93539c3ee5bd", checkoutPreference: check, paymentConfiguration: payment)
//        checkout = MercadoPagoCheckout(builder: builder)
//        if let myNavigationController = navigationController {
//            checkout?.start(navigationController: myNavigationController)
//        }
//    }
//    private func runMercadoPagoCheckout() {
//        // 1) Create Builder with your publicKey and preferenceId.
//
//        // 2) Create Checkout reference
//
//
//        var pxPaymentTypeChargeRules : [PXPaymentTypeChargeRule] = []
//
//        pxPaymentTypeChargeRules.append(PXPaymentTypeChargeRule.init(paymentMethdodId: PXPaymentTypes.ACCOUNT_MONEY.rawValue, amountCharge: 10.00 ))
//        let paymentProcessor : PXPaymentProcessor = CustomPaymentProcessor()
//        let paymentConfiguration = PXPaymentConfiguration(paymentProcessor: paymentProcessor)
//        paymentConfiguration.addChargeRules(charges: pxPaymentTypeChargeRules)
//        let builder = MercadoPagoCheckoutBuilder.init(publicKey: publicKey, preferenceId: preferenceId, paymentConfiguration: paymentConfiguration)
//        checkout = MercadoPagoCheckout.init(builder: builder)
//        // 3) Start with your navigation controller.
//        if let myNavigationController = navigationController {
//            checkout?.start(navigationController: myNavigationController)
//        }
//    }
    
   /* private func runMercadoPagoCheckoutWithLifecycleAndCustomProcessor() {
        
        // Create charge rules
        var pxPaymentTypeChargeRules : [PXPaymentTypeChargeRule] = []
        
        pxPaymentTypeChargeRules.append(PXPaymentTypeChargeRule.init(paymentMethdodId: PXPaymentTypes.ACCOUNT_MONEY.rawValue, amountCharge: 10.00 ))
        
        
        // Create an instance of your custom payment processor
        let paymentProcessor : PXPaymentProcessor = CustomPaymentProcessor()
        
        // Create a payment configuration instance using the recently created payment processor
        let paymentConfiguration = PXPaymentConfiguration(paymentProcessor: paymentProcessor)
        
        // Add charge rules
        paymentConfiguration.addChargeRules(charges: pxPaymentTypeChargeRules)
        
        // Create a Builder with your publicKey, preferenceId and paymentConfiguration
        let builder = MercadoPagoCheckoutBuilder(publicKey: publicKey, preferenceId: preferenceId, paymentConfiguration: paymentConfiguration).setLanguage("es")
        
        //        let checkoutPreference = PXCheckoutPreference.init(preferenceId: preferenceId)
        //
        //        let builder = MercadoPagoCheckoutBuilder.init(publicKey: publicKey, checkoutPreference: checkoutPreference, paymentConfiguration: paymentConfiguration)
        
        // Instantiate a configuration object
        let configuration = PXAdvancedConfiguration()
        
        // Set expressEnabled true to use one-tap instead of groups flow
        configuration.expressEnabled = true
        
        // Add custom PXDynamicViewController component
        configuration.dynamicViewControllersConfiguration = [CustomPXDynamicComponent()]
        
        // Configure the builder object
        builder.setAdvancedConfiguration(config: configuration)
        
        // Set the payer private key
        builder.setPrivateKey(key: privateKey)
        
        // Create Checkout reference
        checkout = MercadoPagoCheckout(builder: builder)
        
        // Start with your navigation controller.
        if let myNavigationController = navigationController {
            checkout?.start(navigationController: myNavigationController, lifeCycleProtocol: self)
        }
    }
    */
}

// MARK: Optional Lifecycle protocol implementation example.
//extension PaymentVC: PXLifeCycleProtocol {
//    func finishCheckout() -> ((PXResult?) -> Void)? {
//        return nil
//    }
//
//    func cancelCheckout() -> (() -> Void)? {
//        return nil
//    }
//
//    func changePaymentMethodTapped() -> (() -> Void)? {
//        return { () in
//            print("px - changePaymentMethodTapped")
//        }
//    }
//}
//class CustomPaymentProcessor : NSObject, PXPaymentProcessor {
//
//    var checkoutStore : PXCheckoutStore?
//
//    func startPayment(checkoutStore: PXCheckoutStore, errorHandler: PXPaymentProcessorErrorHandler, successWithBusinessResult: @escaping ((PXBusinessResult) -> Void), successWithPaymentResult: @escaping ((PXGenericPayment) -> Void)) {
//        print("Start payment")
//
//    }
//
//    func paymentProcessorViewController() -> UIViewController? {
//        return nil
//    }
//
//    func support() -> Bool {
//        return true
//    }
//
//    func didReceive(checkoutStore: PXCheckoutStore) {
//        print("Receiving checkout store")
//        self.checkoutStore = checkoutStore
//    }
//
//    func didReceive(navigationHandler: PXPaymentProcessorNavigationHandler) {
//        print("Receiving navigation Handler")
//    }
//
//}
