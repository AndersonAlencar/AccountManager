//
//  FirebaseProtocol.swift
//  FinancialManager
//
//  Created by Anderson Alencar on 10/01/21.
//

import Foundation

protocol FirebaseProtocol {
    func addNewDocument(dataDocument: [String:Any])
    func updateDocument(dataDocument: [String:Any], documentID: String)
    func deleteDocument(documentID: String) 
}
