//
//  AudioMessageEventHandler.swift
//  MessageKit
//
//  Created by Parisa Mojtahedi on 2017-12-06.
//

import UIKit
import AVFoundation

public protocol AudioMessageEventHandler: class {
    func configure(cell: AudioMessageCell, at indexPath: IndexPath)
}
