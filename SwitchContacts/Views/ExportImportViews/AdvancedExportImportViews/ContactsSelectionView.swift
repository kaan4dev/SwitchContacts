import SwiftUI

struct ContactSelectionView: View {
    @Binding var contacts: [ImportContact]
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Button(action: selectAll) {
                    Text("Select All")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button(action: deselectAll) {
                    Text("Deselect All")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            // Search Bar
            HStack {
                TextField("Search", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            
            // Contact List
            List {
                ForEach(filteredContacts) { contact in
                    ContactRow(contact: Binding(
                        get: { contact },
                        set: { updatedContact in
                            if let index = contacts.firstIndex(where: { $0.id == updatedContact.id }) {
                                contacts[index] = updatedContact
                            }
                        }
                    ))
                }
            }
            .listStyle(.plain)
            
            Spacer()
        }
        .padding()
        .background(Color.colors.MainBackgroundColor)
    }
    
    private var filteredContacts: [ImportContact] {
        if searchText.isEmpty {
            return contacts
        } else {
            return contacts.filter {
                $0.firstName.localizedCaseInsensitiveContains(searchText) ||
                $0.lastName.localizedCaseInsensitiveContains(searchText) ||
                $0.phoneNumber.localizedCaseInsensitiveContains(searchText) ||
                $0.email.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func selectAll() {
        for index in contacts.indices {
            contacts[index].isSelected = true
        }
    }
    
    private func deselectAll() {
        for index in contacts.indices {
            contacts[index].isSelected = false
        }
    }
}

private struct ContactRow: View {
    @Binding var contact: ImportContact
    
    var body: some View {
        HStack {
            Toggle("", isOn: $contact.isSelected)
                .labelsHidden()
            
            VStack(alignment: .leading) {
                Text("\(contact.firstName) \(contact.lastName)")
                    .font(.headline)
                Text(contact.phoneNumber)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                if !contact.email.isEmpty {
                    Text(contact.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct ContactSelectionView_Previews: PreviewProvider {
    @State static var contacts = [
        ImportContact(firstName: "John", lastName: "Doe", phoneNumber: "1234567890", email: "john@example.com"),
        ImportContact(firstName: "Jane", lastName: "Doe", phoneNumber: "0987654321", email: "jane@example.com")
    ]
    
    static var previews: some View {
        ContactSelectionView(contacts: $contacts)
    }
}