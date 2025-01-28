import SwiftUI

struct ExportStepsView: View
{
    @State private var selectedTab = 0
    
    var body: some View
    {
        VStack
        {
            ExportStepsTabView(selectedTab: $selectedTab)
                .padding(.vertical)
            
            if selectedTab == 0
            {
                GoogleStepsView()
            }
            else
            {
                LocalPhoneStepsView()
            }
            
            Spacer()
        }
    }
}

struct ExportStepsSheetView: View
{
    @State private var selectedTab = 0
    
    var body: some View
    {
        
            VStack
            {
                ExportSheetStepsTabView(selectedTab: $selectedTab)
                    .padding(.vertical)
                
                if selectedTab == 0
                {
                    GoogleStepsView()
                }
                else
                {
                    LocalPhoneStepsView()
                }
                
                Spacer()
            }
        
    }
}

#Preview
{
    @Previewable @State var selectedTab: Int = 1
    
    
    ExportSheetStepsTabView(selectedTab: $selectedTab)
}
