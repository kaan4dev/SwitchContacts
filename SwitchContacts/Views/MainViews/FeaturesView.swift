import SwiftUI

struct FeaturesView: View
{
    var body: some View
    {
        VStack(spacing: 10)
        {
            Spacer()
            
            HStack
            {
                DismissButtonView()
                    .padding(.leading, 10)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            VStack(spacing: 30)
            {
                FeatureCard(
                    icon: "shield.checkerboard",
                    title: "Güvenli ve Gizli",
                    description: "Kişileriniz tamamen cihazınızda işlenir, hiçbir veri sunuculara aktarılmaz veya saklanmaz."
                )
                
                FeatureCard(
                    icon: "hand.tap",
                    title: "Kolay Kullanım",
                    description: "Adım adım rehberlik ile kişilerinizi kolayca aktarın, teknik bilgi gerektirmez."
                )
                
                FeatureCard(
                    icon: "doc.fill",
                    title: "Çoklu Dosya Desteği",
                    description: "CSV, VCF, PDF ve Excel formatlarında dosya içe/dışa aktarımı yapabilirsiniz."
                )
                
                FeatureCard(
                    icon: "arrow.triangle.2.circlepath",
                    title: "Çift Yönlü Aktarım",
                    description: "iOS'dan Android'e veya Android'den iOS'a kişilerinizi kolayca taşıyın."
                )
                
                FeatureCard(
                    icon: "checkmark.circle",
                    title: "Veri Bütünlüğü",
                    description: "Kişilerinizin tüm bilgileri (ad, soyad, telefon, email) eksiksiz aktarılır."
                )
            }
            .padding()
        }
        .background(Color.colors.MainBackgroundColor)
    }
}

struct FeatureCard: View
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
    FeaturesView()
}
