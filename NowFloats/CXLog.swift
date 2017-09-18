//
//  CXLog.swift
//  Lefoodie
//
//  Created by apple on 25/04/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import Foundation

public struct CXLog{
    
    
    public static func print(_ items: Any..., separator: String = " ", terminator: String = "\n", _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        #if DISABLE_LOG
           // let prefix = modePrefix(Date(), file: file, function: function, line: line)
            let stringItem = items.map {"\($0)"} .joined(separator: separator)
            Swift.print("\(stringItem)", terminator: terminator)
        #endif
    }
    
}
