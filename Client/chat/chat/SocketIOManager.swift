//
//  SocketIOManager.swift
//  chat
//
//  Created by daihase on 2016/12/22.
//  Copyright © 2016年 Libra Studio, Inc. All rights reserved.
//

import UIKit
import SocketIO
import JSQMessagesViewController

class SocketIOManager: NSObject {
    
    // Singleton.
    class var sharedInstance: SocketIOManager {
        struct Static {
            static let instance: SocketIOManager = SocketIOManager()
        }
        return Static.instance
    }
    
    private override init() {super.init()}
    
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "http://ドメイン名:3000/chat/public/chat.html") as! URL)
    
    // 接続.
    func establishConnection() {
        socket.on("connect") { data in
            print("iOS側からサーバーへsocket接続.")
        }
        socket.connect()
    }
    
    // 切断.
    func closeConnection() {
        socket.on("disconnect") { data in
            print("socketが切断されました")
        }
        socket.disconnect()
    }
    
    // メッセージ送信.
    func sendMessage(_ message: String, name: String) {
        socket.emit("from_client", name, message)
    }
    
    // メッセージ受信.
    func getChatMessage(_ completionHandler: @escaping (_ messageInfo: JSQMessage) -> Void) {
        socket.on("from_server") { (dataArray, socketAck) -> Void in

            print(dataArray[0])
            let message = dataArray[0] as! String
            let jsqMessage = JSQMessage(senderId: "Other", displayName: "B", text: message)
            completionHandler(jsqMessage!)
        }
    }
}
