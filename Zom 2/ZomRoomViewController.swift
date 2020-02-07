//
//  RoomViewController+Zom.swift
//  Zom 2
//
//  Created by N-Pex on 30.01.19.
//  Copyright © 2019 Zom. All rights reserved.
//

import Keanu
import MatrixSDK

class ZomRoomViewController: RoomViewController {

    override func viewDidLoad() {
        initializeForZom()
        super.viewDidLoad()
    }
    
    func initializeForZom() {
        
        // Create a custom renderer for Zom stickers
        //
        let renderer = { (cell:UITableViewCell, roomBubbleData:RoomBubbleData, delegate: RoomBubbleDataRendererDelegate?) in
            if let cell = cell as? MessageCell,
                let event = roomBubbleData.events.first,
                event.eventType == __MXEventTypeRoomMessage,
                let msgType = event.content["msgtype"] as? String,
                msgType == kMXMessageTypeText,
                let body = event.content["body"] as? String,
                ZomRoomViewController.isValidStickerShortCode(body),
                let filePath = ZomRoomViewController.getStickerFilenameFromMessage(body)
            {
                cell.render(roomBubbleData: roomBubbleData, delegate: delegate)
                
                // Remove any content views generated
                for view in cell.messageContentContainer?.arrangedSubviews ?? [] {
                    cell.messageContentContainer?.removeArrangedSubview(view)
                    view.removeFromSuperview()
                }
                
                let incoming = roomBubbleData.isIncoming
                
                let container = UIView()
                container.autoSetDimension(.height, toSize: 150)
                container.translatesAutoresizingMaskIntoConstraints = false
                
                let stickerView = UIImageView(image: UIImage(contentsOfFile: filePath))
                stickerView.contentMode = .scaleAspectFit
                stickerView.translatesAutoresizingMaskIntoConstraints = false
                container.addSubview(stickerView)
                stickerView.autoPinEdgesToSuperviewEdges()
                
                cell.messageContentContainer.addArrangedSubview(container)
                container.autoPinEdge(toSuperviewEdge: (incoming ? .leading : .trailing))
                
                container.setNeedsLayout()
                container.layoutIfNeeded()
                container.layer.frame = container.bounds
                //container.setBubbleView(incoming ? BubbleViewType.incoming : BubbleViewType.outgoing)
            }
        }
        
        RoomDataSource.bubbleProcessor = { (_ roomDataSource: RoomDataSource, _ event: MXEvent, _ roomBubbleData: RoomBubbleData?, _ roomState: MXRoomState) in
            
            // Zom sticker?!?
            if ZomRoomViewController.isStickerEvent(event: event) {

                // Replace this bubble with a custom sticker one
                let bubble = RoomBubbleData(roomDataSource,
                                            state: roomState,
                                            events: [event],
                                            type: RoomBubbleDataType.unknown)
                if let bubble = bubble {
                    bubble.bubbleType = bubble.isIncoming ? .custom(IncomingMessageCell.defaultReuseId, renderer) : .custom(OutgoingMessageCell.defaultReuseId, renderer)
                }
                return bubble
            }
            
            return roomBubbleData
        }
        
        // Set the delegate for the attachment picker, please see the RoomViewController extension.
        attachmentPickerDelegate = self
    }
    
    public static func isStickerEvent(event: MXEvent) -> Bool {
        if event.eventType == __MXEventTypeRoomMessage,
            let msgType = event.content["msgtype"] as? String,
            msgType == kMXMessageTypeText,
            let body = event.content["body"] as? String,
            ZomRoomViewController.isValidStickerShortCode(body) {
            return true
        }
        return false
    }
    
    fileprivate static func isValidStickerShortCode(_ message:String) -> Bool {
        if message.hasPrefix(":"), message.hasSuffix(":") {
            if let fileName = getStickerFilenameFromMessage(message) {
                if (FileManager.default.fileExists(atPath: fileName)) {
                    return true
                }
            }
        }
        return false
    }
    
