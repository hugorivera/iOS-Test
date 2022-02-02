//
//  CameraOptionsViewController.swift
//  ExiOS
//
//  Created by Web Master on 01/02/22.
//

import UIKit

protocol CameraOptionsDelegate: AnyObject {
    func seeImageSelected()
    func selectImageCamera(viewController: UIViewController)
}

class CameraOptionsViewController: UIViewController {
    
    @IBOutlet weak var workAreaView: UIView!
    @IBOutlet weak var hiddenAreaView: UIView!
    
    let maxAlpha: CGFloat = 0.6
    
    weak var clickCameraOptions: CameraOptionsDelegate!
//    var tabBarHidden = false
//    var tabbar = UITabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        hiddenAreaView.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateShowDimmedView()
    }
    
    @IBAction func startCameraAction(_ sender: UITapGestureRecognizer) {
//        close()
        clickCameraOptions.selectImageCamera(viewController: self)
    }
    
    @IBAction func showImageAction(_ sender: UITapGestureRecognizer) {
        clickCameraOptions.seeImageSelected()
    }
    
    @IBAction func closeController(_ sender: UITapGestureRecognizer) {
        close()
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        close()
    }
    
    func animateShowDimmedView() {
        hiddenAreaView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.hiddenAreaView.alpha = self.maxAlpha
        }
    }
    
    private func close(){
        // hide blur view
        hiddenAreaView.alpha = maxAlpha
        UIView.animate(withDuration: 0.4) {
            self.hiddenAreaView.alpha = 0
        } completion: { _ in
            // once done, dismiss without animation
            self.dismiss(animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
