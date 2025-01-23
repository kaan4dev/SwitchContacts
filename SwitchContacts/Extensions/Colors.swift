import SwiftUI

extension Color
{
    static let colors = Color.Colors()
    
    struct Colors
    {
        let MainTextColor = Color("MainTextColor")
        let SecondaryTextColor = Color("SecondaryTextColor")
        let ButtonTextColor = Color("ButtonTextColor")
        let SplashTextColor = Color("SplashTextColor")

        
        let MainBackgroundColor = Color("MainBackgroundColor")
        let ButtonBackgroundColor = Color("ButtonBackgroundColor")
        let SplashBackgroundColor = Color("SplashBackgroundColor")
        let SplashScreenBackgroundColors = Color("SplashScreenBackgroundColors")
    }
}