    fileprivate static func getStickerFilenameFromMessage(_ message:String) -> String? {
        let stickerDescription = message.trimmingCharacters(in: CharacterSet(charactersIn: ":"))
        if let firstDash = stickerDescription.index(of: "-") {
            let packPart = String(stickerDescription[..<firstDash])
            let stickerPart = String(stickerDescription[stickerDescription.index(firstDash, offsetBy: 1)...])
            let regex = try! NSRegularExpression(pattern: "[^a-zA-Z0-9_& -]+", options: [])
            let messagePack = regex.stringByReplacingMatches(in: packPart, options: [], range: NSMakeRange(0, packPart.count), withTemplate: "")
            let messageSticker = regex.stringByReplacingMatches(in: stickerPart, options: [], range: NSMakeRange(0, stickerPart.count), withTemplate: "")
            return getFilenameForSticker(messageSticker, inPack: messagePack)
        }
        return nil
    }
    
    fileprivate static func getFilenameForSticker(_ sticker:String, inPack pack:String) -> String? {
        var foundPack:String?
        var foundSticker:String?
        
        // iOS is case sensitive, so need to match file case
        //
        let docsPath = Bundle.main.resourcePath! + "/Stickers"
        let fileManager = FileManager.default
        do {
            let stickerPacks = try fileManager.contentsOfDirectory(atPath: docsPath)
            for stickerPack in stickerPacks {
                let stickerPackName = String(stickerPack[stickerPack.index(stickerPack.startIndex, offsetBy: 3)...])
                if (stickerPackName.caseInsensitiveCompare(pack) == ComparisonResult.orderedSame) {
                    foundPack = stickerPack
                    
                    let stickers = try fileManager.contentsOfDirectory(atPath: docsPath + "/" + foundPack!)
                    for s in stickers {
                        var sName = s
                        if s.hasPrefix("_") {
                            sName = String(s[s.index(s.startIndex, offsetBy: 1)...])
                        }
                        if (sName.caseInsensitiveCompare(sticker + ".png") == ComparisonResult.orderedSame) {
                            foundSticker = s
                            break
                        }
                    }
                    break
                }
            }
        } catch {
            print(error)
        }
        
        if (foundPack != nil && foundSticker != nil) {
            return Bundle.main.resourcePath! + "/Stickers/" + foundPack! + "/" + foundSticker!
        }
        return nil
    }
}

/**
 Extension to RoomViewController, handles attachent picker actions
 */
extension RoomViewController: RoomViewControllerAttachmentPickerDelegate {
    public func addActions(attachmentPicker: AttachmentPicker, room: MXRoom?) {
        
        // Add sticker option right before story button
        var index:Int? = nil
        if attachmentPicker.actions().count > 0 {
            index = attachmentPicker.actions().count - 1
        }
        let _ = attachmentPicker.addAction("", at: index) {
            // Pick sticker!
            //closePickerView()
            let storyboard = UIStoryboard(name: "StickerShare", bundle: Bundle.main)
            let vc = storyboard.instantiateInitialViewController()
            self.present(vc!, animated: true, completion: nil)
        }
        
        // Style the buttons
        for actionButton in attachmentPicker.actions() {
            actionButton.backgroundColor = UITheme.shared.mainThemeColor
            actionButton.tintColor = UIColor.white
        }
    }
    
    @IBAction open func stickerButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "StickerShare", bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController()
        self.present(vc!, animated: true, completion: nil)
    }
}

extension RoomViewController: ZomPickStickerViewControllerDelegate {
    
    @IBAction func unwindPickSticker(_ unwindSegue: UIStoryboardSegue) {
    }
    
    public func didPickSticker(_ sticker: String, inPack pack: String) {
        closeAttachmentPicker()
        
        if let room = self.room {
            let stickerMessage = ":" + pack + "-" + sticker + ":"
            var localEcho:MXEvent?
            room.sendTextMessage(stickerMessage, localEcho: &localEcho) { (response) in
                //TODO - handle response
            }
            self.dataSource?.insertLocalEcho(event: localEcho, roomState: room.dangerousSyncState)
        }
    }
}
