//
//  YSTabBarController.swift
//
//
//  Created by Youssef Eid on 09/06/1440 AH.
//  Copyright © 1440 Youssef Eid. All rights reserved.
//

import UIKit

@IBDesignable
class YSTabBarController: UITabBarController {
    
    @IBInspectable var btnBackgroundColor: UIColor = .black
    @IBInspectable var btnTintColor: UIColor = .white
    @IBInspectable var btnBorderColor: UIColor = .white
    @IBInspectable var btnBorderWidth: CGFloat = 1.0
    // if you change the value to two it add popup in the last item and the before last
    @IBInspectable var popCountTabBar = 1
    
    fileprivate let kOrderTabBar = "OrderTabBar"
    fileprivate var controllers: [UIViewController] = []
    fileprivate var isPopOpen:Bool = false
    fileprivate var stackViewButtons = UIStackView()
    fileprivate var currentViewIndex = -1
    fileprivate var screenHeight = UIScreen.main.bounds.height
    fileprivate var screenWidth  = UIScreen.main.bounds.width
    fileprivate var isUseStoryboard = true
    fileprivate var marginBottom:CGFloat = 60.0
    fileprivate var marginLeft:CGFloat = 0
    fileprivate var marginTop:CGFloat = 0
    fileprivate let btnWidthAndHeight:CGFloat = 35.0
    fileprivate var tabBarBackgroundImage = [UIImageView]()
    fileprivate var fixMargin:CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stackViewButtons.axis = .vertical
        self.stackViewButtons.spacing = 2.0
        self.stackViewButtons.distribution = .fillEqually
        self.tabBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.device()
        self.setup()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.finsih()
        self.screenWidth = size.width
        self.screenHeight = size.height
        self.device()
        for v in self.tabBarBackgroundImage {
            v.frame = CGRect(origin: CGPoint(x: self.marginLeft, y: self.marginTop),
                             size: v.frame.size)
        }
    }
    
    fileprivate func isLanlandscape() -> Bool {
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            return true
        case .landscapeRight:
            return true
        case .unknown:
            return UIApplication.shared.statusBarOrientation.isLandscape
        default:
            return false
        }
    }
    
    fileprivate func setup() {
        if let vc = self.viewControllers {
            var tag = 1
            vc.forEach {
                $0.tabBarItem.tag = tag
                tag += 1
            }
        }
        if let order = UserDefaults.standard.object(forKey: self.kOrderTabBar) as? [Int] {
            var orderVC = [UIViewController]()
            if var lc = self.viewControllers {
                for v in lc {
                    let tag = v.tabBarItem.tag
                    order.forEach { (orderId) in
                        if tag == orderId {
                            orderVC.append(v)
                            lc.removeAll(where: {$0 == v})
                        }
                    }
                }
                self.controllers = lc
                lc.removeAll()
                self.setViewControllers(orderVC, animated: false)
            }
        } else {
            if let lc = self.viewControllers {
                if lc.count > 4 {
                    for (index, elemnet) in lc.enumerated() {
                        if index > 4 {
                            self.controllers.append(elemnet)
                        }
                    }
                    for _ in self.controllers {
                        self.viewControllers!.removeLast()
                    }
                }
            }
        }
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        for (index, tbar) in self.tabBar.subviews.enumerated().reversed() {
            if index >= (self.tabBar.subviews.count - self.popCountTabBar) {
                self.addLongPressGestureRecognizer(v: tbar)
            }
        }
    }
    
    @objc fileprivate func longPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            guard let position = sender.view?.frame else { return }
            self.stackViewButtons.backgroundColor = .clear
            self.clearAllObjectInStackView()
            sender.view!.superview!.superview!.insertSubview(self.stackViewButtons, at: 1)
            self.createButtons()
            let height = self.btnWidthAndHeight * CGFloat(self.controllers.count)
            let posX = ((position.size.width + position.origin.x) / position.size.width)
            self.currentViewIndex = Int(posX)
            let x = (position.size.width * CGFloat(posX)) - (position.size.width / 2)
            self.device()
            self.stackViewButtons.frame = CGRect(x: CGFloat(x) - self.fixMargin,
                                                 y: self.screenHeight + height + self.fixMargin,
                                                 width: 35.0,
                                                 height: height)
            UIView.animate(withDuration: 0.5) {
                self.stackViewButtons.frame = CGRect(x: CGFloat(x) - self.fixMargin,
                                                     y: self.screenHeight - (height + self.marginBottom) ,
                                                     width: 35.0,
                                                     height: height)

                self.stackViewButtons.subviews.forEach {
                    $0.isHidden = false
                }
                self.isPopOpen = true
            }
        }
    }
    
    //
    fileprivate func device() {
        switch isLanlandscape() ? self.screenWidth : self.screenHeight {
        case 568:
            self.marginBottom = (isLanlandscape() == true) ? 35 : 55
            self.marginLeft = -8
            self.marginTop = (isLanlandscape() == true) ? -8 : 0
        case 667:
            self.marginBottom = (isLanlandscape() == true) ? 35 : 55
            self.marginTop = (isLanlandscape() == true) ? -8 : 0
        case 736:
            self.marginBottom = 55
        case 896:
            self.marginBottom = (isLanlandscape() == true) ? 75 : 90
            self.marginLeft = (isLanlandscape() == true) ?  10 : 0
        default:
            self.marginTop = (isLanlandscape() == true) ? -8 : 0
            self.marginBottom = (isLanlandscape() == true) ? 60 : 90
        }
    }
    
    fileprivate func createButtons() {
        for (index, v) in self.controllers.enumerated() {
            let btn = UIButton(type: UIButton.ButtonType.roundedRect)
            btn.setImage(v.tabBarItem.image, for: UIControl.State.normal)
            btn.backgroundColor = self.btnBackgroundColor
            btn.frame.size = CGSize(width: self.btnWidthAndHeight,
                                    height: self.btnWidthAndHeight)
            btn.layer.cornerRadius = self.btnWidthAndHeight / 2
            btn.layer.borderColor = self.btnBorderColor.cgColor
            btn.layer.borderWidth = self.btnBorderWidth
            btn.tintColor = self.btnTintColor
            btn.isHidden = true
            btn.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            btn.tag = index
            btn.addTarget(self, action: #selector(self.relpaceTabBar),
                          for: UIControl.Event.touchUpInside)
            self.stackViewButtons.addArrangedSubview(btn)
        }
    }
    
    fileprivate func addLongPressGestureRecognizer(v: UIView) {
        let longPress = UILongPressGestureRecognizer(target: self,
                                                     action: #selector(longPressed))
        longPress.minimumPressDuration = 0.5
        longPress.numberOfTouchesRequired = 1
        longPress.delaysTouchesBegan = true
        v.addGestureRecognizer(longPress)
        for img in v.subviews {
            if img is UIImageView {
                if img.tag == 1 {
                    img.removeFromSuperview()
                }
            }
        }
        let pointerImageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "tabBarBackgound"))
        pointerImageView.tag = 1
        v.insertSubview(pointerImageView, at: 0)
        self.tabBarBackgroundImage.append(pointerImageView)
        pointerImageView.frame = CGRect(origin: CGPoint(x: self.marginLeft, y: self.marginTop),
                                        size: pointerImageView.frame.size)
    }
    
    @objc fileprivate func relpaceTabBar(sender: UIButton) {
        
        guard var vc = self.viewControllers else {
            self.finsih()
            return
        }
        
        let replaceTopBar = self.controllers[sender.tag]
        let currentTopBar = self.viewControllers![self.currentViewIndex - 1]
        
        vc.remove(at: self.currentViewIndex - 1)
        vc.insert(replaceTopBar, at: self.currentViewIndex - 1)
        
        self.controllers.remove(at: sender.tag)
        self.controllers.insert(currentTopBar, at: sender.tag)
        
        self.tabBarBackgroundImage.removeAll()
        
        self.setViewControllers(vc, animated: false)
        self.selectedViewController = replaceTopBar
        
        self.saveOrderTabBar()
        self.finsih()
    }
    
    fileprivate func saveOrderTabBar() {
        var tagNumber = [Int]()
        self.viewControllers?.forEach {
            tagNumber.append($0.tabBarItem.tag)
        }
        let userDefulats = UserDefaults.standard
        userDefulats.set(tagNumber, forKey: self.kOrderTabBar)
        userDefulats.synchronize()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.finsih()
    }
    
    fileprivate func finsih() {
        if self.isPopOpen == true {
            
            UIView.animate(withDuration: 0.5, animations: {
                self.isPopOpen = false
                let frame = self.stackViewButtons.frame
                self.stackViewButtons.frame = CGRect(x: frame.origin.x,
                                                     y: frame.origin.y + frame.size.height + self.fixMargin,
                                                     width: 35.0,
                                                     height: frame.size.height)
                self.stackViewButtons.subviews.forEach {
                    $0.isHidden = true
                }
            }) { (finsih) in
                self.clearAllObjectInStackView()
                self.stackViewButtons.removeFromSuperview()
            }
        }
    }
    
    fileprivate func clearAllObjectInStackView() {
        for views in self.stackViewButtons.arrangedSubviews {
            self.stackViewButtons.removeArrangedSubview(views)
            for v in self.stackViewButtons.subviews {
                v.removeFromSuperview()
            }
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.finsih()
    }
    
    
}


