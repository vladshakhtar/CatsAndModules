//
//  CatsListViewApp.swift
//  CatsListView
//
//  Created by Vladislav Stolyarov on 29.05.2023.
//

import SwiftUI
import FirebaseCore
import FirebaseCrashlytics


//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//
//
//        let userAgreementKey = "UserAgreement"
//        let userAgreement = UserDefaults.standard.bool(forKey: userAgreementKey)
//
//        if !userAgreement {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                UIApplication.shared.windows.first?.rootViewController?.presentAgreementAlert {
//                    Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
//
//                    UserDefaults.standard.set(true, forKey: userAgreementKey)
//                }
//            }
//        } else {
//            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
//        }
//
//        return true
//    }
//}

@main
struct CatsListViewApp: App {
  //  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            CatsListView()
                
        }
    }
    
}

//extension UIViewController {
//    func presentAgreementAlert(completion: @escaping () -> Void) {
//        let alert = UIAlertController(title: "Data Collection Agreement", message: "Do you agree to collect crash data?", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
//            completion()
//        }))
//        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
//
//        self.present(alert, animated: true, completion: nil)
//    }
//}



