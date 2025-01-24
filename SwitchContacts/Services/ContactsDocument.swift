import Foundation
import SwiftUI
import UniformTypeIdentifiers
import Contacts

struct ContactsDocument: FileDocument
{
    var contactData: Data
    var fileType: UTType
    
    static var readableContentTypes: [UTType] { [.commaSeparatedText, .vCard] }
    
    init(contactData: Data, fileType: UTType)
    {
        self.contactData = contactData
        self.fileType = fileType
    }
    
    init(configuration: ReadConfiguration) throws
    {
        self.contactData = Data()
        self.fileType = .commaSeparatedText
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper
    {
        return FileWrapper(regularFileWithContents: contactData)
    }
}
