//
//  MailboxViewController.swift
//  codepath-week-03-mailbox
//
//  Created by mmuno on 10/5/15.
//  Copyright © 2015 mamuso. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var rowView: UIView!
    @IBOutlet weak var leftIconRowView: UIView!
    @IBOutlet weak var rightIconRowView: UIView!
    @IBOutlet weak var rowMessageImageView: UIImageView!
    @IBOutlet weak var leftIconImageView: UIImageView!
    @IBOutlet weak var rightIconImageView: UIImageView!
    @IBOutlet weak var rescheduleView: UIImageView!
    @IBOutlet weak var listView: UIImageView!
    
    var rowViewMessageOriginalCenter: CGPoint!
    var feedViewOriginalCenter: CGPoint!
    var translateRowIconsX: CGFloat!
    
    // Colors
    var colorGrey = UIColor.init(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
    var colorYellow = UIColor.init(red: 251/255, green: 212/255, blue: 13/255, alpha: 1.0)
    var colorGreen = UIColor.init(red: 108/255, green: 219/255, blue: 91/255, alpha: 1.0)
    var colorRed = UIColor.init(red: 237/255, green: 83/255, blue: 41/255, alpha: 1.0)
    var colorBrown = UIColor.init(red: 217/255, green: 116/255, blue: 113/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setScrollContent()
        
        // Setting the original feed center, message center and the icons translation
        feedViewOriginalCenter = feedImageView.center
        rowViewMessageOriginalCenter = rowMessageImageView.center
        translateRowIconsX = rowMessageImageView.frame.width/2 + leftIconRowView.frame.width/2
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setScrollContent() {
        // Setting up the scroll content - Adding row and feed heights
        scrollView.contentSize = CGSize(width: 320, height: rowView.frame.height + feedImageView.image!.size.height)
    }
    
    @IBAction func onRowPanGesture(sender: UIPanGestureRecognizer) {
        
        let point = sender.locationInView(view)
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
        } else if sender.state == UIGestureRecognizerState.Changed {
            // outsorcing the functionality of the movement
            onRowPanGestureChange(translation, velocity: velocity, point: point)
        } else if sender.state == UIGestureRecognizerState.Ended {
            // doing different things depending on where we release the gesture
            switch translation.x {
            case let x where x <= -260:
                animateRow(CGPoint(x: rowViewMessageOriginalCenter.x - rowMessageImageView.frame.width, y: rowViewMessageOriginalCenter.y))
                doListView(1)
            case let x where x <= -60:
                animateRow(CGPoint(x: rowViewMessageOriginalCenter.x - rowMessageImageView.frame.width, y: rowViewMessageOriginalCenter.y))
                doRescheduledView(1)
            case let x where x >= 60:
                animateRow(CGPoint(x: rowViewMessageOriginalCenter.x + rowMessageImageView.frame.width, y: rowViewMessageOriginalCenter.y))
                closeRow()
                delay(2.5, closure: { () -> () in
                    self.openRow()
                })
            default:
                animateRow(rowViewMessageOriginalCenter)
                animateRowBackground(colorGrey)
            }
            
        }
        
    }
    
    func onRowPanGestureChange(translation: CGPoint, velocity: CGPoint, point: CGPoint) {
        
        let translateX = rowViewMessageOriginalCenter.x + translation.x
        let fixRowIconsX = rowMessageImageView.frame.width - leftIconRowView.frame.width/2
        
        // Managing backgrounds
        switch translation.x {
        case let x where x <= -260:
            animateRowBackground(colorBrown)
            rightIconImageView.image = UIImage(named: "list_icon" )
        case let x where x <= -10:
            animateRowBackground(colorYellow)
            rightIconImageView.image = UIImage(named: "later_icon" )
        case let x where (-10...10) ~= x:
            animateRowBackground(colorGrey)
            rightIconImageView.image = UIImage(named: "later_icon")
            leftIconImageView.image = UIImage(named: "archive_icon" )
        case let x where x >= 260:
            animateRowBackground(colorRed)
            leftIconImageView.image = UIImage(named: "delete_icon")
        case let x where x >= 10:
            animateRowBackground(colorGreen)
            leftIconImageView.image = UIImage(named: "archive_icon")
        default:
            animateRowBackground(colorGrey)
            rightIconImageView.image = UIImage(named: "later_icon")
            leftIconImageView.image = UIImage(named: "archive_icon" )
        }
        
        
        // Updating the position of the row and the icons
        rowMessageImageView.center = CGPoint(x: translateX, y:rowViewMessageOriginalCenter.y)
        leftIconRowView.center = CGPoint(x: (translation.x > 60 ? translateX - translateRowIconsX : leftIconRowView.frame.width / 2), y:rowViewMessageOriginalCenter.y)
        rightIconRowView.center = CGPoint(x: (translation.x < -60 ? translateX + translateRowIconsX : fixRowIconsX), y:rowViewMessageOriginalCenter.y)
        
        // Left and Right icons opacity
        leftIconRowView.alpha = convertValue(translation.x, r1Min: 10, r1Max: 60, r2Min: 0, r2Max: 1)
        rightIconRowView.alpha = convertValue(translation.x, r1Min: -10, r1Max: -60, r2Min: 0, r2Max: 1)
    }
    
    func animateRowBackground(color: UIColor) {
        UIView.animateWithDuration(0.2) { () -> Void in
            self.rowView.backgroundColor = color
        }
    }
    
    func animateRow(position:CGPoint) {
        UIView.animateWithDuration(0.2) { () -> Void in
            self.rowMessageImageView.center = position
            self.leftIconRowView.center = CGPoint(x: position.x - self.translateRowIconsX, y:position.y)
            self.rightIconRowView.center = CGPoint(x: position.x + self.translateRowIconsX, y:position.y)
            
        }
    }
    
    func closeRow () {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.rowView.frame.size.height = 0
            self.feedImageView.center.y = self.feedViewOriginalCenter.y - 86
        }
        setScrollContent()
    }
    
    func openRow () {
        resetRow()
        UIView.animateWithDuration(0.3) { () -> Void in
            self.rowView.frame.size.height = self.rowMessageImageView.frame.height
            self.feedImageView.center.y = self.feedViewOriginalCenter.y
        }
        setScrollContent()
    }
    
    func resetRow(){
        rowView.backgroundColor = colorGrey
        rowMessageImageView.center = rowViewMessageOriginalCenter
    }

    
    // Separated functions in case we want to develop different behaviours
    func doRescheduledView(alpha: CGFloat) {
        delay(0.2) { () -> () in
            UIView.animateWithDuration(0.2) { () -> Void in
                self.rescheduleView.alpha = alpha
            }
        }
    }

    func doListView(alpha: CGFloat) {
        delay(0.2) { () -> () in
            UIView.animateWithDuration(0.2) { () -> Void in
                self.listView.alpha = alpha
            }
        }
    }
    
    
    @IBAction func onTapScreen(sender: UITapGestureRecognizer) {
        // This should be more efficient based on the sender
        // but for the prototype it works
        doRescheduledView(0)
        doListView(0)
        delay(0.4) { () -> () in
            self.closeRow()
        }
        delay(2.5) { () -> () in
            self.openRow()
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
