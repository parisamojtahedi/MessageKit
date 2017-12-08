//
//  AudioMessageLayoutDelegate.swift
//  MessageKit
//
//  Created by Parisa Mojtahedi on 2017-12-07.
//

import AVFoundation

/// A protocol used by the `MessagesCollectionViewFlowLayout` object to determine
/// the size and layout of a `MediaMessageCell`s and its contents.
public protocol AudioMessageLayoutDelegate: MessagesLayoutDelegate {

    /// Specifies the width for a `MessageContainerView`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed by this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - maxWidth: The max available width for the `MessageContainerView` respecting the cell's other content.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// The default value returned by this method is the `maxWidth`.
    func widthForAudioMessage(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat

    /// Specifies the height for a `MessageContainerView`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed by this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - maxWidth: The max available width for the `MessageContainerView` respecting the cell's other content.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// The default value returned by this method uses `AVMakeRect(aspectRatio:insideRect:)` with a bounding
    /// rect using the `maxWidth` and `.greatestFiniteMagnitude` for the height.
    func heightForAudioMessage(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat

}
public extension AudioMessageLayoutDelegate {

    func widthForAudioMessage(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return maxWidth * 0.5
    }

    func heightForAudioMessage(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        switch message.data {
        case .audio(_):
            return maxWidth * 0.3
        default:
            return 0
        }
    }

}
