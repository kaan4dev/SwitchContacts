import SwiftUI

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

