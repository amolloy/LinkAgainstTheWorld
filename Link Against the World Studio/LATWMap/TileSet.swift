//
//  TileSet.swift
//  LATWMap
//
//  Created by Andrew Molloy on 1/2/16.
//  Copyright © 2016 Andy Molloy. All rights reserved.
//

import Foundation
import CrossPlatform

public final class TileSet
{
	public var image : Image?
	public let imageName : String
	public let name : String
	public let tileCount : Int
	public let tileWidth : Int
	public let tileHeight : Int

	public func coordinatesForTileAtIndex(index: Int) -> CGRect
	{
		guard let image = image else
		{
			return CGRectZero
		}
		let tilesWide = Int(image.size.width) / tileWidth
		let row = index / tilesWide
		let col = index % tilesWide

		return CGRect(x: col * tileWidth, y: row * tileHeight, width: tileWidth, height: tileHeight)
	}

	public init(image: Image?, imageName: String, name: String, tileCount: Int, tileWidth: Int, tileHeight: Int)
	{
		self.image = image
		self.imageName = imageName
		self.name = name
		self.tileCount = tileCount
		self.tileWidth = tileWidth
		self.tileHeight = tileHeight
	}
}
