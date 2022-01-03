import Foundation
import Usecase
import Entity
import SQLite

public final class RecentImageUsecaseImp: RecentImageUsecase {
  
  private let db: Connection
  private let table: Table
  
  private let idColumn: Expression<Int>
  private let nameColumn: Expression<String>
  private let urlStringColumn: Expression<String>
  private let createdAt: Expression<Date>
  
  public init(db: Connection) throws {
    self.db = db
    self.table = Table("RecentImage")
    self.idColumn = Expression<Int>("id")
    self.nameColumn = Expression<String>("name")
    self.urlStringColumn = Expression<String>("urlString")
    self.createdAt = Expression<Date>("createdAt")
    try self.createTable()
  }
  
  private func createTable() throws {
    try self.db.run(self.table.create(ifNotExists: true) { builder in
      builder.column(self.idColumn, primaryKey: true)
      builder.column(self.nameColumn)
      builder.column(self.urlStringColumn, unique: true)
      builder.column(self.createdAt)
    })
  }
  
  public func query() throws -> [RecentImage] {
    let targetTable = self.table.order(self.createdAt.desc)
    return try self.db.prepare(targetTable).map { row in
      RecentImage(
        id: row[self.idColumn],
        name: row[self.nameColumn],
        urlString: row[self.urlStringColumn],
        createdAt: row[self.createdAt]
      )
    }
  }
  
  public func insert(name: String, url: URL?) throws {
    guard let urlString = url?.absoluteString else {
      throw RecentImageError.emptyURLString
    }
    try self.db.run(self.table.insert(
      self.nameColumn <- name,
      self.urlStringColumn <- urlString,
      self.createdAt <- Date()
    ))
  }
}

extension Connection {
  var userVersion: Int32 {
    get { return Int32(try! scalar("PRAGMA user_version") as! Int64)}
    set { try! run("PRAGMA user_version = \(newValue)") }
  }
}