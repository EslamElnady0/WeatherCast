//  LoopingVideoView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 06/06/2026.
//

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
    private let playerController = LoopingVideoPlayerController()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isOpaque = false
        playerController.attach(to: layer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerController.layout(in: bounds)
    }

    func configure(resourceName: String) {
        playerController.configure(resourceName: resourceName)
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        playerController.setPlaybackActive(window != nil)
    }
}
