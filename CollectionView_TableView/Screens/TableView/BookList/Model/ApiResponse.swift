//
//  ApiResponse.swift
//  Design Pattern
//
//  Created by Ngay Vong on 9/18/20.
//

import Foundation

// Adopt Decodable protocol so we can convert dictionary data to class or struct data
struct ApiResponse: Decodable{
    var bookKind: String?
    var totalItems: Int?
    var items: [ItemInfo]?
    
    enum CodingKeys: String, CodingKey {
        case bookKind = "kind"
        case totalItems
        case items
    }
}

struct ItemInfo: Decodable {
    var itemKind: String?
    var itemId: String?
    var eTag: String?
    var selfLink: String?
    var volumeInfo: VolumeInfo?
    //var saleInfo: ?
    var accessInfo: AccessInfo?
    //var searchInfo: ?
    
    enum CodingKeys: String, CodingKey {
        case itemKind = "kind"
        case itemId = "id"
        case eTag = "etag"
        case selfLink
        case volumeInfo
        //var saleInfo: ?
        case accessInfo
    }
}

struct VolumeInfo: Decodable {
    var title: String?
    var subTitle: String?
    var authors: [String]?
    var publisher: String?
    var publisherDate: String?
    var description: String?
    //var industryIdentifiers: []?
    //var readingModes:?

    var pageCount: Int?
    var printType: String?
    //var categories: []?
    var averageRating: Double?
    var ratingsCount: Int?
    var maturityRating: String?
    var contentVersion: String?
    //var panelizationSummary:?

    var imageLinks: ImageLinks?
    var language: String?
    var previewLink: String?
    var infoLink: String?
    var canonicalVolumeLink: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case subTitle = "subtitle"
        case authors
        case publisher
        case publisherDate
        case description

        case pageCount
        case printType
        case averageRating
        case ratingsCount
        case maturityRating
        case contentVersion

        case imageLinks
        case language
        case previewLink
        case infoLink
        case canonicalVolumeLink
    }
}

struct ImageLinks: Decodable {
    var smallThumbnail: String?
    var thumbNail: String?
}

struct AccessInfo: Decodable {
    var pdfInfo: PdfInfo?
    var webReaderLink: String
    
    enum CodingKeys: String, CodingKey {
        case pdfInfo = "pdf"
        case webReaderLink
    }
}

struct PdfInfo: Decodable {
    var acsTokenLink: String?
}
