import SwiftUI
import UniformTypeIdentifiers
import Contacts

struct ExportView: View
{
    @State private var contacts: [CNContact] = []
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isExporting = false
    @State private var exportData: Data?
    @State private var exportFileType: UTType = .commaSeparatedText
    @State private var isLoading = false
    
    var body: some View
    {
        ZStack
        {
            VStack(spacing: 90)
            {
                Button
                {
                    Task
                    {
                        isLoading = true
                        await requestContactsAccess()
                        isLoading = false
                    }
                }
                label:
                {
                    VStack
                    {
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .frame(width: 75, height: 100)
                            .imageScale(.large)
                            .foregroundColor(Color.colors.MainTextColor)
                        
                        Text("Dışa Aktar")
                            .imageScale(.large)
                            .foregroundColor(Color.colors.SecondaryTextColor)
                    }
                }
                .disabled(isLoading)
                
                Button {} label:
                {
                    Text("Aktarma Adımları")
                        .imageScale(.large)
                        .foregroundColor(Color.colors.ButtonTextColor)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                }
                .background(Color.colors.ButtonBackgroundColor)
                .cornerRadius(30)
            }
            .padding()
            
            if isLoading
            {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.colors.MainTextColor))
            }
        }
        .alert("Contacts", isPresented: $showingAlert)
        {
            Button("OK", role: .cancel) { }
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
        { result in
            switch result
            {
            case .success:
                alertMessage = "Exported successfully!"
                showingAlert = true
            case .failure(let error):
                alertMessage = "Export failed: \(error.localizedDescription)"
                showingAlert = true
            }
        }
    }
    
    private func requestContactsAccess() async
    {
        let store = CNContactStore()
        do
        {
            let granted = try await store.requestAccess(for: .contacts)
            if granted
            {
                await MainActor.run
                {
                    fetchContacts()
                }
            }
            else
            {
                await MainActor.run
                {
                    alertMessage = "Please enable contact access in Settings"
                    showingAlert = true
                }
            }
        }
        catch
        {
            await MainActor.run
            {
                alertMessage = "Error accessing contacts: \(error.localizedDescription)"
                showingAlert = true
            }
        }
    }
    
    private func fetchContacts()
    {
        let store = CNContactStore()
        let keys = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey
        ] as [CNKeyDescriptor]
        
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        do
        {
            contacts.removeAll()
            try store.enumerateContacts(with: request)
            { contact, _ in
                contacts.append(contact)
            }
            exportContacts()
        }
        catch
        {
            alertMessage = "Failed to fetch contacts: \(error.localizedDescription)"
            showingAlert = true
        }
    }
    
    private func exportContacts()
    {
        var csvString = "First Name,Last Name,Phone Number,Email\n"
        for contact in contacts
        {
            let firstName = contact.givenName
            let lastName = contact.familyName
            let phone = contact.phoneNumbers.first?.value.stringValue ?? ""
            let email = contact.emailAddresses.first?.value as String? ?? ""
            
            csvString += "\(firstName),\(lastName),\(phone),\(email)\n"
        }
        
        exportData = csvString.data(using: .utf8)
        exportFileType = .commaSeparatedText
        isExporting = true
    }
}

#Preview
{
    ExportView()
}
