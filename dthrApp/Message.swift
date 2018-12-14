//
//  Message.swift
//  dthrApp
//
//  Created by 小泉大夢 on 2018/12/14.
//  Copyright © 2018 Yoshiaki Kato. All rights reserved.
//

import Foundation
import MessageKit

struct Message: MessageType {
    
    var sender: Sender
    var sentDate: Date
    var messageId: String
    var kind: MessageKind
    
}

