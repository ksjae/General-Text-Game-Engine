//
//  Parser.swift
//  Text Game
//
//  Created by 김승재 on 2021/02/03.
//

import Foundation
import SwiftUI

// File utils
class StreamReader  {
    
    let encoding : String.Encoding
    let chunkSize : Int
    var fileHandle : FileHandle!
    let delimData : Data
    var buffer : Data
    var atEof : Bool
    
    init?(path: URL, delimiter: String = "\n", encoding: String.Encoding = .utf8,
          chunkSize: Int = 4096) {
        
        guard let fileHandle = try? FileHandle(forReadingFrom: path), let delimData = delimiter.data(using: encoding) else {
            return nil
        }
        
        self.encoding = encoding
        self.chunkSize = chunkSize
        self.fileHandle = fileHandle
        self.delimData = delimData
        self.buffer = Data(capacity: chunkSize)
        self.atEof = false
    }
    
    deinit {
        self.close()
    }
    
    /// Return next line, or nil on EOF.
    func nextLine() -> String? {
        precondition(fileHandle != nil, "Attempt to read from closed file")
        
        // Read data chunks from file until a line delimiter is found:
        while !atEof {
            if let range = buffer.range(of: delimData) {
                // Convert complete line (excluding the delimiter) to a string:
                let line = String(data: buffer.subdata(in: 0..<range.lowerBound), encoding: encoding)
                // Remove line (and the delimiter) from the buffer:
                buffer.removeSubrange(0..<range.upperBound)
                return line
            }
            let tmpData = fileHandle.readData(ofLength: chunkSize)
            if tmpData.count > 0 {
                buffer.append(tmpData)
            } else {
                // EOF or read error.
                atEof = true
                if buffer.count > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = String(data: buffer as Data, encoding: encoding)
                    buffer.count = 0
                    return line
                }
            }
        }
        return nil
    }
    
    /// Start reading from the beginning of file.
    func rewind() -> Void {
        fileHandle.seek(toFileOffset: 0)
        buffer.count = 0
        atEof = false
    }
    
    /// Close the underlying file. No reading must be done after calling this method.
    func close() -> Void {
        fileHandle?.closeFile()
        fileHandle = nil
    }
}

extension StreamReader : Sequence {
    func makeIterator() -> AnyIterator<String> {
        return AnyIterator {
            return self.nextLine()
        }
    }
}
// Source: stackoverflow.com/a/24648951

// markup language parser
enum RichTextType {
    case normal, light, bold, italic, italicBold
}

struct RichTextPiece: Identifiable, Hashable {
    var text: String
    var type: RichTextType
    let id = UUID()
    init (text: String, type: RichTextType = .normal, id: Int = 0) {
        self.text = text
        self.type = type
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(type)
    }
}

struct Content: Hashable {
    
    static func == (lhs: Content, rhs: Content) -> Bool {
        return lhs.text == rhs.text && lhs.imageName == rhs.imageName && lhs.lineNo == rhs.lineNo
    }
    
    var text: [RichTextPiece]?
    var fontMultiplier: Double = 1
    var alignment: TextAlignment = TextAlignment.leading
    var imageName: String?
    var fightScene: Fight?
    var choiceScene: Choice?
    var isBlockquote: Bool?
    var isLine: Bool?
    var runGMWith: String?
    var lineNo: Int!
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(lineNo)
    }
}

//MARK: - Parser
class Parser {
    var rawFile: String!
    var aStreamReader: StreamReader!
    var defaultFontSize = 14
    let fontType = "KoPubWorldBatangPL"
    
    init(filename: String){
        self.loadFile(filename: filename)
    }
    
    func loadFile(filename: String) {
        guard let actualPath = Bundle.main.url(forResource: filename, withExtension: "md") else {
            fatalError("FILE \(filename) NOT FOUND!!")
        }
        self.aStreamReader = StreamReader(path: actualPath)
        if self.aStreamReader == nil {
            print("loadFile failed for \(filename)")
            self.aStreamReader = StreamReader(path: actualPath)
            if self.aStreamReader == nil {
                fatalError("loadFile failed for \(filename)")
                
            }
        }
    }
    
