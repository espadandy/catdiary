// swiftlint:disable all
import Amplify
import Foundation

extension Note {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case description
    case image
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let note = Note.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Notes"
    model.syncPluralName = "Notes"
    
    model.attributes(
      .primaryKey(fields: [note.id])
    )
    
    model.fields(
      .field(note.id, is: .required, ofType: .string),
      .field(note.name, is: .optional, ofType: .string),
      .field(note.description, is: .optional, ofType: .string),
      .field(note.image, is: .optional, ofType: .string),
      .field(note.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(note.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
    public class Path: ModelPath<Note> { }
    
    public static var rootPath: PropertyContainerPath? { Path() }
}

extension Note: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}
extension ModelPath where ModelType == Note {
  public var id: FieldPath<String>   {
      string("id") 
    }
  public var name: FieldPath<String>   {
      string("name") 
    }
  public var description: FieldPath<String>   {
      string("description") 
    }
  public var image: FieldPath<String>   {
      string("image") 
    }
  public var createdAt: FieldPath<Temporal.DateTime>   {
      datetime("createdAt") 
    }
  public var updatedAt: FieldPath<Temporal.DateTime>   {
      datetime("updatedAt") 
    }
}