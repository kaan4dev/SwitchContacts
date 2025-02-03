import SwiftUI

struct ContactRowView: View
{
    @Binding var contact: ImportContact
    
    var body: some View
    {
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

