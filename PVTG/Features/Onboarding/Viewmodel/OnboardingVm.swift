//
//  OnboardingVm.swift
//  PVTG
//
//  Created by Techugo on 01/09/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//
protocol getOnboardingResponse : class {
    func getOnboardingData()
}
import Foundation
class OnboardingVm : BaseVm {
    var model : OnboardingModel?
    weak var delegate : getOnboardingResponse?
    func hitOnboaridngApi() {
        self.show()
        
        api_manager.GETApi(getSplashPointsUrl(), param: nil, header: nil) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    let jsonDecoder = JSONDecoder()
                    let data = try? json["result"].rawData()
                    self.model = try? jsonDecoder.decode(OnboardingModel.self, from: data!)
                    print(self.model?.rewards?.count)
                    self.delegate?.getOnboardingData()
                }
                else {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
}
