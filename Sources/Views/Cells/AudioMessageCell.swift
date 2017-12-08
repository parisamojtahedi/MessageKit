//
//  AudioMessageCell.swift
//  MessageKit
//
//  Created by Parisa Mojtahedi on 2017-12-05.
//

import UIKit
import AVFoundation

public enum State {
    case playing
    case paused
    case stopped
}
open class AudioMessageCell: MessageCollectionViewCell<UIView> {
    open override class func reuseIdentifier() -> String { return "messagekit.cell.audiomessage" }

    // MARK: - Properties
    open var url: URL?
    private var timer: Timer?

    open var state: State = .stopped {
        didSet {
            if state == .playing {
                DispatchQueue.main.async { [weak self] in
                    self?.playingStateView()
                    self?.updateProgress()
                    self?.setNeedsDisplay()
                }
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateProgress), userInfo: nil, repeats: true)
            } else if state == .paused {
                DispatchQueue.main.async { [weak self] in
                    self?.pauseStateView()
                    self?.timer?.invalidate()
                    self?.setNeedsDisplay()

                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.timer?.invalidate()
                    self?.stopStateView()
                    self?.setNeedsDisplay()
                }
            }
        }
    }

    private func playingStateView() {
        pauseButtonView.isHidden = false
        playButtonView.isHidden = true
        progressView.isHidden = false
        timerLabel.isHidden = false
    }

    private func pauseStateView() {
        pauseButtonView.isHidden = true
        playButtonView.isHidden = false
        progressView.isHidden = false
        timerLabel.isHidden = false
    }

    private func stopStateView() {
        playButtonView.isHidden = false
        pauseButtonView.isHidden = true
        progressView.isHidden = true
        timerLabel.isHidden = true
    }

    open lazy var playButtonView: PlayButtonView = {
        let playButtonView = PlayButtonView()
        playButtonView.frame.size = CGSize(width: 35, height: 35)
        return playButtonView
    }()

    open lazy var pauseButtonView: PauseButtonView = {
        let pauseButtonView = PauseButtonView()
        pauseButtonView.frame.size = CGSize(width: 35, height: 35)
        return pauseButtonView
    }()

    open var progressView = UIProgressView(progressViewStyle: .bar)
    var timerLabel: UILabel = UILabel()


    // Delegate:
    open weak var audioDelegate: AudioCellDelegate?

    // MARK: - Methods

    @objc func updateProgress() {
            if let audioDelegate = self.audioDelegate {

                // Update Progress bar
                let percent = Double(audioDelegate.currentTime()) / Double(audioDelegate.currentDuration())
                progressView.setProgress(Float(percent), animated: false)

                // Formatting time
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [ .minute, .second ]
                formatter.zeroFormattingBehavior = [ .pad ]

                let formattedDuration = formatter.string(from: TimeInterval(audioDelegate.currentTime()))
                if let duration = formattedDuration {
                    timerLabel.text = "\(duration)"
            }
        }
    }

    private func setupConstraints() {
        playButtonView.translatesAutoresizingMaskIntoConstraints = false
        pauseButtonView.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false

        let centerX = playButtonView.centerXAnchor.constraint(equalTo: messageContainerView.centerXAnchor)
        let centerY = playButtonView.centerYAnchor.constraint(equalTo: messageContainerView.centerYAnchor, constant: -8)
        let width = playButtonView.widthAnchor.constraint(equalToConstant: playButtonView.bounds.width)
        let height = playButtonView.heightAnchor.constraint(equalToConstant: playButtonView.bounds.height)
        
        NSLayoutConstraint.activate([centerX, centerY, width, height])

        let pauseCenterX = pauseButtonView.centerXAnchor.constraint(equalTo: messageContainerView.centerXAnchor)
        let pauseCenterY = pauseButtonView.centerYAnchor.constraint(equalTo: messageContainerView.centerYAnchor, constant: -8)
        let pauseWidth = pauseButtonView.widthAnchor.constraint(equalToConstant: pauseButtonView.bounds.width)
        let pauseHeight = pauseButtonView.heightAnchor.constraint(equalToConstant: pauseButtonView.bounds.height)

        NSLayoutConstraint.activate([pauseCenterX, pauseCenterY, pauseWidth, pauseHeight])

        let progressBarCenterX = progressView.centerXAnchor.constraint(equalTo: messageContainerView.centerXAnchor)
        let progressBarCenterY = progressView.centerYAnchor.constraint(equalTo: messageContainerView.centerYAnchor, constant: 16)
        let progressBarLeft = progressView.leftAnchor.constraint(equalTo: messageContainerView.leftAnchor, constant: 40)
        let progressBarRight = progressView.rightAnchor.constraint(equalTo: messageContainerView.rightAnchor, constant: -40)

        NSLayoutConstraint.activate([progressBarCenterX, progressBarCenterY, progressBarLeft, progressBarRight])

        let timerCenterX = timerLabel.centerXAnchor.constraint(equalTo: messageContainerView.centerXAnchor)
        let timerCenterY = timerLabel.centerYAnchor.constraint(equalTo: messageContainerView.centerYAnchor, constant: 32)
        let timerLeft = timerLabel.leftAnchor.constraint(equalTo: messageContainerView.leftAnchor, constant: 40)
        let timerRight = timerLabel.rightAnchor.constraint(equalTo: messageContainerView.rightAnchor, constant: -40)

        NSLayoutConstraint.activate([timerCenterX, timerCenterY, timerLeft, timerRight])
    }

    override func setupSubviews() {
        super.setupSubviews()

        messageContentView.addSubview(playButtonView)
        messageContentView.addSubview(pauseButtonView)
        messageContentView.addSubview(makeProgressView())
        messageContentView.addSubview(timerLabel)
        self.timerLabel.textAlignment = .center

        setupConstraints()
    }

    override func didTapMessage() {
        DispatchQueue.main.async {
            self.audioDelegate?.audioStateDidChange(for: self)
            super.didTapMessage()
        }
    }

    func makeProgressView() -> UIProgressView {
        progressView.frame.size =  CGSize(width: 60, height: 40)
        progressView.tintColor = .blue
        progressView.backgroundColor = .gray
        return progressView
    }

    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        switch message.data {
        case .audio(let audio):
            self.url = audio
        default:
            break
        }
    }

    override open func prepareForReuse() {
        self.timerLabel.isHidden = true
    }
}
