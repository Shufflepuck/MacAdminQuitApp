//
//  AppDelegate.swift
//  MacAdminQuitApp
//
//  Created by François Levaux on 19.09.16.
//  Copyright © 2016 François Levaux. All rights reserved.
//

import Cocoa
import FTApp

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var forceQuitButton: NSButton!
    @IBOutlet weak var quitButton: NSButton!
    @IBOutlet weak var appLabel: NSTextField!
    @IBOutlet weak var msgLabel: NSTextField!
    @IBOutlet weak var appIcon: NSImageView!
    
    
    var app: FTApp!
    var additionalBundleID: FTAppBundle?
    
    var timerToForceQuit: Timer?
    var exitSuccessful: Bool = false
    
    
    func timerRun() {
        if !self.app.isRunning() && !(self.additionalBundleID?.isRunning() ?? false) {
            self.applicationIsNotRunning(appName: self.app.name)
        } else {
            self.applicationIsRunning(appName: self.app.name)
        }
    }


    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        guard let appPath = UserDefaults.standard.value(forKey: "appPath") as? String else {
            NSLog("ERROR: Cannot read appPath from user defaults. Make sure you specify the path of the app by using -appPath [application] (see README). Exiting.")
            NSApp.terminate(self)
            return
        }

        do {
            app = try FTApp(path: appPath)
        } catch FTApp.error.CannotGetBundle {
            NSLog("Cannot get application bundle. Make sure you specified an existing application with -appPath (see README). Exiting.")
            NSApp.terminate(self)
        } catch {
            debugPrint("Unhandled catch")
        }

        if let appBundleID = UserDefaults.standard.value(forKey: "appBundleID") as? String {
            additionalBundleID = FTAppBundle(bundleID: appBundleID)
        }

        // If application is not running, exit early
        timerRun()
        
        let timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerRun), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
        
        
        // Window should be above everything else
        window.level = Int(CGWindowLevelForKey(.floatingWindow))
        
        // Setup Window
        appIcon.image = self.app.icon
        appLabel.stringValue =  self.app.name + " needs to be updated"
        
        forceQuitButton.isEnabled = false
        
        quitButton.title = "Quit \(self.app.name)"
        quitButton.sizeToFit()
        quitButton.isEnabled = true
        
        
        
    }
    
    func applicationIsRunning(appName: String?) {
        msgLabel.stringValue = "Please save your documents and Quit \(self.app.name)"
    }
    
    func applicationIsNotRunning(appName: String?) {
        continueAction()
    }
    
    func enableForceQuitButton() {
        self.forceQuitButton.isEnabled = true
    }
    
    
    @IBAction func quitApplication(_ sender: AnyObject) {
        self.app.terminate()
        self.additionalBundleID?.terminate()
        
        timerToForceQuit = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(enableForceQuitButton), userInfo: nil, repeats: false)
        
        RunLoop.main.add(timerToForceQuit!, forMode: .defaultRunLoopMode)
        
        
    }
    
    @IBAction func forceQuitApplication(_ sender: AnyObject) {
        self.app.terminate(force: true)
        self.additionalBundleID?.terminate(force: true)
    }
    
    func continueAction() {
        exitSuccessful = true
        NSApp.terminate(self)
    }
    

    func applicationWillTerminate(_ aNotification: Notification) {
        
        if exitSuccessful {
            print("successful")
        } else {
            print("not successful")
            exit(1)
        }
        
    }


}

