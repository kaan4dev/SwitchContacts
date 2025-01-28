import SwiftUI

struct ExportStepsView: View
{
    @State private var selectedTab = 0
    @Environment(\.dismiss) private var dismiss
    
    var body: some View
    {
        VStack(spacing: 10)
        {
            // Close Button
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
            
            LogoAndNameView()
            
            ExportStepsTabView(selectedTab: $selectedTab)
            
            Divider()
                .background(Color.colors.MainTextColor)
            
            // TabView ile sekme içerikleri
            TabView(selection: $selectedTab)
            {
                ScrollView
                {
                    GoogleStepsView()
                }
                .tag(0)
                
                ScrollView
                {
                    LocalPhoneStepsView()
                }
                .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: selectedTab)
        }
    }
}


struct ExportStepsSheetView: View
{
    @State private var selectedTab = 0
    @Environment(\.dismiss) private var dismiss
    
    var body: some View
    {
        VStack(spacing: 10)
        {
            // Close Button
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
            
            ExportStepsTabView(selectedTab: $selectedTab)
            
            Divider()
                .background(Color.colors.MainTextColor)
            
            // TabView ile sekme içerikleri
            TabView(selection: $selectedTab)
            {
                ScrollView
                {
                    GoogleStepsView()
                }
                .tag(0)
                
                ScrollView
                {
                    LocalPhoneStepsView()
                }
                .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: selectedTab)
        }
    }
}

#Preview
{
    ExportStepsView()
}

