import UIKit
import Usecase
import Entity
import SQLite

public final class BookmarkImageUsecaseImp: BookmarkImageUsecase {
  
  private let db: Connection
  private let table: Table
  
  private let idColumn: Expression<Int>
  private let nameColumn: Expression<String>
  private let urlStringColumn: Expression<String>
  private let imageColumn: Expression<UIImage>
  private let createdAt: Expression<Date>
  
  public init(db: Connection) throws {
    self.db = db
    self.table = Table("BookmarkImage")
    self.idColumn = Expression<Int>("id")
    self.nameColumn = Expression<String>("name")
    self.urlStringColumn = Expression<String>("urlString")
    self.imageColumn = Expression<UIImage>("image")
    self.createdAt = Expression<Date>("createdAt")
    try self.createTable()
  }
  
  private func createTable() throws {
    try self.db.run(self.table.create(ifNotExists: true) { builder in
      builder.column(self.idColumn, primaryKey: true)
      builder.column(self.nameColumn)
      builder.column(self.urlStringColumn, unique: true)
      builder.column(self.imageColumn)
      builder.column(self.createdAt)
    })
  }
  
  public func query() throws -> [BookmarkImage] {
    return try self.db.prepare(self.table).map { row in
      BookmarkImage(
        id: row[self.idColumn],
        name: row[self.nameColumn],
        urlString: row[self.urlStringColumn],
        image: row[self.imageColumn],
        createdAt: row[self.createdAt]
      )
    }
  }
  
  public func insert(name: String, url: URL?, image: UIImage) throws {
    guard let urlString = url?.absoluteString else {
      throw BookmarkImageError.emptyURLString
    }
    try self.db.run(self.table.insert(
      self.nameColumn <- name,
      self.urlStringColumn <- urlString,
      self.imageColumn <- image,
      self.createdAt <- Date()
    ))
  }
  
  public func delete(id: Int) throws {
    let targetTable = self.table.filter(self.idColumn == id)
    try self.db.run(targetTable.delete())
  }
}

extension UIImage: Value {
  
  public static var declaredDatatype: String {
    return Blob.declaredDatatype
  }
  
  public static func fromDatatypeValue(_ datatypeValue: Blob) -> UIImage {
    return UIImage(data: Data.fromDatatypeValue(datatypeValue))!
  }
  
  public var datatypeValue: Blob {
    return self.pngData()!.datatypeValue
  }
}
