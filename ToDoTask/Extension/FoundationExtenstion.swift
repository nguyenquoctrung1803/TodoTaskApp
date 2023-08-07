//
//  FoundationExtenstion.swift
//  ToDoTask
//
//  Created by Trung Nguyễn Quốc on 05/08/2023.
//

import Foundation
import UIKit

extension Int{
    func appendZeros() -> String {
        if (self < 10) {
            return "0\(self)"
        } else {
            return "\(self)"
        }
    }
    
    func degreeToRadians() -> CGFloat {
       return  (CGFloat(self) * .pi) / 180
    }
}
