@preconcurrency import Contacts
import SwiftUI
import UniformTypeIdentifiers
import PDFKit

struct AdvancedExportView: View
{
    @Environment(\.dismiss) private var dismiss
    @State private var contacts: [CNContact] = []
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isExporting = false
    @State private var exportData: Data?
    @State private var exportFileType: UTType = .commaSeparatedText
    @State private var isLoading = false
    
    var body: some View
    {
        VStack(spacing: 20)
        {
            // Close Button
            closeButton
            
            // Header
            headerView
            
            // Export Buttons
            exportButtonsGrid
            
            Spacer()
        }
        .padding()
        .background(Color.colors.MainBackgroundColor)
        .overlay { if isLoading { LoadingView() } }
        .alert("Kişiler", isPresented: $showingAlert) {
            Button("Tamam", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .fileExporter(
            isPresented: $isExporting,
            document: ContactsDocument(
                contactData: exportData ?? Data(),
                fileType: exportFileType
            ),
            contentType: exportFileType,
            defaultFilename: "contacts"
        ) { handleExportResult($0) }
    }
    
    private var closeButton: some View {
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
    }
    
    private var headerView: some View {
        VStack(spacing: 10) {
            Image(systemName: "folder.fill")
                .font(.system(size: 30))
                .foregroundColor(Color.colors.SecondaryTextColor)
            
            Text("Lütfen dışa aktarmak istediğiniz\ndosya türünü seçiniz.")
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
    }
    
    private var exportButtonsGrid: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                ExportButton(icon: "doc.text", title: ".csv") {
                    Task { await handleExport(type: .commaSeparatedText) }
                }
                
                ExportButton(icon: "person.crop.circle", title: ".vcf") {
                    Task { await handleExport(type: .vCard) }
                }
            }
            
            HStack(spacing: 20) {
                ExportButton(icon: "doc.fill", title: ".pdf") {
                    Task { await handleExport(type: .pdf) }
                }
                
                ExportButton(icon: "tablecells", title: ".xlsx") {
                    Task { await handleExport(type: .excel) }
                }
            }
        }
    }
    
    private func handleExport(type: UTType) async {
        await MainActor.run { isLoading = true }
        defer { Task { await MainActor.run { isLoading = false } } }
        
        exportFileType = type
        
        do {
            contacts = try await fetchContacts()
            await processExport()
        } catch {
            await MainActor.run {
                alertMessage = error.localizedDescription
                showingAlert = true
            }
        }
    }
    
    private func fetchContacts() async throws -> [CNContact] {
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
        
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    var tempContacts: [CNContact] = []
                    try store.enumerateContacts(with: request) { contact, _ in
                        tempContacts.append(contact)
                    }
                    continuation.resume(returning: tempContacts)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func processExport() async {
        await Task.detached {
            switch await exportFileType {
            case .commaSeparatedText: await MainActor.run { exportToCSV() }
            case .vCard: await MainActor.run { exportToVCF() }
            case .pdf: await MainActor.run { exportToPDF() }
            case .excel: await MainActor.run { exportToExcel() }
            default: break
            }
        }.value
        
        await MainActor.run { isExporting = true }
    }
    
    private func exportToCSV() {
        let csvString = contacts.map { contact in
            [
                contact.givenName,
                contact.familyName,
                contact.phoneNumbers.first?.value.stringValue ?? "",
                contact.emailAddresses.first?.value as String? ?? ""
            ].joined(separator: ",")
        }.joined(separator: "\n")
        
        let finalString = "Ad,Soyad,Telefon,Email\n" + csvString
        exportData = finalString.data(using: .utf8)
    }
    
    private func exportToVCF() {
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
        
        exportData = vcfString.data(using: .utf8)
    }
    
    private func exportToPDF() {
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        
        exportData = renderer.pdfData { context in
            context.beginPage()
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
            var yPosition: CGFloat = 50
            
            ["Ad", "Soyad", "Telefon", "Email"].enumerated().forEach { index, title in
                (title as NSString).draw(
                    at: CGPoint(x: CGFloat(index) * 140 + 40, y: yPosition),
                    withAttributes: attributes
                )
            }
            
            yPosition += 20
            
            for contact in contacts {
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
                if yPosition > pageRect.height - 50 {
                    context.beginPage()
                    yPosition = 50
                }
            }
        }
    }
    
    private func exportToExcel() {
        let excelString = contacts.map { contact in
            [
                contact.givenName,
                contact.familyName,
                contact.phoneNumbers.first?.value.stringValue ?? "",
                contact.emailAddresses.first?.value as String? ?? ""
            ].joined(separator: "\t")
        }.joined(separator: "\n")
        
        let finalString = "Ad\tSoyad\tTelefon\tEmail\n" + excelString
        exportData = finalString.data(using: .utf8)
    }
    
    private func handleExportResult(_ result: Result<URL, Error>) {
        switch result {
        case .success:
            alertMessage = "Kişiler başarıyla dışa aktarıldı!"
        case .failure(let error):
            alertMessage = "Dışa aktarma başarısız: \(error.localizedDescription)"
        }
        showingAlert = true
    }
}

// MARK: - Supporting Types

private enum ContactError: LocalizedError {
    case accessDenied
    
    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return "Lütfen ayarlardan kişilere erişime izin verin"
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

private struct ExportButton: View {
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
