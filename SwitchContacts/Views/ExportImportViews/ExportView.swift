import SwiftUI
import UniformTypeIdentifiers
import Contacts

struct ExportView: View
{
    @Binding var showingSteps: Bool
    @State private var contacts: [CNContact] = []
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isExporting = false
    @State private var exportData: Data?
    @State private var exportFileType: UTType = .commaSeparatedText
    @State private var isLoading = false
    @State private var showAdvancedExportSheet = false

    var body: some View
    {
        NavigationView
        {
            ZStack
            {
                VStack(spacing: 90)
                {
                    Button
                    {
                        showAdvancedExportSheet = true
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
                    .sheet(isPresented: $showAdvancedExportSheet) {
                        AdvancedExportView()
                    }

                    Button
                    {
                        showingSteps = true
                    }
                    label:
                    {
                        Text("Dışa Aktarma Adımları")
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
                await MainActor.run {
                    alertMessage = "Lütfen ayarlardan kişilere erişime izin verin"
                    showingAlert = true
                }
            }
        }
        catch
        {
            await MainActor.run
            {
                alertMessage = "Kişilere erişim hatası: \(error.localizedDescription)"
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

        do {
            contacts.removeAll()
            try store.enumerateContacts(with: request)
            {
                contact, _ in
                contacts.append(contact)
            }
            exportContacts()
        }
        catch
        {
            alertMessage = "Kişiler getirilirken hata oluştu: \(error.localizedDescription)"
            showingAlert = true
        }
    }

    private func exportContacts()
    {
        var csvString = "Ad,Soyad,Telefon,Email\n"
        for contact in contacts {
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
    ExportView(showingSteps: .constant(false))
}
