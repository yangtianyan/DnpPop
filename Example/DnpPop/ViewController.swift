//
//  ViewController.swift
//  DnpPop
//
//  Created by zomfice@gmail.com on 09/30/2019.
//  Copyright (c) 2019 zomfice@gmail.com. All rights reserved.
//

import UIKit
import DnpPop

class ViewController: UIViewController {

    enum ButtonType: Int {
      case center, topLeft, topRight, bottomLeft, bottomRight,bottomCenter,bottomSmall
    }
    
    let popTip = DnpPop()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.black
        
        popTip.font = UIFont(name: "Avenir-Medium", size: 12)!
        popTip.shouldDismissOnTap = true
        popTip.shouldDismissOnTapOutside = true
        popTip.shouldDismissOnSwipeOutside = true
        //popTip.edgeMargin = 5
        popTip.offset = 10
        popTip.bubbleOffset = 0
        //popTip.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        popTip.padding = 0
        //popTip.entranceAnimation = .none
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        return
        let main = UIStoryboard(name: "Main", bundle: nil)
        if let vc = main.instantiateViewController(withIdentifier: "PopController") as? PopController{
            self.present(vc, animated: true, completion: nil)
        }
    }

    @IBAction func action(_ sender: UIButton) {
        guard let button = ButtonType(rawValue: sender.tag) else { return }
        popTip.arrowRadius = 0
        popTip.arrowOffset = 0
        popTip.bubbleOffset = 0
        popTip.arrowSize = CGSize(width: 8, height: 8)
        popTip.padding = 0//6
        popTip.offset = 2
        popTip.arrowRadius = 0
        
        switch button {
        case .topLeft:
            popTip.arrowOffset = -36
            popTip.bubbleOffset =  -36
            popTip.bubbleColor = UIColor(red: 0.81, green: 0.04, blue: 0.14, alpha: 1)
            popTip.show(text: "Animated popover, great for subtle UI tips and onboarding", direction: .up, maxWidth: 200, in: view, from: sender.frame)
        case .topRight:
            fatalError()
        case .bottomLeft:
            popTip.arrowOffset = 20//15
            popTip.bubbleOffset =  20
            let containView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 250))
            popTip.arrowRadius = 2
            popTip.bubbleColor = UIColor(red: 0.97, green: 0.9, blue: 0.23, alpha: 1)
            popTip.cornerRadius = 5
            popTip.show(customView: containView, direction: .up, in: self.view, from: sender.frame)
            print(popTip.frame)
            print(popTip.arrowPosition)
            
        case .bottomSmall:
            popTip.arrowOffset = 20
            popTip.bubbleOffset =  20
            let containView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 250))
            popTip.arrowRadius = 2
            popTip.bubbleColor = UIColor(red: 0.97, green: 0.9, blue: 0.23, alpha: 1)
            popTip.cornerRadius = 5
            popTip.show(customView: containView, direction: .up, in: self.view, from: sender.frame)
            print(popTip.frame)
            print(popTip.arrowPosition)
            
        case .bottomRight:
            popTip.bubbleOffset =  -20
            popTip.arrowRadius = 2
            popTip.bubbleColor = UIColor.clear
            let cornerView = UIImageView(frame: CGRect(x: 0, y: 0, width: 282, height: 64))
            cornerView.image = UIImage(named: "pop")
            //cornerView.backgroundColor = UIColor(red: 0.97, green: 0.9, blue: 0.23, alpha: 1)
            //cornerView.layer.cornerRadius = 32
            //popTip.cornerRadius = 32
            popTip.show(customView: cornerView, direction: .up, in: self.view, from: sender.frame)
        
        case .center:
            fatalError()
        case .bottomCenter:
            let containView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 100, height: 80))
            let label = UILabel(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.size.width - 120, height: 60))
            label.text = "Helloe lajlfjalfjadljfa fdjalfjdalfj a"
            containView.addSubview(label)
            popTip.arrowRadius = 2
            popTip.bubbleColor = UIColor(red: 0.97, green: 0.9, blue: 0.23, alpha: 1)
            popTip.cornerRadius = 5
            popTip.show(customView: containView, direction: .up, in: self.view, from: sender.frame)
        }
        
    }

}

