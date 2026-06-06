//  LoopingVideoView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 06/06/2026.
//

import AVFoundation
import SwiftUI

struct LoopingVideoView: UIViewRepresentable {
    let resourceName: String

    func makeUIView(context: Context) -> LoopingPlayerView {
        let view = LoopingPlayerView()
        view.configure(resourceName: resourceName)
        return view
    }

    func updateUIView(_ view: LoopingPlayerView, context: Context) {
        view.configure(resourceName: resourceName)
    }
}

final class LoopingPlayerView: UIView {
    private var activeSlot = PlayerSlot()
    private var standbySlot = PlayerSlot()
    private var requestedResourceName: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isOpaque = false
        layer.addSublayer(activeSlot.playerLayer)
        layer.addSublayer(standbySlot.playerLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        activeSlot.playerLayer.frame = bounds
        standbySlot.playerLayer.frame = bounds
    }

    func configure(resourceName: String) {
        guard activeSlot.resourceName != resourceName else {
            activeSlot.play()
            return
        }

        guard requestedResourceName != resourceName else {
            standbySlot.play()
            return
        }

        guard let url = Bundle.main.url(
            forResource: resourceName,
            withExtension: "mp4"
        ) else {
            return
        }

        requestedResourceName = resourceName
        standbySlot.playerLayer.removeFromSuperlayer()
        layer.addSublayer(standbySlot.playerLayer)
        standbySlot.playerLayer.frame = bounds
        standbySlot.prepare(
            resourceName: resourceName,
            url: url
        ) { [weak self] readyResourceName in
            self?.showStandbyVideo(
                resourceName: readyResourceName
            )
        }
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()

        if window == nil {
            activeSlot.pause()
            standbySlot.pause()
        } else {
            activeSlot.play()
            standbySlot.play()
        }
    }

    private func showStandbyVideo(resourceName: String) {
        guard requestedResourceName == resourceName,
              standbySlot.resourceName == resourceName else {
            return
        }

        let previousSlot = activeSlot
        let nextSlot = standbySlot
        let previousResourceName = previousSlot.resourceName

        activeSlot = nextSlot
        standbySlot = previousSlot
        requestedResourceName = nil

        CATransaction.begin()
        CATransaction.setAnimationDuration(0.25)
        CATransaction.setCompletionBlock { [weak self] in
            guard self?.standbySlot === previousSlot,
                  previousSlot.resourceName == previousResourceName else {
                return
            }

            previousSlot.reset()
        }
        previousSlot.playerLayer.opacity = 0
        nextSlot.playerLayer.opacity = 1
        CATransaction.commit()
    }
}

private final class PlayerSlot {
    let player = AVQueuePlayer()
    let playerLayer: AVPlayerLayer

    private(set) var resourceName: String?
    private var playerLooper: AVPlayerLooper?
    private var readyForDisplayObservation: NSKeyValueObservation?
    private var onReady: ((String) -> Void)?

    init() {
        playerLayer = AVPlayerLayer(player: player)
        player.isMuted = true
        player.actionAtItemEnd = .none
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.opacity = 0

        readyForDisplayObservation = playerLayer.observe(
            \.isReadyForDisplay,
            options: [.new]
        ) { [weak self] _, _ in
            DispatchQueue.main.async {
                self?.notifyIfReady()
            }
        }
    }

    func prepare(
        resourceName: String,
        url: URL,
        onReady: @escaping (String) -> Void
    ) {
        reset()
        self.resourceName = resourceName
        self.onReady = onReady

        let item = AVPlayerItem(url: url)
        playerLooper = AVPlayerLooper(player: player, templateItem: item)
        player.play()
        notifyIfReady()
    }

    func play() {
        guard resourceName != nil else { return }
        player.play()
    }

    func pause() {
        player.pause()
    }

    func reset() {
        onReady = nil
        resourceName = nil
        player.pause()
        player.removeAllItems()
        playerLooper = nil
        playerLayer.opacity = 0
    }

    private func notifyIfReady() {
        guard playerLayer.isReadyForDisplay,
              let resourceName,
              let onReady else {
            return
        }

        self.onReady = nil
        onReady(resourceName)
    }
}
