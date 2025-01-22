import SwiftUI

struct MainTabView: View
{
    @Binding var selectedTab: Int

    var body: some View
    {
        TabView(selection: $selectedTab)
        {
            StepsView()
                .tabItem
                {
                    Image(systemName: "list.number")
                    Text("Steps")
                }
                .tag(0)
            
            HomeView()
                .tabItem
                {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(1)
            
            SettingsView()
                .tabItem
                {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(2)
        }
    }
}

#Preview
{
    MainTabView(selectedTab: .constant(1))
}
