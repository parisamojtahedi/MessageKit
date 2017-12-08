//
//  PauseButtonView.swift
//  MessageKit
//
//  Created by Parisa Mojtahedi on 2017-11-29.
//

import Foundation

open class PauseButtonView: UIView {

    // MARK: - Properties

    open let pauseView = UIView()

    private var pauseHeightConstraint: NSLayoutConstraint?
    private var pauseWidthConstraint: NSLayoutConstraint?
    private var pauseCenterXConstraint: NSLayoutConstraint?

    private var pauseViewSize: CGSize {
        return CGSize(width: frame.width/2, height: frame.height/2)
    }

    open override var frame: CGRect {
        didSet {
            updatePauseConstraints()
            applyCornerRadius()
            applypauseMask()
        }
    }

    open override var bounds: CGRect {
        didSet {
            updatePauseConstraints()
            applyCornerRadius()
            applypauseMask()
        }
    }

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupSubviews()
        setupConstraints()
        applyCornerRadius()
        applypauseMask()

        pauseView.clipsToBounds = true
        pauseView.backgroundColor = .black
        backgroundColor = .playButtonLightGray
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setupSubviews() {
        addSubview(pauseView)
    }

    private func setupConstraints() {
        pauseView.translatesAutoresizingMaskIntoConstraints = false

        let centerX = pauseView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: pauseViewSize.width/8)
        let centerY = pauseView.centerYAnchor.constraint(equalTo: centerYAnchor)
        let width = pauseView.widthAnchor.constraint(equalToConstant: pauseViewSize.width)
        let height = pauseView.heightAnchor.constraint(equalToConstant: pauseViewSize.height)

        pauseWidthConstraint = width
        pauseHeightConstraint = height
        pauseCenterXConstraint = centerX

        NSLayoutConstraint.activate([centerX, centerY, width, height])
    }

    private func pauseMask(for frame: CGRect) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        let pausePath = UIBezierPath()

        let point1 = CGPoint(x: frame.minX, y: frame.minY)
        let point2 = CGPoint(x: frame.maxX/4, y: frame.minY)
        let point3 = CGPoint(x: frame.minX, y: frame.maxY)
        let point4 = CGPoint(x: frame.maxX/4, y: frame.maxY)

        pausePath .move(to: point1)
        pausePath .addLine(to: point2)
        pausePath .addLine(to: point4)
        pausePath .addLine(to: point3)
        pausePath .addLine(to: point1)
        pausePath .close()

        let point5 = CGPoint(x: frame.maxX/2, y: frame.minY)
        let point6 = CGPoint(x: frame.maxX * 3/4, y: frame.minY)
        let point7 = CGPoint(x: frame.maxX * 3/4, y: frame.maxY)
        let point8 = CGPoint(x: frame.maxX/2, y: frame.maxY)

        pausePath .move(to: point5)
        pausePath .addLine(to: point6)
        pausePath .addLine(to: point7)
        pausePath .addLine(to: point8)
        pausePath .addLine(to: point5)
        pausePath .close()

        // STOP
//        let point1 = CGPoint(x: frame.minX, y: frame.minY)
//        let point2 = CGPoint(x: frame.maxX, y: frame.minY)
//        let point3 = CGPoint(x: frame.minX, y: frame.maxY)
//        let point4 = CGPoint(x: frame.maxX, y: frame.maxY)
//
//        pausePath .move(to: point1)
//        pausePath .addLine(to: point2)
//        pausePath .addLine(to: point4)
//        pausePath .addLine(to: point3)
//        pausePath .addLine(to: point1)
//        pausePath .close()

        shapeLayer.path = pausePath.cgPath

        return shapeLayer
    }

    private func updatePauseConstraints() {
        pauseWidthConstraint?.constant = pauseViewSize.width
        pauseHeightConstraint?.constant = pauseViewSize.height
        pauseCenterXConstraint?.constant = pauseViewSize.width/8
    }

    private func applypauseMask() {
        let rect = CGRect(origin: .zero, size: pauseViewSize)
        pauseView.layer.mask = pauseMask(for: rect)
    }

    private func applyCornerRadius() {
        layer.cornerRadius = frame.width / 2
    }

}
