import SwiftUI
import UniformTypeIdentifiers
import Contacts
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
            HStack
            {
                Button
                {
                    dismiss()
                }
                label:
                {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.colors.MainTextColor)
                }
                .padding(.leading, 16)
                Spacer()
            }
            
            VStack(spacing: 10)
            {
                Image(systemName: "folder.fill")
                    .font(.system(size: 30))
                    .foregroundColor(Color.colors.SecondaryTextColor)
                
                Text("Lütfen dışa aktarmak istediğiniz\ndosya türünü seçiniz.")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color.colors.MainTextColor,
                                Color.colors.SecondaryTextColor
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
            }
            
            VStack(spacing: 20)
            {
                HStack(spacing: 20)
                {
                    ExportButton(icon: "person.crop.circle", title: ".vcf\n(önerilen)")
                    {
                        exportFileType = .vCard
                        Task
                        {
                            await exportContacts()
                        }
                    }
                    
                    ExportButton(icon: "doc.text", title: ".csv")
                    {
                        exportFileType = .commaSeparatedText
                        Task
                        {
                            await exportContacts()
                        }
                    }
                }
                
                HStack(spacing: 20)
                {
                    ExportButton(icon: "doc.fill", title: ".pdf")
                    {
                        Task
                        {
                            await exportContacts()
                            exportToPDF()
                        }
                    }
                    
                    ExportButton(icon: "tablecells", title: ".xlsx")
                    {
                        Task
                        {
                            await exportContacts()
                            exportToExcel()
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.colors.MainBackgroundColor)
        .overlay
        {
            if isLoading
            {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.colors.MainTextColor))
            }
        }
        .alert("Kişiler", isPresented: $showingAlert)
        {
            Button("Tamam", role: .cancel) { }
        }
        message:
        {
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
        )
        {
            result in
            switch result
            {
                case .success:
                    alertMessage = "Kişiler başarıyla dışa aktarıldı!"
                    showingAlert = true
                case .failure(let error):
                    alertMessage = "Dışa aktarma başarısız: \(error.localizedDescription)"
                    showingAlert = true
            }
        }
    }
    
    private func exportContacts() async
    {
        isLoading = true
        let store = CNContactStore()
        
        do
        {
            let granted = try await store.requestAccess(for: .contacts)
            if granted
            {
                let keys = [
                    CNContactGivenNameKey,
                    CNContactFamilyNameKey,
                    CNContactPhoneNumbersKey,
                    CNContactEmailAddressesKey
                ] as [CNKeyDescriptor]
                
                let request = CNContactFetchRequest(keysToFetch: keys)
                contacts.removeAll()
                
                try store.enumerateContacts(with: request)
                { contact, _ in
                    contacts.append(contact)
                }
                
                switch exportFileType
                {
                    case .commaSeparatedText:
                        exportToCSV()
                    case .vCard:
                        exportToVCF()
                    default:
                        break
                }
            }
            else
            {
                alertMessage = "Lütfen ayarlardan kişilere erişime izin verin"
                showingAlert = true
            }
        }
        catch
        {
            alertMessage = "Kişilere erişim hatası: \(error.localizedDescription)"
            showingAlert = true
        }
        
        isLoading = false
    }
    
    private func exportToCSV()
    {
        var csvString = "Ad,Soyad,Telefon,Email\n"
        for contact in contacts
        {
            let firstName = contact.givenName.replacingOccurrences(of: ",", with: " ")
            let lastName = contact.familyName.replacingOccurrences(of: ",", with: " ")
            let phone = contact.phoneNumbers.first?.value.stringValue ?? ""
            let email = contact.emailAddresses.first?.value as String? ?? ""
            
            csvString += "\(firstName),\(lastName),\(phone),\(email)\n"
        }
        
        exportData = csvString.data(using: .utf8)
        exportFileType = .commaSeparatedText
        isExporting = true
    }
    
    private func exportToVCF()
    {
        let vcfString = contacts.map { contact -> String in
            var vcf = "BEGIN:VCARD\nVERSION:3.0\n"
            vcf += "N:\(contact.familyName);\(contact.givenName);;;\n"
            vcf += "FN:\(contact.givenName) \(contact.familyName)\n"
            
            if let phone = contact.phoneNumbers.first?.value.stringValue
            {
                vcf += "TEL;TYPE=CELL:\(phone)\n"
            }
            
            if let email = contact.emailAddresses.first?.value as String?
            {
                vcf += "EMAIL;TYPE=HOME:\(email)\n"
            }
            
            vcf += "END:VCARD\n"
            return vcf
        }.joined()
        
        exportData = vcfString.data(using: .utf8)
        exportFileType = .vCard
        isExporting = true
    }
    
    private func exportToPDF()
    {
        let pdfMetaData = [
            kCGPDFContextCreator: "Switch Contacts",
            kCGPDFContextAuthor: "Switch Contacts App"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4 size
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            let attributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)
            ]
            
            var yPosition: CGFloat = 50
            
            // Header
            ["Ad", "Soyad", "Telefon", "Email"].enumerated().forEach { index, title in
                let xPosition = CGFloat(index) * 140 + 40
                (title as NSString).draw(
                    at: CGPoint(x: xPosition, y: yPosition),
                    withAttributes: attributes
                )
            }
            
            yPosition += 20
            
            // Content
            for contact in contacts
            {
                let firstName = contact.givenName
                let lastName = contact.familyName
                let phone = contact.phoneNumbers.first?.value.stringValue ?? ""
                let email = contact.emailAddresses.first?.value as String? ?? ""
                
                [firstName, lastName, phone, email].enumerated().forEach { index, value in
                    let xPosition = CGFloat(index) * 140 + 40
                    (value as NSString).draw(
                        at: CGPoint(x: xPosition, y: yPosition),
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
        
        exportData = data
        exportFileType = .pdf
        isExporting = true
    }
    
    private func exportToExcel()
    {
        var excelString = "Ad\tSoyad\tTelefon\tEmail\n"
        
        for contact in contacts
        {
            let firstName = contact.givenName
            let lastName = contact.familyName
            let phone = contact.phoneNumbers.first?.value.stringValue ?? ""
            let email = contact.emailAddresses.first?.value as String? ?? ""
            
            excelString += "\(firstName)\t\(lastName)\t\(phone)\t\(email)\n"
        }
        
        exportData = excelString.data(using: .utf8)
        exportFileType = .tabSeparatedText
        isExporting = true
    }
}

struct ExportButton: View
{
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View
    {
        Button(action: action)
        {
            VStack
            {
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

#Preview
{
    AdvancedExportView()
}
