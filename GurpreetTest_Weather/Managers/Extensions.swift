//
//  Extensions.swift
//  GurpreetTest_Weather
//
//  Created by Gurpreet Singh on 06/09/20.
//  Copyright © 2020 Gurpreet Singh. All rights reserved.
//

import Foundation

extension Decodable {
    static func decode(_ responseData: Data) -> Self {
        do {
            let model = try JSONDecoder().decode(Self.self, from: responseData)
            return model
        }catch {
            print(error)
        }
        
        return Self.self as! Self
    }
}

extension String {
    func timestampToDate() -> Date {
        let value = (self as NSString).doubleValue / 1000
        return Date(timeIntervalSince1970: value)
    }
}

extension Date {
    func toTimeStamp() -> String {
        let timestamp13Digit = Int64(self.timeIntervalSince1970 * 1000)
        return "\(timestamp13Digit)"
    }
}
