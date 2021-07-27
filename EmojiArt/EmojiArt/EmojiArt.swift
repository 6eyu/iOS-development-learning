//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by vliu on 10/7/21.
//

import Foundation

struct EmojiArt: Codable {
    var background: Background = .blank
    var emojis = [Emoji]()
    private var uniqueEmojiId = 0
    
    struct Emoji: Identifiable, Hashable, Codable {
        let id: Int
        let text: String
        var x: Int
        var y: Int
        var size: Int
        
        fileprivate init(id: Int, text: String, x: Int, y: Int, size: Int) {
            self.text = text
            self.x = x // offset from the center
            self.y = y // offset from the center
            self.size = size
            self.id = id
        }
    }
    
    init() {}
    
    init(json: Data) throws {
        self = try JSONDecoder().decode(EmojiArt.self, from: json)
    }
    
    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        self = try EmojiArt(json: data)
    }
    
    
    func json() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    mutating func addEmoji(_ text: String, at location: (x: Int, y: Int), size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(id: uniqueEmojiId, text: text, x: location.x, y: location.y, size: size))
    }
}
