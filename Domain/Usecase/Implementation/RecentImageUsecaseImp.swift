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
  
  public init(db: Connection) throws {
    self.db = db
    self.table = Table("RecentImage")
    self.idColumn = Expression<Int>("id")
    self.nameColumn = Expression<String>("name")
    self.urlStringColumn = Expression<String>("urlString")
    try self.createTable()
  }
  
  private func createTable() throws {
    try self.db.run(self.table.create(ifNotExists: true) { builder in
      builder.column(self.idColumn, primaryKey: true)
      builder.column(self.nameColumn)
      builder.column(self.urlStringColumn)
    })
  }
  
  public func query() throws -> [RecentImage] {
    return try self.db.prepare(self.table).map { row in
      RecentImage(
        id: row[self.idColumn],
        name: row[self.nameColumn],
        urlString: row[self.urlStringColumn]
      )
    }
  }
  
  public func insert(name: String, url: URL?) throws {
    guard let urlString = url?.absoluteString else {
      throw RecentImageError.emptyURLString
    }
    try self.db.run(self.table.insert(
      self.nameColumn <- name,
      self.urlStringColumn <- urlString
    ))
  }
}
