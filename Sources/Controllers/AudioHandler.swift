//
//  AudioHandler.swift
//  MessageKit
//
//  Created by Parisa Mojtahedi on 2017-12-06.
//

import UIKit
import AVFoundation

public class AudioHandler: NSObject, AudioMessageEventHandler {

    private unowned var collectionView: MessagesCollectionView

    private var audioPlayer: AVAudioPlayer?

    private var currentIndexPath: IndexPath?

    init(collectionView: MessagesCollectionView) {
        self.collectionView = collectionView
    }

    public func configure(cell: AudioMessageCell, at indexPath: IndexPath) {
            cell.audioDelegate = self
            if indexPath == self.currentIndexPath, let player = self.audioPlayer {
                if player.isPlaying {
                    cell.state = .playing
                } else {
                    cell.state = .paused
                }
            } else {
                cell.state = .stopped
            }
    }

    private func playSound(with url: URL?) {
        guard let soundURL = url else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)

            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()

            guard let player = audioPlayer else { return }
            player.delegate = self
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }

    private func resumeSound() {
        if let player = self.audioPlayer {
            player.play()
        }
    }

    private func pauseSound() {
        if let player = self.audioPlayer, player.isPlaying {
            player.pause()
        }
    }

    private func stopSound() {
        if let player = self.audioPlayer, player.isPlaying {
            player.stop()
        }
    }
}
extension AudioHandler: AudioCellDelegate {
    public func audioStateDidChange(for cell: AudioMessageCell) {
        if self.currentIndexPath == nil { //first time cell is tapped
            self.currentIndexPath = self.collectionView.indexPath(for: cell)
            cell.state = .playing
            self.playSound(with: cell.url)
        } else if self.currentIndexPath == self.collectionView.indexPath(for: cell) { //second time tap on the same cell
            if cell.state == .playing {
                cell.state = .paused
                self.pauseSound()
            } else {
                cell.state = .playing
                self.resumeSound()
            }
        } else {
            let previousSection =  currentIndexPath?.section
            self.currentIndexPath = self.collectionView.indexPath(for: cell)
            if let section = previousSection {
                self.collectionView.reloadSections(IndexSet(integer:section))
            }
            cell.state = .playing
            self.playSound(with: cell.url)
        }
    }

    public func currentDuration() -> Float {
        guard let player = self.audioPlayer else { return 0 }
        return Float(player.duration)
    }

    public func currentTime() -> Float {
        guard let player = self.audioPlayer else { return 0 }
        return Float(player.currentTime)
    }
}

extension AudioHandler: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let indexPath = self.currentIndexPath, let cell = self.collectionView.cellForItem(at: indexPath) as? AudioMessageCell {
            cell.state = .stopped
        }
    }
}

