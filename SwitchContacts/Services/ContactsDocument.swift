import SwiftUI
import UniformTypeIdentifiers

struct ContactsDocument: FileDocument
{
    let contactData: Data
    let fileType: UTType
    
    static var readableContentTypes: [UTType] { [.commaSeparatedText, .vCard, .pdf, .excel] }
    static var writableContentTypes: [UTType] { [.commaSeparatedText, .vCard, .pdf, .excel] }
    
    init(contactData: Data, fileType: UTType)
    {
        self.contactData = contactData
        self.fileType = fileType
    }
    
    init(configuration: ReadConfiguration) throws
    {
        self.contactData = configuration.file.regularFileContents ?? Data()
        self.fileType = .commaSeparatedText
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: contactData)
    }
}
