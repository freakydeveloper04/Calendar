//
//  CalendarViewController.swift
//  Calendar
//
//  Created by Vaibhav Mehta on 20/08/19.
//  Copyright © 2019 Vaibhav Mehta. All rights reserved.
//

import UIKit
import EventKit

enum MyTheme {
    case light
    case dark
}

class CalendarViewController: UIViewController {
    
    var theme = MyTheme.dark
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.title = "My Calender"
        //self.navigationController?.navigationBar.isTranslucent=false
        self.view.backgroundColor=Style.bgColor
        
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive=true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive=true
        calenderView.heightAnchor.constraint(equalToConstant: 365).isActive=true
        
        let rightBarBtn = UIBarButtonItem(title: "Light", style: .plain, target: self, action: #selector(rightBarBtnAction))
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func rightBarBtnAction(sender: UIBarButtonItem) {
        if theme == .dark {
            sender.title = "Dark"
            theme = .light
            Style.themeLight()
        } else {
            sender.title = "Light"
            theme = .dark
            Style.themeDark()
        }
        self.view.backgroundColor=Style.bgColor
        calenderView.changeTheme()
    }
    
    let calenderView: CalenderView = {
        let v=CalenderView(theme: MyTheme.dark)
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    
    
    @IBAction func addEventBtn(_ sender: UIButton) {
        
        let eventStore: EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if(granted) && (error == nil)
            {
                
                print("Granted: \(granted)")
                
                print("Error: \(String(describing: error))")
                
                let event: EKEvent = EKEvent(eventStore: eventStore)
                event.title = "New Event"
                event.startDate = Date()
                event.endDate = Date()
                event.notes = "mEinstein created Event"
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                do{
                    
                    try eventStore.save(event, span: .thisEvent)
                }
                catch let error as NSError{
                    
                    print("error\(error)")
                }
                print("Event Saved")
                
                
                
            }
                
            else {
                
                print("error\(error)")
            }
        }
        
        createAlert(title: "Event created!", message: "Command bot for creating changes.")
    }
    
    func createAlert (title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ (action) in alert.dismiss(animated: true, completion: nil)
            print("Ok")
            
        }))
    }
    
}
