import SwiftUI

struct LogoAndNameView: View
{
    var body: some View
    {
        Text("Switch Contacts")
            .font(.title)
            .foregroundColor(Color.colors.MainTextColor)
        
        Image(systemName: "point.topright.arrow.triangle.backward.to.point.bottomleft.scurvepath.fill")
            .imageScale(.large)
            .foregroundColor(Color.colors.SecondaryTextColor)
        
        Divider()
            .background(Color.colors.MainTextColor)
    }
}

#Preview
{
    LogoAndNameView()
}