    func parseLine(lineNo: Int) -> Content? {
        
        guard var line = aStreamReader.nextLine() else {
            return nil
        }
        
        let prefix = line.prefix(1)
        var content = Content()
        content.lineNo = lineNo
        
        var text = ""
        
        switch prefix {
        case "#":
            let regex = try? NSRegularExpression(pattern: #"(#+)( *)(.*)"#)
            
            if let match = regex?.firstMatch(in: line, options: [], range: NSRange(location: 0, length: line.utf16.count)) {
                switch match.range(at: 1).upperBound {
                    case 1:
                        content.fontMultiplier = 3
                    case 2:
                        content.fontMultiplier = 2
                    case 3:
                        content.fontMultiplier = 1.5
                    default:
                        content.fontMultiplier = 1
                }
              if let titleRange = Range(match.range(at: 3), in: line) {
                text = String(line[titleRange])
              }
            }
            
        case "!":
            let regex = try? NSRegularExpression(pattern: #"!(.*?) (.*)"#)
            if let match = regex?.firstMatch(in: line, options: [], range: NSRange(location: 0, length: line.utf16.count)) {
                switch line[Range(match.range(at: 1), in: line)!].lowercased() {
                case "choice":
                    content.choiceScene = Choice()
                case "fight":
                    content.fightScene = Fight()
                default:
                    content.runGMWith = String(line[Range(match.range(at: 1), in: line)!])
                }
                content.runGMWith = String(line[Range(match.range(at: 1), in: line)!])
                text = String(line[line.index(line.startIndex, offsetBy: 1)...])
            }
            
        case ">":
            switch line.prefix(2) {
            case ">>":
                content.alignment = TextAlignment.trailing
            case "><":
                content.alignment = TextAlignment.center
            default:
                content.isBlockquote = true
                var nextline = ""
                repeat {
                    nextline = aStreamReader.nextLine() ?? ""
                    line += nextline
                } while nextline.prefix(1) == ">"
            }
        
        case "-":
            if line.prefix(2) == "--" {
                content.isLine = true
            }
            
        default:
            text = line
        }
        
        // MARK: Treat italics & bold
        let regexBold = try! NSRegularExpression(pattern: #"(\*\*)(.*?)\1"#)
        let regexItalics = try! NSRegularExpression(pattern: #"(\*)(.*?)\1"#)
        
        let bolds = returnRichTexts(normalText: text, regex: regexBold, richtextType: .bold)
        var richText: [RichTextPiece] = []
        
        for element in bolds {
            if element.type == .bold {
                richText += returnRichTexts(normalText: element.text, regex: regexItalics, richtextType: .italicBold, defaultTextType: .bold)
            } else {
                richText += returnRichTexts(normalText: element.text, regex: regexItalics, richtextType: .italic, defaultTextType: element.type)
            }
        }
        
        content.text = richText
        
        return content
    }
    
    func parseAll() -> [Content] {
        var contents: [Content] = []
        var lineNo = 0
        var line = self.parseLine(lineNo: lineNo)
        var defaultContent = Content()
        defaultContent.text = [RichTextPiece(text: "")]
        repeat {
            contents.append(line ?? defaultContent)
            lineNo += 1
            line = self.parseLine(lineNo: lineNo)
        } while line != nil
        return contents
    }
    
    func returnRichTexts(normalText text: String, regex: NSRegularExpression, richtextType type: RichTextType, defaultTextType def: RichTextType = .normal) -> [RichTextPiece] {
        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        let matches: [NSTextCheckingResult] = regex.matches(in: text, options: [], range: range)
        let matchingRanges = matches.compactMap { Range<Int>($0.range) }
        
        var parts = [0]
        var richtexts: [RichTextPiece] = []
        var lengthOfMarker: Int
        
        switch type {
        case .bold:
            lengthOfMarker = 2
        case .italic:
            lengthOfMarker = 1
        default:
            lengthOfMarker = 0
        }

        for r in matchingRanges {
            if r.lowerBound != 0 {
                parts.append(r.lowerBound-1)
            } else {
                parts.append(0)
            }
            parts.append(r.lowerBound + lengthOfMarker)
            parts.append(r.upperBound - lengthOfMarker)
            if r.upperBound != range.upperBound {
                parts.append(r.upperBound+1)
            } else {
                parts.append(range.upperBound)
            }
        }
        parts.append(text.count)

        var isPlainPart = true
        var i=0
        repeat {
            var richText: RichTextPiece
            var str: String
            if isPlainPart {
                str = String(text[parts[i]...parts[i+1]])
                richText = RichTextPiece(text: str, type: def, id: i)
            } else {
                str = String(text[parts[i]..<parts[i+1]])
                richText = RichTextPiece(text: str, type: type, id: i)
            }
            richtexts.append(richText)
            isPlainPart = !isPlainPart
            i+=2
        } while i < parts.count
        
        return richtexts
    }
}

func parsePlayer(player: Player, line: String) -> Player {
    return player
}

// Extending String to use Int indices
extension StringProtocol {
    subscript(_ offset: Int)                     -> Element     { self[index(startIndex, offsetBy: offset)] }
    subscript(_ range: Range<Int>)               -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: ClosedRange<Int>)         -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence { prefix(range.upperBound.advanced(by: 1)) }
    subscript(_ range: PartialRangeUpTo<Int>)    -> SubSequence { prefix(range.upperBound) }
    subscript(_ range: PartialRangeFrom<Int>)    -> SubSequence { suffix(Swift.max(0, count-range.lowerBound)) }
}
