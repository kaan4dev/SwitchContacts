import SwiftUI

struct ExportStepsView: View
{
    @State private var selectedTab = 0
    @Environment(\.dismiss) private var dismiss
    
    var body: some View
    {
        VStack(spacing: 10)
        {
            HStack
            {
                DismissButtonView()
                .padding(.leading, 16)
                Spacer()
            }
            
            LogoAndNameView()
            
            ExportStepsTabView(selectedTab: $selectedTab)
            
            Divider()
                .background(Color.colors.MainTextColor)
            
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
            HStack
            {
                DismissButtonView()
                .padding(.leading, 16)
                Spacer()
            }
            
            ExportStepsTabView(selectedTab: $selectedTab)
            
            Divider()
                .background(Color.colors.MainTextColor)
            
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

