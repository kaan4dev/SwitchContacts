import SwiftUI

struct FeatureCardView: View
{
    let icon: String
    let title: String
    let description: String
    
    var body: some View
    {
        HStack(alignment: .top, spacing: 15)
        {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(Color.colors.MainTextColor)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 8)
            {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.colors.MainTextColor)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(Color.colors.SecondaryTextColor)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(Color.colors.ButtonBackgroundColor.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview
{
    FeatureCardView(icon: "", title: "", description: "")
}
