//
//  AudioCellDelegate.swift
//  MessageKit
//
//  Created by Parisa Mojtahedi on 2017-12-05.
//

import Foundation

public protocol AudioCellDelegate: class {
    func audioStateDidChange(for cell: AudioMessageCell)
    func currentDuration() -> Float
    func currentTime() -> Float
}
