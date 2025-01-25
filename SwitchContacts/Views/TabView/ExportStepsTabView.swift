import SwiftUI

struct ExportStepsTabView: View
{
    @Binding var selectedTab: Int
    
    var body: some View
    {
        HStack(spacing: 0)
        {
            Button
            {
                selectedTab = 0
            }
            label:
            {
                VStack
                {
                    Image("googleContactsIcon")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("Google Kişiler")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(selectedTab == 0 ? Color.colors.ButtonBackgroundColor.opacity(0.2) : Color.clear)
            }
            
            Button
            {
                selectedTab = 1
            }
            label:
            {
                VStack
                {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("Varsayılan Rehber")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(selectedTab == 1 ? Color.colors.ButtonBackgroundColor.opacity(0.2) : Color.clear)
            }
        }
        .foregroundColor(Color.colors.MainTextColor)
    }
}

struct GoogleStepsView: View
{
    var body: some View
    {
        VStack(spacing: 20)
        {
            Image("googleContactsIcon")
                .resizable()
                .frame(width: 100, height: 100)
            
            Text("Google Kişiler Adımları")
                .font(.title2)
                .foregroundColor(Color.colors.MainTextColor)
            
            Text("1. Google Kişiler'e gidin\n2. Kişileri dışa aktarın\n3. CSV dosyasını seçin\n4. İndirilen dosyayı uygulamamıza aktarın")
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.colors.SecondaryTextColor)
                .padding()
        }
    }
}

struct LocalPhoneStepsView: View
{
    var body: some View
    {
        VStack(spacing: 20)
        {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
            
            Text("Varsayılan Rehber Adımları")
                .font(.title2)
                .foregroundColor(Color.colors.MainTextColor)
            
            Text("1. Telefon ayarlarına gidin\n2. Kişiler bölümünü açın\n3. Tüm kişileri seçin\n4. Dışa aktarma seçeneğini kullanın")
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.colors.SecondaryTextColor)
                .padding()
        }
    }
}
