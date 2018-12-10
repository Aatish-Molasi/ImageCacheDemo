//
//  DataLoader.swift
//  ImageCacheManager
//
//  Created by Aatish Molasi on 12/10/18.
//  Copyright © 2018 Aatish Molasi. All rights reserved.
//

import Foundation

internal class DataLoader {
    func getData(url: URL) throws -> Data {
        return try Data(contentsOf: url)
    }
}
