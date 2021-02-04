//
//  SummaryViewModel.swift
//  PVTG
//
//  Created by Test Machine on 21/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

protocol LoadingPayNow: class {
    func reloaddata()
}

class SummaryViewModel: BaseVm {
    weak var delegate: LoadingCategory?

   
}
