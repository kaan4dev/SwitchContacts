import SwiftUI
import UniformTypeIdentifiers
import Contacts

struct ImportContact: Identifiable {
    let id = UUID()
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let email: String
    var isSelected: Bool = true
}

struct AdvancedImportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingFilePicker = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var importedContacts: [ImportContact] = []
    @State private var selectedFileType: UTType = .commaSeparatedText
    @State private var showingContactSelection = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Close Button
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.colors.MainTextColor)
                }
                .padding(.leading, 16)
                Spacer()
            }
            
            // Header
            VStack(spacing: 10) {
                Image(systemName: "folder.fill")
                    .font(.system(size: 30))
                    .foregroundColor(Color.colors.SecondaryTextColor)
                
                Text("Lütfen içe aktarmak istediğiniz\ndosya türünü seçiniz.")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.colors.MainTextColor, Color.colors.SecondaryTextColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
            }
            
            // Import Buttons
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    ImportButton(icon: "doc.text", title: ".csv") {
                        selectedFileType = .commaSeparatedText
                        showingFilePicker = true
                    }
                    
                    ImportButton(icon: "person.crop.circle", title: ".vcf") {
                        selectedFileType = .vCard
                        showingFilePicker = true
                    }
                }
                
                HStack(spacing: 20) {
                    ImportButton(icon: "tablecells", title: ".xlsx") {
                        selectedFileType = .excel
                        showingFilePicker = true
                    }
                }
            }
            
            // Contact List
            if !importedContacts.isEmpty {
                Button(action: { showingContactSelection = true }) {
                    Text("Seçili Kişileri Görüntüle ve Düzenle")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.colors.MainTextColor)
                        .cornerRadius(10)
                }
                .padding()
            }
            
            Spacer()
        }
        .padding()
        .background(Color.colors.MainBackgroundColor)
        .overlay { if isLoading { LoadingView() } }
        .alert("İçe Aktarma", isPresented: $showingAlert) {
            Button("Tamam", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .fileImporter(
            isPresented: $showingFilePicker,
            allowedContentTypes: [selectedFileType],
            allowsMultipleSelection: false
        ) { result in
            Task {
                do {
                    isLoading = true
                    guard let fileURL = try result.get().first else { return }
                    
                    guard fileURL.startAccessingSecurityScopedResource() else {
                        throw ImportError.accessDenied
                    }
                    
                    defer {
                        fileURL.stopAccessingSecurityScopedResource()
                    }
                    
                    let data = try Data(contentsOf: fileURL)
                    importedContacts = try await parseContacts(from: data)
                    
                } catch {
                    alertMessage = "Dosya okuma hatası: \(error.localizedDescription)"
                    showingAlert = true
                }
                isLoading = false
            }
        }
        .sheet(isPresented: $showingContactSelection) {
            ContactSelectionView(contacts: $importedContacts)
        }
    }
    
    private func parseContacts(from data: Data) async throws -> [ImportContact] {
        switch selectedFileType {
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
    
    private func importSelectedContacts() async {
        isLoading = true
        defer { isLoading = false }
        
        let store = CNContactStore()
        
        do {
            let granted = try await store.requestAccess(for: .contacts)
            guard granted else {
                throw ImportError.accessDenied
            }
            
            try await withThrowingTaskGroup(of: Void.self) { group in
                for contact in importedContacts where contact.isSelected {
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
            
            alertMessage = "Kişiler başarıyla içe aktarıldı!"
            showingAlert = true
            importedContacts.removeAll()
            
        } catch {
            alertMessage = "İçe aktarma hatası: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}

private struct ImportButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(Color.colors.SecondaryTextColor)
                Text(title)
                    .foregroundColor(Color.colors.MainTextColor)
            }
            .frame(width: 150, height: 100)
            .background(Color.colors.ButtonBackgroundColor.opacity(0.2))
            .cornerRadius(10)
        }
    }
}

private struct LoadingView: View {
    var body: some View {
        Color.black.opacity(0.3)
            .ignoresSafeArea()
        ProgressView()
            .scaleEffect(1.5)
            .progressViewStyle(CircularProgressViewStyle(tint: Color.colors.MainTextColor))
    }
}

private enum ImportError: LocalizedError {
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

#Preview {
    AdvancedImportView()
}