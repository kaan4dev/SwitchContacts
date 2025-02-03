import Foundation
@preconcurrency import Contacts
import UniformTypeIdentifiers

enum ImportError: LocalizedError {
    case accessDenied
    case unsupportedFormat
    case fileNotFound
    
    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return "Lütfen ayarlardan kişilere erişime izin verin"
        case .unsupportedFormat:
            return "Desteklenmeyen dosya formatı"
        case .fileNotFound:
            return "Dosya bulunamadı"
        }
    }
}

struct ImportContact: Identifiable {
    let id = UUID()
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let email: String
    var isSelected: Bool = true
}

func parseContacts(from data: Data, fileType: UTType) async throws -> [ImportContact] {
    switch fileType {
    case .commaSeparatedText:
        return try parseCSV(data)
    case .vCard:
        return try parseVCard(data)
    case .excel:
        return try parseExcel(data)
    default:
        throw ImportError.unsupportedFormat
    }
}

private func parseCSV(_ data: Data) throws -> [ImportContact] {
    guard let content = String(data: data, encoding: .utf8) else {
        throw ImportError.unsupportedFormat
    }
    
    var contacts: [ImportContact] = []
    let rows = content.components(separatedBy: .newlines)
    let startIndex = rows[0].lowercased().contains("ad") ? 1 : 0
    
    for row in rows[startIndex...] where !row.isEmpty {
        let fields = row.components(separatedBy: ",")
        guard fields.count >= 2 else { continue }
        
        contacts.append(ImportContact(
            firstName: fields[0].trimmingCharacters(in: .whitespaces),
            lastName: fields[1].trimmingCharacters(in: .whitespaces),
            phoneNumber: fields.count > 2 ? fields[2].trimmingCharacters(in: .whitespaces) : "",
            email: fields.count > 3 ? fields[3].trimmingCharacters(in: .whitespaces) : ""
        ))
    }
    
    return contacts
}

private func parseVCard(_ data: Data) throws -> [ImportContact] {
    guard let content = String(data: data, encoding: .utf8) else {
        throw ImportError.unsupportedFormat
    }
    
    var contacts: [ImportContact] = []
    let cards = content.components(separatedBy: "BEGIN:VCARD")
    
    for card in cards where !card.isEmpty {
        var firstName = "", lastName = "", phone = "", email = ""
        
        if let nameRange = card.range(of: "N:") {
            let nameStart = card.index(nameRange.upperBound, offsetBy: 0)
            let nameEnd = card[nameStart...].firstIndex(of: "\n") ?? card.endIndex
            let nameParts = card[nameStart..<nameEnd].components(separatedBy: ";")
            if nameParts.count >= 2 {
                lastName = nameParts[0].trimmingCharacters(in: .whitespaces)
                firstName = nameParts[1].trimmingCharacters(in: .whitespaces)
            }
        }
        
        if let phoneRange = card.range(of: "TEL;") {
            let phoneStart = card.index(phoneRange.upperBound, offsetBy: 0)
            let phoneEnd = card[phoneStart...].firstIndex(of: "\n") ?? card.endIndex
            let phoneStr = card[phoneStart..<phoneEnd]
            if let colonIndex = phoneStr.firstIndex(of: ":") {
                phone = String(phoneStr[phoneStr.index(after: colonIndex)...])
                    .trimmingCharacters(in: .whitespaces)
            }
        }
        
        if let emailRange = card.range(of: "EMAIL;") {
            let emailStart = card.index(emailRange.upperBound, offsetBy: 0)
            let emailEnd = card[emailStart...].firstIndex(of: "\n") ?? card.endIndex
            let emailStr = card[emailStart..<emailEnd]
            if let colonIndex = emailStr.firstIndex(of: ":") {
                email = String(emailStr[emailStr.index(after: colonIndex)...])
                    .trimmingCharacters(in: .whitespaces)
            }
        }
        
        if !firstName.isEmpty || !lastName.isEmpty {
            contacts.append(ImportContact(
                firstName: firstName,
                lastName: lastName,
                phoneNumber: phone,
                email: email
            ))
        }
    }
    
    return contacts
}

private func parseExcel(_ data: Data) throws -> [ImportContact] {
    guard let content = String(data: data, encoding: .utf8) else {
        throw ImportError.unsupportedFormat
    }
    
    var contacts: [ImportContact] = []
    let rows = content.components(separatedBy: .newlines)
    let startIndex = rows[0].lowercased().contains("ad") ? 1 : 0
    
    for row in rows[startIndex...] where !row.isEmpty {
        let fields = row.components(separatedBy: "\t")
        guard fields.count >= 2 else { continue }
        
        contacts.append(ImportContact(
            firstName: fields[0].trimmingCharacters(in: .whitespaces),
            lastName: fields[1].trimmingCharacters(in: .whitespaces),
            phoneNumber: fields.count > 2 ? fields[2].trimmingCharacters(in: .whitespaces) : "",
            email: fields.count > 3 ? fields[3].trimmingCharacters(in: .whitespaces) : ""
        ))
    }
    
    return contacts
}

func importSelectedContacts(_ contacts: [ImportContact]) async throws {
    let store = CNContactStore()
    
    let granted = try await store.requestAccess(for: .contacts)
    guard granted else {
        throw ImportError.accessDenied
    }
    
    try await withThrowingTaskGroup(of: Void.self) { group in
        for contact in contacts where contact.isSelected {
            group.addTask {
                let newContact = CNMutableContact()
                newContact.givenName = contact.firstName
                newContact.familyName = contact.lastName
                
                if !contact.phoneNumber.isEmpty {
                    newContact.phoneNumbers = [
                        CNLabeledValue(
                            label: CNLabelPhoneNumberMobile,
                            value: CNPhoneNumber(stringValue: contact.phoneNumber)
                        )
                    ]
                }
                
                if !contact.email.isEmpty {
                    newContact.emailAddresses = [
                        CNLabeledValue(label: CNLabelHome, value: contact.email as NSString)
                    ]
                }
                
                let saveRequest = CNSaveRequest()
                saveRequest.add(newContact, toContainerWithIdentifier: nil)
                try store.execute(saveRequest)
            }
        }
    }
}