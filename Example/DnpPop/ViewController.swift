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
    
    var direction = DnpPopDirection.up
    var topRightDirection = DnpPopDirection.down
    var timer: Timer? = nil
    
    let popTip = DnpPop()
    
    let /* Rival Sons's Tied Up */ lyrics = [
      "Go to the dark side full moon",
      "You shoot the apple off of my head",
      "'Cause your love, sweet love, is all that you put me through",
      "And honey without it you know I'd rather be dead",
      "I'm tied up",
      "I'm tangled up",
      "And I'm all wrapped up",
      "In you"
    ]
    
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
        popreset()
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 120))
        
        let frame = CGRect(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height - 34, width: 2, height: 2)
        popTip.entranceAnimation = .transition
        popTip.exitAnimation = .fadeOut
        popTip.arrowSize = CGSize()
        popTip.bubbleColor = UIColor(red: 0.97, green: 0.9, blue: 0.23, alpha: 1)
        popTip.cornerRadius = 5
        popTip.show(customView: containView, direction: .up, in: self.view, from: frame)
        
        return
        let main = UIStoryboard(name: "Main", bundle: nil)
        if let vc = main.instantiateViewController(withIdentifier: "PopController") as? PopController{
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func popreset() {
        popTip.arrowRadius = 0
        popTip.arrowOffset = 0
        popTip.bubbleOffset = 0
        popTip.arrowSize = CGSize(width: 8, height: 8)
        popTip.padding = 0//6
        popTip.offset = 2
        popTip.arrowRadius = 0
    }

    @IBAction func action(_ sender: UIButton) {
        guard let button = ButtonType(rawValue: sender.tag) else { return }
        timer?.invalidate()
        popreset()
        
        switch button {
        case .topLeft:
            
            //popTip.arrowOffset = -36
            //popTip.bubbleOffset =  -36
            popTip.bubbleColor = UIColor(red: 0.81, green: 0.04, blue: 0.14, alpha: 1)
            popTip.show(text: "Animated popover, great for subtle UI tips and onboarding", direction: .down, maxWidth: 200, in: view, from: sender.frame)
        case .topRight:
            popTip.bubbleColor = UIColor(red: 0.97, green: 0.9, blue: 0.23, alpha: 1)
            if topRightDirection == .left {
              topRightDirection = .down
            } else {
              topRightDirection = .left
            }
            popTip.show(text: "I have a offset to move the bubble down or left side.", direction: topRightDirection, maxWidth: 150, in: view, from: sender.frame)
            
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
            popTip.show(customView: cornerView, direction: .up, in: self.view, from: sender.frame)
        
        case .center:
            popTip.arrowRadius = 2
            popTip.bubbleColor = UIColor(red: 0.31, green: 0.57, blue: 0.87, alpha: 1)
            popTip.show(text: "Animated popover, great for subtle UI tips and onboarding", direction: direction, maxWidth: 200, in: view, from: sender.frame)
            direction = direction.cycleDirection()
            if #available(iOS 10.0, *) {
                timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (_) in
                    self.popTip.update(text: self.lyrics.sample())
                }
            }
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


extension DnpPopDirection{
    func cycleDirection() -> DnpPopDirection {
      switch self {
      case .up:
        return .right
      case .right:
        return .down
      case .down:
        return .left
      case .left:
        return .up
      case .none:
        return .none
      }
    }
}
extension Array {
  func sample() -> Element {
    let index = Int(arc4random_uniform(UInt32(count)))
    return self[index]
  }
}
