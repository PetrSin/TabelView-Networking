//
//  AppDelegate.swift
//  TabelView+Networking
//
//  Created by petar on 26.09.2023.
//
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = CollectionViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        
        window?.backgroundColor = .white
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        
        return true
    }

}
