//
//  CARTApp.swift
//  CART
//
//  Created by t&a on 2022/11/17.
//

import SwiftUI
import FirebaseCore
import FirebaseDatabase
import GoogleMobileAds
import GoogleSignIn



class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Firebase
        FirebaseApp.configure()
        //　Enable offline cache
        Database.database().isPersistenceEnabled = true
        // Google AdMob
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
    
    // Google SignIn
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct CARTApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            VStack(spacing:0){
                HeaderView()
                NavigationView{
                    // ログイン状態で初期ビューを分岐
                    if AuthManager.shared.auth.currentUser != nil {
                        MainTabViewView()
                    } else {
                        LoginAuthView()
                    }
                }.navigationViewStyle(.stack).accentColor(Color("SubColor")).preferredColorScheme(.light)
            }
        }
    }
}
