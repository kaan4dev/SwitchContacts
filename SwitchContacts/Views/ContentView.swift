import SwiftUI

struct ContentView: View
{
    @State private var selectedTab = 1

    var body: some View
    {
        MainTabView(selectedTab: $selectedTab)
            .background(
                Color("MainBackgroundColor")
                    .ignoresSafeArea()
            )
    }
}

#Preview
{
    ContentView()
}
