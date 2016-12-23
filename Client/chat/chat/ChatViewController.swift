//
//  ChatViewController.swift
//  chat
//
//  Created by daihase on 2016/12/22.
//  Copyright © 2016年 Libra Studio, Inc. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    var name: String?
    var messages: [JSQMessage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setChatModuleParam()
        
        // キーボードのジェスチャー登録.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    func setChatModuleParam() {
        senderDisplayName = "A"
        senderId = "Self"
        self.name = "毒きのこ"
        
        // Node.jsからのメッセージをブロードキャストし、画面にそれを表示。
        SocketIOManager.sharedInstance.getChatMessage {
            (messageInfo)-> Void in
            self.messages.append(messageInfo)
            self.finishReceivingMessage(animated: true)
        }
    }
    
     func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: JSQMessageViewController
extension ChatViewController {
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    // チャットの吹き出し設定.
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        if messages[indexPath.row].senderId == senderId {
            return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(
                with: UIColor(red: 112/255, green: 192/255, blue:  75/255, alpha: 1))
        } else {
            return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(
                with: UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1))
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    // アバターのイメージ設定.
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        return JSQMessagesAvatarImageFactory.avatarImage(
            withUserInitials: messages[indexPath.row].senderDisplayName,
            backgroundColor: UIColor.lightGray, textColor: UIColor.white,
            font: UIFont.systemFont(ofSize: 10), diameter: 30)
    }
    
    // Sendボタンが押された時に呼ばれる.
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        // 新しいメッセージデータを追加する.
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        self.messages.append(message!)
        self.finishReceivingMessage(animated: true)
        
        // サーバーへメッセージ送信.
        SocketIOManager.sharedInstance.sendMessage(text, name: name!)
        
        // TextFieldのテキストをクリア.
        self.inputToolbar.contentView.textView.text = ""
        self.inputToolbar.toggleSendButtonEnabled()
    }
}
