//
//  dataBaseManager.swift
//  appSqliteDataBase
//
//  Created by braulio on 08/06/24.
//  Copyright © 2024 braulio. All rights reserved.

import UIKit
import SQLite3

class DatabaseManager {
    var db: OpaquePointer?

    init() {
        openDatabase()
        createTable()
    }

    func openDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("test.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        } else {
            print("Successfully opened connection to database at \(fileURL.path)")
        }
    }
    
    
    func update(id: Int, name: String, description: String, stock: Int, price: Int) {
        let updateStatementString = "UPDATE Products SET Name = ?, Description = ?, Stock = ?, Price = ? WHERE Id = ?;"
        var updateStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (description as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 3, Int32(stock))
            sqlite3_bind_int(updateStatement, 4, Int32(price))
            sqlite3_bind_int(updateStatement, 5, Int32(id))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared.")
        }
        
        sqlite3_finalize(updateStatement)
    }


    func createTable() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS Products(
        Id INTEGER PRIMARY KEY,
        Name TEXT,
        Description TEXT,
        Stock INT,
        Price INT);
        """
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Products table created.")
            } else {
                print("Products table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func delete(id: Int) {
        let deleteStatementString = "DELETE FROM Products WHERE Id = ?;"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Row deleted successfully.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared.")
        }
        
        sqlite3_finalize(deleteStatement)
    }

    func insert(id: Int, name: String, description: String, stock: Int, price: Int) {
        let insertStatementString = "INSERT INTO Products (Id,Name, Description, Stock, Price) VALUES (?,?, ?, ?, ?);"
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (description as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 4, Int32(stock))
            sqlite3_bind_int(insertStatement, 5, Int32(price))

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }

    func query() -> String {
        let queryStatementString = "SELECT * FROM Products;"
        var queryStatement: OpaquePointer?
        var producto = ""
        var listaProductos = ""
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(cString: sqlite3_column_text(queryStatement, 1))
                let description = String(cString: sqlite3_column_text(queryStatement, 2))
                let stock = sqlite3_column_int(queryStatement, 3)
                let price = sqlite3_column_int(queryStatement, 4)
                
                producto = "\nId: \(id), Name: \(name), Description: \(description), Stock: \(stock), Price: \(price)\n"
                listaProductos += producto
            }
        } else {
            producto = "Failed to execute query."
        }
        
        sqlite3_finalize(queryStatement)
        return listaProductos
    }

    func closeDatabase() {
        if sqlite3_close(db) != SQLITE_OK {
            print("Error closing database")
        } else {
            print("Database closed successfully")
        }
        db = nil
    }
}

