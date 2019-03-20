//
//  ZomPickColorViewController.swift
//  Zom 2
//
//  Created by N-Pex on 20.03.19.
//  Copyright © 2019 Zom. All rights reserved.
//

import UIKit

open class ZomPickColorViewController: UICollectionViewController {
    
    private var colors: [UIColor] = []
    private var selectedColor:UIColor? = nil
    private var selectionCallback:((UIColor) -> Void)?
    
    /**
     Instantiate a color picker view controller with the given selection callback.
     */
    class func instantiate(selectionCallback: ((UIColor) -> Void)?) -> UIViewController? {
        
        if let navC = UIStoryboard.overriddenOrLocal(name: String(describing: self))
            .instantiateInitialViewController() as? UINavigationController {
            
            if let vc = navC.topViewController as? ZomPickColorViewController {
                vc.selectionCallback = selectionCallback
            }
            
            return navC
        }
        return nil
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        colors.append(UIColor(netHex: 0xffe7275a))
        colors.append(UIColor(netHex: 0xFFECEFF1))
        colors.append(UIColor(netHex: 0xcc00ddff))
        colors.append(UIColor(netHex: 0xffff00dd))
        colors.append(UIColor(netHex: 0xcc99cc00))
        colors.append(UIColor(netHex: 0xcccc0000))
        colors.append(UIColor(netHex: 0xccffbb33))
    }
    
    // Mark - UICollectionViewDataSource
    
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundView?.backgroundColor = colors[indexPath.item]
        cell.backgroundColor = colors[indexPath.item]
        return cell
    }
    
    open override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColor = colors[indexPath.item]
        if let selectedColor = selectedColor {
            selectionCallback?(selectedColor)
        }
        // Dismiss the view
        cancel()
    }
    
    @IBAction func cancel() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
