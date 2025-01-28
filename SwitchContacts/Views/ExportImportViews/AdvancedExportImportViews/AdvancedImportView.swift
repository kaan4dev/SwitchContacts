import SwiftUI

struct AdvancedImportView: View
{
    var body: some View
    {
        VStack(spacing: 20)
        {
            HStack
            {
                DismissButtonView()
                    .padding(.leading, 10)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            Spacer()

            
            VStack(spacing: 10)
            {
                Image(systemName: "folder.fill")
                    .font(.system(size: 30))
                    .foregroundColor(Color.colors.SecondaryTextColor)
                
                Text("Lütfen içe aktarmak istediğiniz\ndosya türünü seçiniz.")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color.colors.MainTextColor,
                                Color.colors.SecondaryTextColor
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                    .minimumScaleFactor(0.7)
            }
            
            HStack(spacing: 20)
            {
                Button(action: {})
                {
                    VStack
                    {
                        Image(systemName: "doc.text")
                            .font(.system(size: 30))
                            .foregroundColor(Color.colors.SecondaryTextColor)
                        
                        Text(".csv")
                            .foregroundColor(Color.colors.MainTextColor)
                    }
                    .frame(width: 150, height: 100)
                    .background(Color.colors.ButtonBackgroundColor.opacity(0.2))
                    .cornerRadius(10)
                }
                
                Button(action: {})
                {
                    VStack
                    {
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 30))
                            .foregroundColor(Color.colors.SecondaryTextColor)
                        Text(".vcf")
                            .foregroundColor(Color.colors.MainTextColor)
                    }
                    .frame(width: 150, height: 100)
                    .background(Color.colors.ButtonBackgroundColor.opacity(0.2))
                    .cornerRadius(10)
                }
            }
            
            HStack(spacing: 20)
            {
                Button(action: {})
                {
                    VStack
                    {
                        Image(systemName: "text.document")
                            .font(.system(size: 30))
                            .foregroundColor(Color.colors.SecondaryTextColor)
                        Text("pdf")
                            .foregroundColor(Color.colors.MainTextColor)
                    }
                    .frame(width: 150, height: 100)
                    .background(Color.colors.ButtonBackgroundColor.opacity(0.2))
                    .cornerRadius(10)
                }
                
                Button(action: {})
                {
                    VStack
                    {
                        Image(systemName: "tablecells")
                            .font(.system(size: 30))
                            .foregroundColor(Color.colors.SecondaryTextColor)
                        Text("excel")
                            .foregroundColor(Color.colors.MainTextColor)
                    }
                    .frame(width: 150, height: 100)
                    .background(Color.colors.ButtonBackgroundColor.opacity(0.2))
                    .cornerRadius(10)
                }
            }
            Spacer()
        }
        .padding()

    }
}

#Preview {
    AdvancedImportView()
}
