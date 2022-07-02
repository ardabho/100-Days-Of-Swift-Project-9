//
//  Petitions.swift
//  100 Days Of Swift-Project 7
//
//  Created by Arda Büyükhatipoğlu on 24.06.2022.
//

import Foundation

struct Petitions: Codable {
    var results: [Petition]
}

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
