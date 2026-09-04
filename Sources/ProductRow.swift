//
//  ProductRow.swift
//  tdscli2
//
//  A row from the demo `Product` table (see schema.sql).
//

struct ProductRow: Decodable, Equatable {
    let ProductID: Int
    let ProductName: String
    let Quantity: Int
}
