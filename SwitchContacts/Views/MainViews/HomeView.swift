import SwiftUI
import Contacts
import UniformTypeIdentifiers

struct HomeView: View
{
    @State private var selectedTab = 0
    
    var body: some View
    {
        VStack()
        {
            Text("Switch Contacts")
                .font(.title)
                .foregroundColor(Color.colors.MainTextColor)
            
            Image(systemName: "point.topright.arrow.triangle.backward.to.point.bottomleft.scurvepath.fill")
                .imageScale(.large)
                .foregroundColor(Color.colors.SecondaryTextColor)
            
            ExportImportTabView(selectedTab: $selectedTab)
                .background(Color.colors.SplashBackgroundColor.opacity(0.2))
            
            Spacer()
            
            if selectedTab == 0
            {
                ExportView()
            }
            else
            {
                ImportView()
            }
            
            Spacer()
        }
    }
}

struct ExportImportTabView: View
{
    @Binding var selectedTab: Int
    
    var body: some View
    {
        HStack(spacing: 0)
        {
            Button
            {
                selectedTab = 0
            }
            label:
            {
                VStack
                {
                    Image(systemName: "square.and.arrow.up")
                    Text("Dışa Aktar")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(selectedTab == 0 ? Color.colors.ButtonBackgroundColor.opacity(0.3) : Color.clear)
            }
            
            Button
            {
                selectedTab = 1
            }
            label:
            {
                VStack
                {
                    Image(systemName: "square.and.arrow.down")
                    Text("İçe Aktar")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(selectedTab == 1 ? Color.colors.ButtonBackgroundColor.opacity(0.3) : Color.clear)
            }
        }
        .foregroundColor(Color.colors.MainTextColor)
    }
}



struct ContactsDocument: FileDocument
{
    var contactData: Data
    var fileType: UTType
    
    static var readableContentTypes: [UTType] { [.commaSeparatedText, .vCard] }
    
    init(contactData: Data, fileType: UTType)
    {
        self.contactData = contactData
        self.fileType = fileType
    }
    
    init(configuration: ReadConfiguration) throws
    {
        self.contactData = Data()
        self.fileType = .commaSeparatedText
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper
    {
        return FileWrapper(regularFileWithContents: contactData)
    }
}

#Preview
{
    HomeView()
}
