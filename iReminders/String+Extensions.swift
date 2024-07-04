//
//  String+Extensions.swift
//  iReminders
//
//  Created by Yery Castro on 7/6/24.
//

import Foundation

extension String {
    
    var isEmptyOrWhitespace: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
