import SwiftUI

struct ImportButtonView: View
{
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View
    {
        Button(action: action)
        {
            VStack
            {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(Color.colors.SecondaryTextColor)
                Text(title)
                    .foregroundColor(Color.colors.MainTextColor)
            }
            .frame(width: 150, height: 100)
            .background(Color.colors.ButtonBackgroundColor.opacity(0.2))
            .cornerRadius(10)
        }
    }
}

#Preview
{
    ImportButtonView(icon: "square.and.arrow.up", title: "Export", action:
    {
        print("Export button tapped!")
    })
}
