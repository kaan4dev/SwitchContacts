import SwiftUI
import Contacts
import Foundation

struct ContactSelectionView: View
{
    @Binding var contacts: [ImportContact]
    @State private var searchText = ""
    @State private var isLoading = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View
    {
        VStack(spacing: 20)
        {
            HStack
            {
                Button(action: { selectAllContacts(&contacts) })
                {
                    Text("Hepsini seç")
                        .font(.subheadline)
                        .frame(width: 140, height: 40)
                        .foregroundColor(Color.colors.ButtonTextColor)
                        .padding(.horizontal, 10)
                        .background(Color.colors.ButtonBackgroundColor.opacity(0.9))
                        .cornerRadius(8)
                }
                
                Spacer()
                
                Button(action: { deselectAllContacts(&contacts) })
                {
                    Text("Seçimleri Geri Al")
                        .font(.subheadline)
                        .frame(width: 140, height: 40)
                        .foregroundColor(Color.colors.ButtonTextColor)
                        .padding(.horizontal, 10)
                        .background(Color.colors.ButtonBackgroundColor.opacity(0.9))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            
            HStack
            {
                TextField("Search", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            
            List
            {
                ForEach(filterContacts(contacts, searchText: searchText))
                {
                    contact in
                    ContactRowView(contact: Binding(
                        get: { contact },
                        set: { updatedContact in
                            if let index = contacts.firstIndex(where: { $0.id == updatedContact.id })
                            {
                                contacts[index] = updatedContact
                            }
                        }
                    ))
                }
            }
            .listStyle(.plain)
            
            Button(action: { Task { await importSelectedContacts() } }) {
                Text("Seçili Kişileri İçe Aktar")
                    .font(.headline)
                    .foregroundColor(Color.colors.ButtonTextColor)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.colors.ButtonBackgroundColor)
                    .cornerRadius(10)
            }
            .padding()
            
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
    }
    
    private func importSelectedContacts() async
    {
        isLoading = true
        defer { isLoading = false }
        
        do
        {
            try await importSelectedContactsFromSelection(contacts)
            alertMessage = "Kişiler başarıyla içe aktarıldı!"
            showingAlert = true
        }
        catch
        {
            alertMessage = "İçe aktarma hatası: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}

struct ContactSelectionView_Previews: PreviewProvider
{
    @State static var contacts = [
        ImportContact(firstName: "John", lastName: "Doe", phoneNumber: "1234567890", email: "john@example.com"),
        ImportContact(firstName: "Jane", lastName: "Doe", phoneNumber: "0987654321", email: "jane@example.com")
    ]
    
    static var previews: some View {
        ContactSelectionView(contacts: $contacts)
    }
}
