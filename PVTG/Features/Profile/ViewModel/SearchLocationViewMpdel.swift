//
//  SearchLocationViewMpdel.swift
//  PVTG
//
//  Created by Test Machine on 28/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

struct LocationList {
    var formattedAddress = ""
    var lat = 0.0
    var long = 0.0
    init(formattedAddress: String, lat: Double, long: Double) {
        self.formattedAddress = formattedAddress
        self.lat = lat
        self.long = long
    }
}

protocol CallBackForLocationList {
    func loadLoactionList()
}

class SearchLocationViewMpdel: BaseVm {
    var locationMode = [LocationList]()
    var model: LocationBase?
    var delegate: CallBackForLocationList?
    func locationApi(query: String) {
          self.show()
        api_manager.GETApi(searchPlacesApi(text: query), param: nil, header: nil) { (response, err, code) in
              self.dismiss()
              if let json = response{
                  debugPrint(json)
                  if json["status"] == "OK" {
                    self.locationMode.removeAll()
                    for i in 0..<json["results"].count {
                        let obj = json["results"][i]
                        self.locationMode.append(LocationList(formattedAddress: obj["formatted_address"].string ?? "", lat: obj["geometry"]["location"]["lat"].double ?? 0.0, long: obj["geometry"]["location"]["lng"].double ?? 0.0))
                    }
                    debugPrint(self.locationMode)
                    self.delegate?.loadLoactionList()
                  } else if json["status"] == "INVALID_REQUEST" {
                    self.delegate?.loadLoactionList()
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
