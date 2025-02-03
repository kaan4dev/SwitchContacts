import SwiftUI

struct MainTabView: View
{
    @Binding var selectedTab: Int

    var body: some View
    {
        TabView(selection: $selectedTab)
        {
            StepsSplashView()
                .tabItem
                {
                    Image(systemName: "list.number")
                    Text("Aktarma Adımları")
                }
                .tag(0)
            
            HomeView()
                .tabItem
                {
                    Image(systemName: "house")
                    Text("AnaSayfa")
                }
                .tag(1)
            
            SettingsView()
                .tabItem
                {
                    Image(systemName: "gear")
                    Text("Ayarlar")
                }
                .tag(2)
        }
    }
}

#Preview
{
    MainTabView(selectedTab: .constant(1))
}
