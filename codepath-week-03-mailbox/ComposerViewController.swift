//
//  ComposerViewController.swift
//  codepath-week-03-mailbox
//
//  Created by mmuno on 10/5/15.
//  Copyright © 2015 mamuso. All rights reserved.
//

import UIKit

class ComposerViewController: UIViewController {

    @IBOutlet weak var toTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressCancel(sender: AnyObject) {
        resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
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
