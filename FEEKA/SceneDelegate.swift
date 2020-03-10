//
//  SceneDelegate.swift
//  FEEKA
//
//  Created by Apple Guru on 11/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private(set) static var shared: SceneDelegate?
        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
          
            print("worked")
           if let userActivity = connectionOptions.userActivities.first {
                  self.scene(scene, continue: userActivity)
             self.scene(scene, openURLContexts: connectionOptions.urlContexts)
                } else {
                  self.scene(scene, openURLContexts: connectionOptions.urlContexts)
                }
             self.scene(scene, openURLContexts: connectionOptions.urlContexts)
            guard let _ = (scene as? UIWindowScene) else { return }
            Self.shared = self
        }
    
    

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
    var id = ""
    var categorie = ""
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print(URLContexts)
        for context in URLContexts {
          print("url: \(context.url.absoluteURL)")
           let param = getQueryStringParameter(url: "\(context.url.absoluteURL)", param: "product_id")
            let category_id = getQueryStringParameter(url: "\(context.url.absoluteURL)", param: "category_id")
            if param != nil {
            id = "\(param!)"
            }
            if category_id != nil {
                categorie = "\(category_id!)"
            }
           // print(param!)
          print("scheme: \(context.url.scheme!)")
          print("host: \(context.url.host!)")
          print("path: \(context.url.path)")
          print("components: \(context.url.pathComponents)")
            switch context.url.host! {
            case "deeplink":
                productDetails()
            case "brands":
                brand()
            case "deeplinkcat":
                if categorie == "125" {
                makeUp()
                } else if categorie == "329" {
                    skinCare()
                }else if categorie == "337" {
                    hairCare()
                }
                
            case "chocsqueeze":
                home()
                
                
            default:
                break
            }
            
        }
        
       
          
        
        
        
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
      guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
        let urlToOpen = userActivity.webpageURL else {
            
          return
      }
        handleURL(urlToOpen)
print("jsdjksjfkdsj\(urlToOpen)")
      
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
      guard let url = URLComponents(string: url) else { return nil }
      return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    func productDetails() {
           guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar") as? TabViewController else {
               return
           }
           let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.isHidden = true
           UIApplication.shared.windows.first?.rootViewController = navigationController
        let vc = rootVC.storyboard?.instantiateViewController(withIdentifier: "DiscoverDetailsViewController") as? DiscoverDetailsViewController
        vc?.productId = id
        rootVC.navigationController?.pushViewController(vc!, animated: true)
           UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func home() {
           guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar") as? TabViewController else {
               return
           }
           let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.isHidden = true
           UIApplication.shared.windows.first?.rootViewController = navigationController
           UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func brand() {
           guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar") as? TabViewController else {
               return
           }
           let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.isHidden = true
           UIApplication.shared.windows.first?.rootViewController = navigationController
        let vc = rootVC.storyboard?.instantiateViewController(withIdentifier: "BrandDetailsController") as? BrandDetailsController
        //vc?.productId = id
        rootVC.navigationController?.pushViewController(vc!, animated: true)
           UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func makeUp() {
           guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar") as? TabViewController else {
               return
           }
           let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.isHidden = true
           UIApplication.shared.windows.first?.rootViewController = navigationController
        let vc = rootVC.storyboard?.instantiateViewController(withIdentifier: "HomeProductDetailsViewController") as? HomeProductDetailsViewController
        vc!.categorie = "125"
        vc!.productNam = "MAKEUP"
        //vc?.productId = id
        rootVC.navigationController?.pushViewController(vc!, animated: true)
           UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    func skinCare() {
           guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar") as? TabViewController else {
               return
           }
           let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.isHidden = true
           UIApplication.shared.windows.first?.rootViewController = navigationController
        let vc = rootVC.storyboard?.instantiateViewController(withIdentifier: "HomeProductDetailsViewController") as? HomeProductDetailsViewController
        vc!.categorie = "329"
        vc!.productNam = "SKIN CARE"
        //vc?.productId = id
        rootVC.navigationController?.pushViewController(vc!, animated: true)
           UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func hairCare() {
           guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar") as? TabViewController else {
               return
           }
           let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.isHidden = true
           UIApplication.shared.windows.first?.rootViewController = navigationController
        let vc = rootVC.storyboard?.instantiateViewController(withIdentifier: "HomeProductDetailsViewController") as? HomeProductDetailsViewController
        vc!.categorie = "337"
        vc!.productNam = "HAIR CARE"
        //vc?.productId = id
        rootVC.navigationController?.pushViewController(vc!, animated: true)
           UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func handleURL(_ url: URL) {
    guard url.pathComponents.count >= 3 else { return }

    let section = url.pathComponents[1]
    let detail = url.pathComponents[2]
   
    }

}

