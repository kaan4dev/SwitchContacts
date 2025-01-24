import SwiftUI

struct HomeView: View 
{
    @State private var selectedTab = 0
    @State private var showingSteps = false
    
    var body: some View 
    {
        VStack 
        {
            Text("Switch Contacts")
                .font(.title)
                .foregroundColor(Color.colors.MainTextColor)
            
            Image(systemName: "point.topright.arrow.triangle.backward.to.point.bottomleft.scurvepath.fill")
                .imageScale(.large)
                .foregroundColor(Color.colors.SecondaryTextColor)
            
            Divider()
                .background(Color.colors.MainTextColor)
            
            ExportImportTabView(selectedTab: $selectedTab)
                .background(Color.colors.SplashBackgroundColor.opacity(0.2))
            
            Divider()
                .background(Color.colors.MainTextColor)
            
            Spacer()
            
            if selectedTab == 0 
            {
                ExportView(showingSteps: $showingSteps)
            } 
            else 
            {
                ImportView(showingSteps: $showingSteps)
            }
            
            Spacer()
        }
        .sheet(isPresented: $showingSteps) 
        {
            ExportStepsView()
        }
    }
}

#Preview 
{
    HomeView()
}
