//
//  FTBundle.swift
//  MacAdminQuitApp
//
//  Created by François Levaux on 20.09.16.
//  Copyright © 2016 François Levaux. All rights reserved.
//

import Cocoa

class FTBundle: FTApplicationProtocol {

    let bundleID: String
    
    
    init(bundleID: String) {
        self.bundleID = bundleID
    }
    
    func isRunning() -> Bool {
        for runningApplication in NSWorkspace.shared().runningApplications {
            if let runningApplicationBundleID = runningApplication.bundleIdentifier {
                if runningApplicationBundleID.contains(self.bundleID) {
                    return true
                }
            }
        }
        
        return false
    }
    
    func terminate(force forceQuit: Bool = false) {
        for runningApplication in NSWorkspace.shared().runningApplications {
            if let runningApplicationBundleID = runningApplication.bundleIdentifier {
                if runningApplicationBundleID.contains(self.bundleID) {
                    
                    if forceQuit {
                        print("Terminating \(runningApplicationBundleID)")
                        runningApplication.forceTerminate()
                    } else {
                        print("Quitting \(runningApplicationBundleID)")
                        runningApplication.terminate()
                    }
                }
            }
        }
    }

}
