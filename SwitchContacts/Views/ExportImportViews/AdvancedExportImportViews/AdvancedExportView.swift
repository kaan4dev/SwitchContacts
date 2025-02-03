@preconcurrency import Contacts
import SwiftUI
import UniformTypeIdentifiers
import PDFKit
import Foundation

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
            
            headerView
            
            MiddleSection
            
            Spacer()
        }
        .padding()
        .background(Color.colors.MainBackgroundColor)
        .overlay { if isLoading { LoadingView() } }
        .alert("Kişiler", isPresented: $showingAlert)
        {
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
            handleExportResult(result, alertMessage: &alertMessage, showingAlert: &showingAlert)
        }
    }
    
    private var headerView: some View
    {
        VStack(spacing: 10)
        {
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
    
    private var MiddleSection: some View
    {
        VStack(spacing: 20)
        {
            HStack(spacing: 20)
            {
                ExportButtonView(icon: "doc.text", title: ".csv")
                {
                    Task { await handleExport(type: .commaSeparatedText) }
                }
                
                ExportButtonView(icon: "person.crop.circle", title: ".vcf")
                {
                    Task { await handleExport(type: .vCard) }
                }
            }
            
            HStack(spacing: 20)
            {
                ExportButtonView(icon: "doc.fill", title: ".pdf")
                {
                    Task { await handleExport(type: .pdf) }
                }
                
                ExportButtonView(icon: "tablecells", title: ".xlsx")
                {
                    Task { await handleExport(type: .excel) }
                }
            }
        }
    }
    
    private func handleExport(type: UTType) async
    {
        await MainActor.run { isLoading = true }
        defer { Task { await MainActor.run { isLoading = false } } }
        
        exportFileType = type
        
        do
        {
            contacts = try await fetchContacts()
            await processExport()
        }
        catch
        {
            await MainActor.run
            {
                alertMessage = error.localizedDescription
                showingAlert = true
            }
        }
    }
    
    private func processExport() async
    {
        await Task.detached
        {
            switch await exportFileType
            {
            case .commaSeparatedText: await MainActor.run { exportData = exportToCSV(contacts: contacts) }
            case .vCard: await MainActor.run { exportData = exportToVCF(contacts: contacts) }
            case .pdf: await MainActor.run { exportData = exportToPDF(contacts: contacts) }
            case .excel: await MainActor.run { exportData = exportToExcel(contacts: contacts) }
            default: break
            }
        }.value
        
        await MainActor.run { isExporting = true }
    }
}

#Preview
{
    AdvancedExportView()
}
