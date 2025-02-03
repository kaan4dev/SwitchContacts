import SwiftUI
import UniformTypeIdentifiers
import Contacts
import Foundation

struct AdvancedImportView: View
{
    @Environment(\.dismiss) private var dismiss
    @State private var showingFilePicker = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var importedContacts: [ImportContact] = []
    @State private var selectedFileType: UTType = .commaSeparatedText
    @State private var showingContactSelection = false
    
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
            
            VStack(spacing: 20)
            {
                HStack(spacing: 20)
                {
                    ImportButtonView(icon: "doc.text", title: ".csv")
                    {
                        selectedFileType = .commaSeparatedText
                        showingFilePicker = true
                    }
                    
                    ImportButtonView(icon: "person.crop.circle", title: ".vcf")
                    {
                        selectedFileType = .vCard
                        showingFilePicker = true
                    }
                }
                
                HStack(spacing: 20)
                {
                    ImportButtonView(icon: "tablecells", title: ".xlsx")
                    {
                        selectedFileType = .excel
                        showingFilePicker = true
                    }
                }
            }
            
            if !importedContacts.isEmpty
            {
                Button(action: { showingContactSelection = true })
                {
                    Text("Seçili Kişileri Görüntüle ve Düzenle")
                        .font(.headline)
                        .foregroundColor(Color.colors.ButtonTextColor)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(Color.colors.ButtonBackgroundColor)
                        .cornerRadius(10)
                }
                .padding()
            }
            
            Spacer()
        }
        .padding()
        .background(Color.colors.MainBackgroundColor)
        .overlay
        {
            if isLoading { LoadingView() } }
        .alert("İçe Aktarma", isPresented: $showingAlert)
        {
            Button("Tamam", role: .cancel) { }
        }
        message:
        {
            Text(alertMessage)
        }
        .fileImporter(
            isPresented: $showingFilePicker,
            allowedContentTypes: [selectedFileType],
            allowsMultipleSelection: false
        )
        {
            result in
            Task
            {
                do
                {
                    isLoading = true
                    guard let fileURL = try result.get().first else { return }
                    
                    guard fileURL.startAccessingSecurityScopedResource() else {
                        throw ImportError.accessDenied
                    }
                    
                    defer {
                        fileURL.stopAccessingSecurityScopedResource()
                    }
                    
                    let data = try Data(contentsOf: fileURL)
                    importedContacts = try await parseContacts(from: data, fileType: selectedFileType)
                    
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
}

#Preview
{
    AdvancedImportView()
}
