import Foundation
import Contacts

func selectAllContacts(_ contacts: inout [ImportContact])
{
    for index in contacts.indices {
        contacts[index].isSelected = true
    }
}

func deselectAllContacts(_ contacts: inout [ImportContact])
{
    for index in contacts.indices {
        contacts[index].isSelected = false
    }
}

func filterContacts(_ contacts: [ImportContact], searchText: String) -> [ImportContact]
{
    if searchText.isEmpty
    {
        return contacts
    }
    else
    {
        return contacts.filter
        {
            $0.firstName.localizedCaseInsensitiveContains(searchText) ||
            $0.lastName.localizedCaseInsensitiveContains(searchText) ||
            $0.phoneNumber.localizedCaseInsensitiveContains(searchText) ||
            $0.email.localizedCaseInsensitiveContains(searchText)
        }
    }
}

func importSelectedContactsFromSelection(_ contacts: [ImportContact]) async throws
{
    let store = CNContactStore()
    
    let granted = try await store.requestAccess(for: .contacts)
    guard granted else {
        throw ImportError.accessDenied
    }
    
    try await withThrowingTaskGroup(of: Void.self)
    {
        group in
        for contact in contacts where contact.isSelected
        {
            group.addTask
            {
                let newContact = CNMutableContact()
                newContact.givenName = contact.firstName
                newContact.familyName = contact.lastName
                
                if !contact.phoneNumber.isEmpty
                {
                    newContact.phoneNumbers = [
                        CNLabeledValue(
                            label: CNLabelPhoneNumberMobile,
                            value: CNPhoneNumber(stringValue: contact.phoneNumber)
                        )
                    ]
                }
                
                if !contact.email.isEmpty
                {
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
