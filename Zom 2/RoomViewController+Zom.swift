//
//  RoomViewController+Zom.swift
//  Zom 2
//
//  Created by N-Pex on 30.01.19.
//  Copyright © 2019 Zom. All rights reserved.
//

import Keanu
import MatrixSDK

extension RoomViewController {
    func initializeForZom() {

        // Create a custom renderer for Zom stickers
        //
        let renderer = { (cell:UITableViewCell, roomBubbleData:RoomBubbleData, delegate: RoomBubbleDataRendererDelegate?) in
            if let cell = cell as? MessageCell,
                let event = roomBubbleData.events.first,
                let stickerPack = event.content["zom_sticker_pack"] as? String,
                let sticker = event.content["zom_sticker"] as? String,
                let filePath = RoomViewController.getFilenameForSticker(sticker, inPack: stickerPack)
                {
                    cell.render(roomBubbleData: roomBubbleData, delegate: delegate)
                    let incoming = roomBubbleData.isIncoming
                    
                    let container = UIView()
                    container.autoSetDimension(.height, toSize: 200)
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
                    container.setBubbleView(incoming ? BubbleViewType.incoming : BubbleViewType.outgoing)
            }
        }
        
        RoomDataSource.bubbleProcessor = { (_ roomDataSource: RoomDataSource, _ event: MXEvent, _ roomBubbleData: RoomBubbleData?, _ roomState: MXRoomState) in
            
            // Zom sticker?!?
            if roomBubbleData == nil,
                event.eventType == __MXEventTypeSticker, event.content.keys.contains("zom_sticker") {
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
    
    static func getFilenameForSticker(_ sticker:String, inPack pack:String) -> String? {
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
        
        // Add sticker options last
        let _ = attachmentPicker.addAction("") {
            // Pick sticker!
            //closePickerView()
            let storyboard = UIStoryboard(name: "StickerShare", bundle: Bundle.main)
            let vc = storyboard.instantiateInitialViewController()
            self.present(vc!, animated: true, completion: nil)
        }
        
        // Style the buttons
        for actionButton in attachmentPicker.actions() {
            actionButton.backgroundColor = Theme.shared.mainThemeColor
            actionButton.tintColor = UIColor.white
        }
    }
}

extension RoomViewController: ZomPickStickerViewControllerDelegate {
    
    @IBAction func unwindPickSticker(_ unwindSegue: UIStoryboardSegue) {
    }

    public func didPickSticker(_ sticker: String, inPack pack: String) {
        closeAttachmentPicker()
        
        if let room = self.room {
            
            // Create a custom message of type "m.sticker"
            let content:[String:Any] = [
                "msgtype" : "m.zom_sticker",
                "zom_sticker_pack" : pack,
                "zom_sticker" : sticker
            ]
            var localEcho:MXEvent?
            room.sendEvent(MXEventType(identifier: kMXEventTypeStringSticker), content: content, localEcho: &localEcho) { (response) in
                    //TODO - handle response
            }
            self.dataSource?.insertLocalEcho(event: localEcho, roomState: room.dangerousSyncState)
        }
    }
}
