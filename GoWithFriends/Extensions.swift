//
//  Extensions.swift
//  GoWithFriends
//
//  Created by stephan rollins on 8/8/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import Foundation

extension String {
  var isBlank: Bool {
    return allSatisfy({ $0.isWhitespace })
  }
}
