//
//  Constants.swift
//  ToDoTask
//
//  Created by Trung Nguyễn Quốc on 05/08/2023.
//

import Foundation
import UIKit

struct Constants {
    static var hasTopNotch: Bool {
        guard #available(iOS 15.0,  *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        
        return window.safeAreaInsets.top >= 44
    }
}
