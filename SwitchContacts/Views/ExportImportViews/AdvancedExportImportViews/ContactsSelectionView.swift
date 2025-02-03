import SwiftUI
import Contacts

struct ContactSelectionView: View {
    @Binding var contacts: [ImportContact]
    @State private var searchText = ""
    @State private var isLoading = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
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
            
            // Import Button
            Button(action: { Task { await importSelectedContacts() } }) {
                Text("Import Selected Contacts")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .background(Color.colors.MainBackgroundColor)
        .overlay { if isLoading { LoadingView() } }
        .alert("Import Contacts", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
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
            
            alertMessage = "Contacts imported successfully!"
            showingAlert = true
            
        } catch {
            alertMessage = "Import error: \(error.localizedDescription)"
            showingAlert = true
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
    
    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return "Please allow access to contacts in settings."
        }
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
