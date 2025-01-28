import SwiftUI

enum StepViewType 
{
    case export
    case `import`
}

struct HomeView: View 
{
    @State private var selectedTab = 0
    @State private var showingSteps = false
    @State private var stepViewType: StepViewType = .export
    
    var body: some View 
    {
        VStack 
        {
            LogoAndNameView()
            
            ExportImportTabView(selectedTab: $selectedTab)
                .background(Color.colors.SplashBackgroundColor.opacity(0.2))
            
            Divider()
                .background(Color.colors.MainTextColor)
            
            Spacer()
            
             if selectedTab == 0 
            {
                ExportView(showingSteps: $showingSteps)
                    .onChange(of: showingSteps) { oldValue, newValue in
                        if newValue 
                        {
                            stepViewType = .export
                        }
                    }
            } 
            else 
            {
                ImportView(showingSteps: $showingSteps)
                    .onChange(of: showingSteps) { oldValue, newValue in
                        if newValue 
                        {
                            stepViewType = .import
                        }
                    }
            }
            
            Spacer()
        }
        .sheet(isPresented: $showingSteps) 
        {
            if stepViewType == .export 
            {
                ExportStepsView()
            } 
            else 
            {
                ImportStepsView()
            }
        }
    }
}

#Preview 
{
    HomeView()
}
