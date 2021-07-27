//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by vliu on 10/7/21.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    @Published private(set) var emojiArt: EmojiArt {
        didSet {
            if emojiArt.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
            }
        }
    }
    @Published var backgroundImage: UIImage?
    
    @Published var backgroundImageFetchStatus: BackgroundImageFetchStatus = .idle
    
    private var autosaveTimer: Timer?
    
    enum BackgroundImageFetchStatus {
        case idle
        case fetching
    }
    
    init() {
        
        if let url = Autosave.url, let autosavedEmojiArt = try? EmojiArt(url: url) {
            emojiArt = autosavedEmojiArt
            fetchBackgroundImageDataIfNecessary()
        } else {
            emojiArt = EmojiArt()
            emojiArt.addEmoji("🧘🏻‍♂️", at: (-200, -100), size: 80)
            emojiArt.addEmoji("🦁", at: (50, 100), size: 40)
        }
    }

    
    var emojis: [EmojiArt.Emoji] {
        emojiArt.emojis
    }
    
    var background: EmojiArt.Background {
        emojiArt.background
    }
    
    private struct Autosave {
        static let filename = "Autosaved.emojiart"
        static var url: URL? {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            return  documentDirectory?.appendingPathComponent(filename)
        }
        static let coalescingInterval = 5.0
    }
    
    private func autosave() {
        if let url = Autosave.url {
            save(to: url)
        }
    }
    
    private func scheduleAutosave() {
        autosaveTimer?.invalidate()
        autosaveTimer = Timer.scheduledTimer(withTimeInterval: Autosave.coalescingInterval, repeats: false) { _ in
            self.autosave()
        }
    }
    
    
    private func save(to url: URL) {
        let thisFunction = "\(String(describing: self)).\(#function)"
        do {
            let data: Data = try emojiArt.json()
            try data.write(to: url)
        } catch let error {
            print("\(thisFunction) error = \(error)")
        }
 
    }
    
    private func fetchBackgroundImageDataIfNecessary() {
        backgroundImage = nil
        switch emojiArt.background {
            case .url(let url):
                backgroundImageFetchStatus = .fetching
                DispatchQueue.global(qos: .userInitiated).async {
                    let imageData = try? Data(contentsOf: url)
                    DispatchQueue.main.async { [weak self] in
                        if self?.emojiArt.background == .url(url) {
                            self?.backgroundImageFetchStatus = .idle
                            if imageData != nil {
                                self?.backgroundImage = UIImage(data: imageData!)
                            }
                        }
                    }
                }
            case .imageData(let data):
                backgroundImage = UIImage(data: data)
            case .blank:
                break
        }
    }
    
    // MARK: - Intent(s)
    func setBackground(_ background: EmojiArt.Background) {
        emojiArt.background = background
    }
    
    func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat) {
        emojiArt.addEmoji(emoji, at: location, size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
        }
    }
}
