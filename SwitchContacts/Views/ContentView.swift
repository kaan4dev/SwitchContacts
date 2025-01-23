import SwiftUI

struct ContentView: View
{
    @State private var selectedTab = 1
    
    var body: some View
    {
        MainTabView(selectedTab: $selectedTab)
            .background(
                Color.colors.MainBackgroundColor
                    .ignoresSafeArea()
            )
    }
}

#Preview
{
    ContentView()
}
