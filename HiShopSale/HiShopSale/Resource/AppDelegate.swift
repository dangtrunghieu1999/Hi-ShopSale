//
//  AppDelegate.swift
//  HiShopSale
//
//  Created by Dang Trung Hieu on 5/12/21.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import NotificationBannerSwift
import SwiftyJSON

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = UIColor.primary
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        if UserManager.isLoggedIn() {
            if UserManager.code == "" {
                window?.rootViewController = UINavigationController(rootViewController: AddressViewController())
            } else {
                window?.rootViewController = UINavigationController(rootViewController: MenuViewController())
            }
        } else {
            window?.rootViewController = UINavigationController(rootViewController: SignInViewController())
        }
        
        configAPNs()
        observerOrderState()
        observerCommentState()
        
        return true
    }
    
    func configAPNs() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
            
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
                // Enable or disable features based on authorization.
            }
            center.delegate = self
        }
    }
    
    private func observerOrderState() {
        if (!UserManager.isLoggedIn()) {
            return
        }
        
        FirebaseDataBase.shared.observerOrderStatusChange(for: UserManager.userId ?? ""){ code, status  in
            let name = status.name ?? ""
                let notificationBannerQueue = NotificationBannerQueue()
                DispatchQueue.main.async {
                    let subtitle = name + " đơn hàng " + code
                    let banner = FloatingNotificationBanner(title: TextManager.hi_shop, subtitle: subtitle, style: .success)
                    self.showBanners(banner, in: notificationBannerQueue)
                    banner.onTap = {
                        guard let topVC = UIViewController.topViewController() as? BaseViewController else { return }
                        if topVC.isKind(of: ManagerOrderViewController.self) {
                            let curManagerOrder = topVC as! ManagerOrderViewController
                            curManagerOrder.requestAPIOrder()
                            return
                        }
                        
                        let vc = ManagerOrderViewController()
                        vc.requestAPIOrder()
                        vc.numberIndex = status.rawValue
                        topVC.navigationController?.pushViewController(vc, animated: true)
                    }
            }
        }
    }
    
    private func observerCommentState() {
        if (!UserManager.isLoggedIn()) {
            return
        }
        
        FirebaseDataBase.shared.observerCommentChange(for: UserManager.userId ?? "") { productId in
                let notificationBannerQueue = NotificationBannerQueue()
                DispatchQueue.main.async {
                    let subtitle = "Bạn có một bình luận mới"
                    let banner = FloatingNotificationBanner(title: TextManager.hi_shop, subtitle: subtitle, style: .success)
                    self.showBanners(banner, in: notificationBannerQueue)
                    banner.onTap = {
                        guard let topVC = UIViewController.topViewController() as? BaseViewController else { return }
                        if topVC.isKind(of: ProductDetailViewController.self) {
                            let curProductDetailVC = topVC as! ProductDetailViewController
                            let curProductId = curProductDetailVC.product.id ?? 0
                            if String(describing: curProductId) == productId {
                                curProductDetailVC.scrollCommentProduct()
                                return
                            }
                        }
                        
                        if topVC.isKind(of: ProductCommentViewController.self) {
                            let commentetailVC = topVC as! ProductCommentViewController
                            let curProductId = commentetailVC.comments.first?.productId ?? 0
                            commentetailVC.getCommentsAPI(productId: curProductId)
                            if String(describing: curProductId) == productId {
                                return
                            }
                        }
                        
                        let vc = ProductDetailViewController()
                        let product = Product()
                        product.id = Int(productId)
                        vc.configData(product)
                        vc.scrollCommentProduct()
                        topVC.navigationController?.pushViewController(vc, animated: true)
                    }
            }
        }
    }
    
    func showBanners(_ banner: FloatingNotificationBanner,
                     in notificationBannerQueue: NotificationBannerQueue) {
        banner.titleLabel?.textColor = UIColor.second
        banner.subtitleLabel?.textColor = UIColor.bodyText
        banner.show(bannerPosition: .top,
                    queue: notificationBannerQueue,
                    cornerRadius: 8,
                    shadowColor: UIColor(red: 0.431, green: 0.459, blue: 0.494, alpha: 1),
                    shadowBlurRadius: 16,
                    shadowEdgeInsets: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
    }
    
    func getFCMToken() {
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
            UserManager.saveFCMToken(token)
          }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        getFCMToken()
        guard let fcmToken = fcmToken else { return }
        print("Firebase registration token: \(fcmToken)")
        UserManager.saveFCMToken(fcmToken)
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("Received push notification: \(userInfo)")
        let aps = userInfo["aps"] as! [String: Any]
        print("\(aps)")
        
        var json: JSON
        let data = userInfo["data"]
        
        if let dataStr = data as? String {
            json = JSON(parseJSON: dataStr)
        } else {
            json = JSON(data!)
        }
        
        if application.applicationState == .inactive {
            let pushNotification = Notifications(json: json)
            NotificationManager.checkCanShowNotificationVC(pushNotification, userInfo: userInfo)
        }
    }

}
