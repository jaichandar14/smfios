//
//  FileManager.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 9/30/22.
//

import Foundation

class AppFileManager {
    
    func createDownloadPath() -> String? {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentDirectoryURL.appendingPathComponent("Downloads", isDirectory: true)
        
        if FileManager.default.fileExists(atPath: directoryURL.path) {
            return directoryURL.path
        } else {
            do {
                try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                return directoryURL.path
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
    }
    
    func writeAFile(quote: ViewQuote?) -> (Bool, URL?) {
        let folderPath = createDownloadPath()
        
        if let path = folderPath, let viewQuote = quote {
            if let fileName = viewQuote.fileName, let content = viewQuote.fileContent {
                if let data = Data(base64Encoded: content, options: .ignoreUnknownCharacters) {
                    let url = URL(fileURLWithPath: path + "/" + fileName)
                    do {
                        try data.write(to: url)
                        print("File Written to path: \(path + "/" + fileName)")
                        return (true, url)
                    } catch {
                        print("Data write error")
                    }
                }
            }
        }
        return (false, nil)
    }
    
    func getMetaData(for url: URL) -> [String: Any] {
        var attributes: [String: Any] = [:]
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: url.path)
            attributes["fileSize"] = fileAttributes[.size]

            let copyOfURL = url
            let urlWithoutFileExtension: URL =  copyOfURL.deletingPathExtension()
            let fileNameWithoutExtension: String = urlWithoutFileExtension.lastPathComponent
            
            attributes["fileName"] = fileNameWithoutExtension
            attributes["fileType"] = "QUOTE_DETAILS"
            
            let fileData = try Data.init(contentsOf: url)
            let base64String = fileData.base64EncodedString()
            
            attributes["fileContent"] = base64String
        } catch {
            print("Failed to fetch attributes of the attribute")
        }
        return attributes
    }
}

