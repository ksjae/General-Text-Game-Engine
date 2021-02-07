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
    
    init?(path: String, delimiter: String = "\n", encoding: String.Encoding = .utf8,
          chunkSize: Int = 4096) {
        
        guard let fileHandle = FileHandle(forReadingAtPath: path),
            let delimData = delimiter.data(using: encoding) else {
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
class Parser {
    var rawFile: String!
    var aStreamReader: StreamReader!
    var defaultFontSize = 14
    let fontType = "KoPubWorldBatangPL"
    
    func loadFile(filename: String) {
        self.aStreamReader = StreamReader(path: filename)
        if self.aStreamReader == nil {
            print("loadFile failed: File \(filename) not found")
        }
    }
    
    func parseLine() -> Dictionary<String, Any> {
        guard let line = aStreamReader.nextLine() else {
            return ["text": "", "font": Font.custom("KoPubWorldBatangPL", size: CGFloat(self.defaultFontSize))]
        }
        let command = line.prefix(1)
        var dict: Dictionary<String, Any> = [:]
        
        var fontSize: Int = self.defaultFontSize
        var text = ""
        
        switch command {
        case "#":
            let regex = try? NSRegularExpression(pattern: #"(#+)( *)(.*)"#)
            
            if let match = regex?.firstMatch(in: line, options: [], range: NSRange(location: 0, length: line.utf16.count)) {
                switch match.range(at: 1).upperBound {
                    case 1:
                        fontSize = 33
                    case 2:
                        fontSize = 24
                    case 3:
                        fontSize = 18
                    default:
                        fontSize = self.defaultFontSize
                }
              if let titleRange = Range(match.range(at: 3), in: line) {
                text = String(line[titleRange])
              }
            }
            
        case "!":
            let regex = try? NSRegularExpression(pattern: #"!(.*?) (.*)"#)
            if let match = regex?.firstMatch(in: line, options: [], range: NSRange(location: 0, length: line.utf16.count)) {
                dict["command"] = String(line[Range(match.range(at: 1), in: line)!])
                text = String(line[line.index(line.startIndex, offsetBy: 1)...])
            }
            
        case ">":
            switch line.prefix(2) {
            case ">>":
                dict["alignRight"] = true
            case "><":
                dict["alignCenter"] = true
            default:
                dict["blockquote"] = true
            }
        
        case "-":
            if line.prefix(2) == "--" {
                dict["notText"] = true
                dict["line"] = true
            }
            
        default:
            text = line
        }
        dict["text"] = text
        dict["font"] = Font.custom(fontType, size: CGFloat(fontSize))
        
        return dict
    }
}
