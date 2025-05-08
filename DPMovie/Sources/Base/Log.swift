//
//  Log.swift
//  DPMovie
//
//  Created by Peter Zhang on 2025/3/26.
//

import Foundation
import os.log

let Log = Logger(subsystem: "com.swee.DPMovie", category: "MainApp")

extension OSLogMessage {
    
    init(error: Error) {
        self.init(stringLiteral: error.localizedDescription)
    }
}
