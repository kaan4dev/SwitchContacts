import Foundation
@preconcurrency import Contacts
import UniformTypeIdentifiers
import PDFKit

enum ContactError: LocalizedError
{
    case accessDenied
    
    var errorDescription: String?
    {
        switch self
        {
        case .accessDenied:
            return "Lütfen ayarlardan kişilere erişime izin verin!"
        }
    }
}

func fetchContacts() async throws -> [CNContact]
{
    let store = CNContactStore()
    let granted = try await store.requestAccess(for: .contacts)
    
    guard granted else {
        throw ContactError.accessDenied
    }
    
    let keys = [
        CNContactGivenNameKey as CNKeyDescriptor,
        CNContactFamilyNameKey as CNKeyDescriptor,
        CNContactPhoneNumbersKey as CNKeyDescriptor,
        CNContactEmailAddressesKey as CNKeyDescriptor
    ]
    
    let request = CNContactFetchRequest(keysToFetch: keys)
    
    return try await withCheckedThrowingContinuation
    {
        continuation in
        DispatchQueue.global(qos: .userInitiated).async
        {
            do
            {
                var tempContacts: [CNContact] = []
                try store.enumerateContacts(with: request)
                {
                    contact, _ in
                    tempContacts.append(contact)
                }
                continuation.resume(returning: tempContacts)
            }
            catch
            {
                continuation.resume(throwing: error)
            }
        }
    }
}

func exportToCSV(contacts: [CNContact]) -> Data?
{
    let csvString = contacts.map
    {
        contact in
        [
            contact.givenName,
            contact.familyName,
            contact.phoneNumbers.first?.value.stringValue ?? "",
            contact.emailAddresses.first?.value as String? ?? ""
        ].joined(separator: ",")
    }.joined(separator: "\n")
    
    let finalString = "Ad,Soyad,Telefon,Email\n" + csvString
    return finalString.data(using: .utf8)
}

func exportToVCF(contacts: [CNContact]) -> Data?
{
    let vcfString = contacts.map { contact -> String in
        """
        BEGIN:VCARD
        VERSION:3.0
        N:\(contact.familyName);\(contact.givenName);;;
        FN:\(contact.givenName) \(contact.familyName)
        TEL;TYPE=CELL:\(contact.phoneNumbers.first?.value.stringValue ?? "")
        EMAIL;TYPE=HOME:\(contact.emailAddresses.first?.value as String? ?? "")
        END:VCARD
        """
    }.joined(separator: "\n")
    
    return vcfString.data(using: .utf8)
}

func exportToPDF(contacts: [CNContact]) -> Data?
{
    let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
    let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
    
    return renderer.pdfData
    {
        context in
        context.beginPage()
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
        var yPosition: CGFloat = 50
        
        ["Ad", "Soyad", "Telefon", "Email"].enumerated().forEach
        {
            index, title in
            (title as NSString).draw(
                at: CGPoint(x: CGFloat(index) * 140 + 40, y: yPosition),
                withAttributes: attributes
            )
        }
        
        yPosition += 20
        
        for contact in contacts
        {
            [
                contact.givenName,
                contact.familyName,
                contact.phoneNumbers.first?.value.stringValue ?? "",
                contact.emailAddresses.first?.value as String? ?? ""
            ].enumerated().forEach { index, value in
                (value as NSString).draw(
                    at: CGPoint(x: CGFloat(index) * 140 + 40, y: yPosition),
                    withAttributes: attributes
                )
            }
            
            yPosition += 20
            if yPosition > pageRect.height - 50
            {
                context.beginPage()
                yPosition = 50
            }
        }
    }
}

func exportToExcel(contacts: [CNContact]) -> Data?
{
    let excelString = contacts.map { contact in
        [
            contact.givenName,
            contact.familyName,
            contact.phoneNumbers.first?.value.stringValue ?? "",
            contact.emailAddresses.first?.value as String? ?? ""
        ].joined(separator: "\t")
    }.joined(separator: "\n")
    
    let finalString = "Ad\tSoyad\tTelefon\tEmail\n" + excelString
    return finalString.data(using: .utf8)
}

func handleExportResult(_ result: Result<URL, Error>, alertMessage: inout String, showingAlert: inout Bool) {
    switch result {
    case .success:
        alertMessage = "Kişiler başarıyla dışa aktarıldı!"
    case .failure(let error):
        alertMessage = "Dışa aktarma başarısız: \(error.localizedDescription)"
    }
    showingAlert = true
}
