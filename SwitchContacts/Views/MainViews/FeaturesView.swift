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
                FeatureCardView(
                    icon: "shield.checkerboard",
                    title: "Güvenli ve Gizli",
                    description: "Kişileriniz tamamen cihazınızda işlenir, hiçbir veri sunuculara aktarılmaz veya saklanmaz."
                )
                
                FeatureCardView(
                    icon: "hand.tap",
                    title: "Kolay Kullanım",
                    description: "Adım adım rehberlik ile kişilerinizi kolayca aktarın, teknik bilgi gerektirmez."
                )
                
                FeatureCardView(
                    icon: "doc.fill",
                    title: "Çoklu Dosya Desteği",
                    description: "CSV, VCF, PDF ve Excel formatlarında dosya içe/dışa aktarımı yapabilirsiniz."
                )
                
                FeatureCardView(
                    icon: "arrow.triangle.2.circlepath",
                    title: "Çift Yönlü Aktarım",
                    description: "iOS'dan Android'e veya Android'den iOS'a kişilerinizi kolayca taşıyın."
                )
                
                FeatureCardView(
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

#Preview
{
    FeaturesView()
}
