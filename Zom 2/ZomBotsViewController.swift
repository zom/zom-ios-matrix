//
//  ZomServicesViewController.swift
//  Zom 2
//
//  Created by N-Pex on 20.03.19.
//  Copyright © 2019 Zom. All rights reserved.
//

import UIKit
import KeanuCore
import MatrixSDK

fileprivate struct ZomBot {
    let name:String
    let userId:String
    let description:String
    let image:UIImage?
    let avatar:Data?
    
    static var allBots:[ZomBot] = {
        // Parse the plist to get all bots!
        var plistDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "ZomBots", ofType: "plist") {
            plistDictionary = NSDictionary(contentsOfFile: path)
        }
        var bots:[ZomBot] = []
        if let dict = plistDictionary {
            for (key, bot) in dict {
                if let bot = bot as? NSDictionary {
                    let name = bot["name"] as? String
                    let userId = bot["user"] as? String
                    let description = bot["description"] as? String
                    
                    // Get image
                    var image:UIImage? = nil
                    if let imageStringEncoded = bot["image"] as? String {
                        let dataDecoded : Data = Data(base64Encoded: imageStringEncoded, options: .ignoreUnknownCharacters)!
                        image = UIImage(data: dataDecoded)
                    }
                    
                    var avatar:Data? = nil
                    if let avatarStringEncoded = bot["avatar"] as? String {
                        avatar = Data(base64Encoded: avatarStringEncoded, options: .ignoreUnknownCharacters)!
                    }
                    let zomBot = ZomBot(name: name ?? "", userId: userId ?? "", description: description ?? "", image: image, avatar: avatar)
                    bots.append(zomBot)
                }
            }
        }
        return bots
    }()
}

open class ZomBotsViewController: UITableViewController {
    
    /**
     Instantiate a color picker view controller with the given selection callback.
     */
    class func instantiate() -> UIViewController? {
        
        if let vc = UIStoryboard.overriddenOrLocal(name: String(describing: self))
            .instantiateInitialViewController() as? ZomBotsViewController {
            return vc
        }
        return nil
    }
    
    open override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ZomBot.allBots.count
    }
    
    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ZomBotCell? = tableView.dequeueReusableCell(withIdentifier: "cellZomBot", for: indexPath) as? ZomBotCell
        if let cell = cell {
            let bot = ZomBot.allBots[indexPath.row]
            cell.botImageView.image = bot.image
            cell.titleLabel.text = bot.name
            cell.descriptionLabel.text = bot.description
            
            // Use tag to store index, used in didPressStartChatButton below
            cell.startChatButton.tag = indexPath.row
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell() // Error
    }
    
    @IBAction func didPressStartChatButtonWithSender(_ sender: AnyObject) {
        if let button = sender as? UIButton {
            let bot = ZomBot.allBots[button.tag]
            // Bots are not currently encrypted!
            UIApplication.shared.openRoom(matrixId: bot.userId, encrypted: false)
        }
    }
    
    fileprivate func getZombotBuddy(bot: ZomBot) -> Friend? {
        return nil //TODO
    }
}
