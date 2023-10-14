//
//  RenderingSource.swift
//  AlleTest
//
//  Created by Swaroop Kurra on 14/10/23.
//

import Foundation
import ImageIO

public protocol ImageRenderingSource {
    var cgSource: CGImageSource {get}
}

extension ImageRenderingSource {
    static func url(_ url: NSURL) throws -> ImageRenderingSource {
        guard let source = CGImageSourceCreateWithURL(url, nil) else { throw RenderingError.unableToCreateImageSource }
        return source
    }
}

extension CGImageSource : ImageRenderingSource {
    public var cgSource: CGImageSource {
        return self
    }
}

public class RenderingSource : ImageRenderingSource {
    public var cgSource: CGImageSource
    public init(cgSource: CGImageSource) {
        self.cgSource = cgSource
    }
}
