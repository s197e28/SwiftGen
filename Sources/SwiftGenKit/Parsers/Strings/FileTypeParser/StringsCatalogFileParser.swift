//
// SwiftGenKit
// Copyright © 2022 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

extension Strings {
  final class StringsCatalogFileParser: StringsFileTypeParser {
    private let options: ParserOptionValues
    
    init(options: ParserOptionValues) {
      self.options = options
    }
    
    static let extensions = ["xcstrings"]
    
    func parseFile(at path: Path) throws -> [Strings.Entry] {
      let file = try File(path: path)
      let entries = try parseFile(file)
      return entries
    }
    
    public func parseFile(_ file: File) throws -> [Strings.Entry] {
      let sourceLanguage = file.document.sourceLanguage
      
      do {
        return try file.document.strings.compactMap { key, entry -> Strings.Entry? in
          var entry = Strings.Entry(
            key: key,
            translation: translation(from: entry.localizations, sourceLanguage: sourceLanguage) ?? key,
            types: try Strings.PlaceholderType.placeholderTypes(
              fromFormat: key
            ),
            keyStructureSeparator: options[Option.separator]
          )
          entry.comment = entry.comment
          return entry
        }
      } catch {
        throw error
      }
    }
    
    private func translation(from localizations: [String: Strings.Localization]?, sourceLanguage: String) -> String? {
      guard let localization = localizations?[sourceLanguage] else {
        return nil
      }
      return localization.stringUnit?.value
    }
  }
}
