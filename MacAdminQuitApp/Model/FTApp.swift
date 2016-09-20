//
//  FTApp.swift
//  MacAdminQuitApp
//
//  Created by François Levaux on 20.09.16.
//  Copyright © 2016 François Levaux. All rights reserved.
//

import Cocoa

class FTApp: FTApplicationProtocol {

    let path: String
    let bundle: Bundle
    
    enum error: Error {
        case CannotGetBundle
    }
    
    init(path: String) throws {
        self.path = path
        
        guard let bundle = Bundle.init(path: path) else {
            throw(error.CannotGetBundle)
        }
        
        self.bundle = bundle
    }
    
    
    
    // ----------------------------------------------------------------------------------------
    // icon -> NSImage
    // ----------------------------------------------------------------------------------------
    
    lazy var icon: NSImage = {
        if var iconFilename = self.bundle.infoDictionary?["CFBundleIconFile"] as? String {
            if iconFilename.hasSuffix(".icns") {
                iconFilename = (iconFilename as NSString).deletingPathExtension
            }
            if let iconFile = self.bundle.path(forResource: iconFilename, ofType: "icns") {
                if let icon = NSImage(byReferencingFile: iconFile) {
                    return icon
                }
            }
        }
        return NSImage(imageLiteralResourceName: "NSApplicationIcon")
    }()
    
    
    
    
    // ----------------------------------------------------------------------------------------
    // name -> String
    // ----------------------------------------------------------------------------------------
    
    lazy var name: String = {
            if let appName = self.bundle.localizedInfoDictionary?["CFBundleExecutable"] as? String {
                return appName
            }
            if let appName = self.bundle.infoDictionary?["CFBundleExecutable"] as? String {
                return appName
            }
        
        return "Error"
    }()

    
    
    // ----------------------------------------------------------------------------------------
    // isRunning -> Bool
    // ----------------------------------------------------------------------------------------
    
    func isRunning() -> Bool {
        for runningApplication in NSWorkspace.shared().runningApplications {
            if runningApplication.localizedName == self.name {
                return true
            }
        }
        
        return false
    }
    
    
    
    // ----------------------------------------------------------------------------------------
    // terminate(force: Bool)
    // ----------------------------------------------------------------------------------------
    
    func terminate(force forceQuit: Bool = false) {
        for runningApplication in NSWorkspace.shared().runningApplications {
            if let runningApplicationLocalizedName = runningApplication.localizedName {
                if runningApplicationLocalizedName == self.name {
                    
                    if forceQuit {
                        print("Terminating \(runningApplicationLocalizedName)")
                        runningApplication.forceTerminate()
                    } else {
                        print("Quitting \(runningApplicationLocalizedName)")
                        runningApplication.terminate()
                    }
                }
            }
            
        }
    }
}
