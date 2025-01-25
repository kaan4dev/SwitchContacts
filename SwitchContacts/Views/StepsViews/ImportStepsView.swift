import SwiftUI

struct ImportStepsView: View 
{
    @State private var selectedTab = 0
    
    var body: some View 
    {
        VStack(spacing: 10) 
        {
            // Header
            Text("Switch Contacts")
                .font(.title)
                .foregroundColor(Color.colors.MainTextColor)
            
            Image(systemName: "point.topright.arrow.triangle.backward.to.point.bottomleft.scurvepath.fill")
                .imageScale(.large)
                .foregroundColor(Color.colors.SecondaryTextColor)
            
            Divider()
                .background(Color.colors.MainTextColor)
            
            // Custom Tab Bar
            ImportStepsTabView(selectedTab: $selectedTab)
            
            Divider()
                .background(Color.colors.MainTextColor)
            
            // Content
            TabView(selection: $selectedTab) 
            {
                CSVStepsView()
                    .tag(0)
                VCFStepsView()
                    .tag(1)
                PDFStepsView()
                    .tag(2)
                ExcelStepsView()
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}


#Preview 
{
    ImportStepsView()
}
