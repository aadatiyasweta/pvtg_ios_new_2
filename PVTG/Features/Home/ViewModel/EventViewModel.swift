//
//  EventViewModel.swift
//  PVTG
//
//  Created by Test Machine on 15/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

protocol LoadingEvents: AnyObject {
    func colecnreloaddata()
}

class EventViewModel: BaseVm {
    var model: EventsBase?
    weak var delegate: LoadingEvents?

    private(set) var history: [EventsResult] = []
    private(set) var isLoading = false
    private(set) var hasMoreHistory = true
    private(set) var nextHistoryOffset = 0
    private let historyPageSize = 10

    //MARK: - GET ACTIVE EVENT API
    func getActiveEventApi(user_id: String, latitude: String, longitude: String, offset: String) {
        guard !isLoading else { return }
        let isFirstPage = (offset == "0")
        if !isFirstPage && !hasMoreHistory { return }
        isLoading = true
        let prams : [String : Any] = ["user_id": user_id, "latitude": latitude, "longitude": longitude, "offset": offset,"language" : SaveToDefaults().getAppLang() ?? "en","timezone" : TimeZone.current.identifier]
          self.show()
          api_manager.GETApi(activeEventApi(), param: prams, header: header()) { (response, err, code) in
              self.dismiss()
              self.isLoading = false
              if let json = response{
                  debugPrint(json)
                  if json["statusCode"] == 200 {
                    let data = try? response?.rawData()
                      let jsonDecoder = JSONDecoder()
                      let model = try? jsonDecoder.decode(EventsBase.self, from: data ?? Data())
                      let page = model?.history ?? []
                      if isFirstPage {
                          self.model = model
                          self.history = page
                          self.nextHistoryOffset = self.historyPageSize
                          self.hasMoreHistory = page.count >= self.historyPageSize
                      } else {
                          let known = Set(self.history.compactMap { $0.booking_id })
                          let newItems = page.filter { !known.contains($0.booking_id ?? "") }
                          self.history.append(contentsOf: newItems)
                          self.nextHistoryOffset += self.historyPageSize
                          self.hasMoreHistory = page.count >= self.historyPageSize && !newItems.isEmpty
                      }
                    self.delegate?.colecnreloaddata()
                      
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
