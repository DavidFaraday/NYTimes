//
//  Extensions.swift
//  NY Times
//
//  Created by David Kababyan on 04/09/2020.
//  Copyright © 2020 David Kababyan. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    
    func dateMonthYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        return dateFormatter.string(from: self)
    }
    
    func dateMonthYearTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy HH:mm"
        return dateFormatter.string(from: self)
    }

    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Float {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0}
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0}

        return Float(end - start)
    }

}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

