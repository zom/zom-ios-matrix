//
//  ZomDiscoverViewController.swift
//  Zom 2
//
//  Created by N-Pex on 20.03.19.
//  Copyright © 2019 Zom. All rights reserved.
//

import Keanu
import MatrixSDK

class ZomDiscoverViewController: DiscoverViewController, DiscoverViewControllerDelegate, PickStickerViewControllerDelegate {
    
    static let identifierBots = "bots"
    static let identifierStickerShare = "stickerShare"
    static let identifierChangeTheme = "changeTheme"

    var stickerShareCell: ActionButtonCell?
    
    override func viewDidLoad() {
        // First set delegate, then call super
        super.delegate = self
        
        super.viewDidLoad()
    }
    
    public func initializeRows(identifiers: [String]) -> [String] {
        var rows = identifiers
        rows.insert(ZomDiscoverViewController.identifierBots, at: 0)
        rows.append(ZomDiscoverViewController.identifierStickerShare)
        rows.append(ZomDiscoverViewController.identifierChangeTheme)
        return rows
    }
    
    public func setupRow(identifier: String, cell: ActionButtonCell) -> Bool {
        switch identifier {
        case ZomDiscoverViewController.identifierBots:
            cell.apply("", "Zom Services".localize())
        case ZomDiscoverViewController.identifierStickerShare:
            stickerShareCell = cell
            cell.apply("", "Sticker Share".localize())
        case ZomDiscoverViewController.identifierChangeTheme:
            cell.apply("", "Change Theme".localize())
        default: return false
        }
        return true
    }
    
    public func didSelectRow(identifier: String) -> Bool {
        switch identifier {
        case ZomDiscoverViewController.identifierBots:
            if let vc = ZomBotsViewController.instantiate(){
                navigationController?.pushViewController(vc, animated: true)
            }
            return true
            
        case ZomDiscoverViewController.identifierStickerShare:
            let vc = UIApplication.shared.theme.createStickerPackViewController()
            vc.pickDelegate = self
            present(UINavigationController(rootViewController: vc), animated: true)
            return true
            
        case ZomDiscoverViewController.identifierChangeTheme:
            if let vc = ZomPickColorViewController.instantiate(selectionCallback: { (color) in
                // Select new color as theme color
                UITheme.shared.selectMainThemeColor(color)
                self.navigationController?.isNavigationBarHidden = true
                self.navigationController?.isNavigationBarHidden = false
                self.tabBarController?.tabBar.barTintColor = color
            }){
                // Ideally we would want a "push" here like above, but then selecting a color and getting back here would not update all of the UI without ugly hacks.
                // See: https://stackoverflow.com/questions/21652957/uinavigationbar-appearance-refresh/21653004
                present(vc, animated: true, completion: nil)
            }
            return true
        default: return false
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
    }
    
    // MARK: Sticker Share
    func didPickSticker(_ sticker: String, inPack: String) {
        DispatchQueue.main.async {
            if
                let cell = self.stickerShareCell,
                let stickerFile = StickerManager.filenameFor(sticker: sticker, inPack: inPack),
                let image = UIImage(contentsOfFile: stickerFile) {
                let shareItems:Array = [image]
                
                let activityVc = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
                
                activityVc.popoverPresentationController?.sourceView = cell.contentView
                activityVc.popoverPresentationController?.sourceRect = cell.contentView.bounds
                
                self.present(activityVc, animated: true, completion: nil)
            }
        }
    }
}
