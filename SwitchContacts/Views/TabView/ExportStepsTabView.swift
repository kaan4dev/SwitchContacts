import SwiftUI

struct ExportStepsTabView: View
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
                    Image("googleContactsIcon")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("Google Kişiler")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(selectedTab == 0 ? Color.colors.ButtonBackgroundColor.opacity(0.2) : Color.clear)
            }
            
            Button
            {
                selectedTab = 1
            }
            label:
            {
                VStack
                {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("Varsayılan Rehber")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(selectedTab == 1 ? Color.colors.ButtonBackgroundColor.opacity(0.2) : Color.clear)
            }
        }
        .foregroundColor(Color.colors.MainTextColor)
    }
}

#Preview
{
    ExportStepsTabView(selectedTab: .constant(0))
}
