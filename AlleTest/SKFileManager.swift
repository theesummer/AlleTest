//
//  SKFileManager.swift
//  AlleTest
//
//  Created by Swaroop Kurra on 12/10/23.
//

import Foundation
enum SKLocalFileType: String {
    case jpeg = ".jpeg", ska = ".ska", txt = ".txt", heic = ".HEIC"
}
enum SKFileDirectory: String {
    case images = "images"
}
class SKFileManager {
    static let shared = SKFileManager()
    private let fileManager = FileManager.default
    func get(directory: SKFileDirectory) -> URL {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsDirectoryUrl = URL(string: documentsDirectory)!
        let SKDirectoryUrl = documentsDirectoryUrl.appendingPathComponent(directory.rawValue)
        if !self.fileManager.fileExists(atPath: SKDirectoryUrl.absoluteString) {
            do {
                try self.fileManager.createDirectory(atPath: SKDirectoryUrl.absoluteString, withIntermediateDirectories: true, attributes: nil)
                print("SKFileManager: Created \(directory.rawValue) directory at", SKDirectoryUrl.absoluteString)
            } catch {
                print(error.localizedDescription);
            }
        }
        
        let SKDirectoryPath = SKDirectoryUrl.absoluteString
        return SKDirectoryUrl
    }
    func write(image: Data, name: String, fileType: SKLocalFileType, directory: SKFileDirectory)  {
        let dir = self.get(directory: directory)
        let filePath = (dir.path as NSString).appendingPathComponent(name + fileType.rawValue)
        let fileURL =  URL(fileURLWithPath: filePath)
        do {
            try image.write(to: fileURL)
            print("SKFileManager: Wrote file at", fileURL)
        } catch {
            print(error.localizedDescription)
            print("SKFileManager: File not written")
        }
    }
    func getFilesFrom(directory: SKFileDirectory) -> [URL]? {
        let directoryUrl = self.get(directory: directory)
        do {
            let fileURLs = try self.fileManager.contentsOfDirectory(at: directoryUrl,
                                                                    includingPropertiesForKeys: nil,
                                                                    options: .skipsHiddenFiles)
            print("SKFileManager: found files at \(fileURLs)")
            return fileURLs
        } catch  { print("SKFileManager: find files error", error.localizedDescription) }
        return nil
    }
    
    func getSizeOfFileAt(url: URL) -> String {
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: url.path)
            if let size = attr[.size] as? Int {
                let fileSize = (Double(size) / 1024)/1024
                print(size, fileSize, String(format: "Size: %.2f MB", fileSize))
                return String(format: "%.2f MB", fileSize)
            }
        } catch {
            print("SKFileManager: attr ", error.localizedDescription)
        }
        return ""
    }
    func removeFileAt(url: URL) {
        do {
            print("SKFileManager: ", url)
            try self.fileManager.removeItem(at: url)
            print("SKFileManager: removed file \(url.lastPathComponent)")
        } catch { print(error.localizedDescription) }
    }
}
