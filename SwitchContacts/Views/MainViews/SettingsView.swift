import SwiftUI

struct SettingsView: View
{
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showAlert = false

    var body: some View
    {
        NavigationView
        {
            Form
            {
                Section(header: Text("Görünüm Ayarları"))
                {
                    Toggle("Koyu Mod", isOn: $isDarkMode)
                        .onChange(of: isDarkMode)
                        {
                            oldValue, newValue in
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                            {
                                windowScene.windows.first?.overrideUserInterfaceStyle = newValue ? .dark : .light
                            }
                        }
                }

                Section(header: Text("Diğer Ayarlar"))
                {
                    Button(action:
                        {
                        if let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID?action=write-review")
                        {
                            UIApplication.shared.open(url)
                        }
                    })
                    {
                        HStack
                        {
                            Image(systemName: "star.leadinghalf.filled")
                                .foregroundColor(Color.colors.MainTextColor)
                            Text("Uygulamayı Değerlendir")
                                .foregroundColor(Color.colors.MainTextColor)
                        }
                    }

                    Button(action:
                        {
                        showAlert = true
                    })
                    {
                        HStack
                        {
                            Image(systemName: "envelope.stack")
                                .foregroundColor(Color.colors.MainTextColor)
                            Text("Geri Bildirim Gönder")
                                .foregroundColor(Color.colors.MainTextColor)
                        }
                    }
                    .alert(isPresented: $showAlert)
                    {
                        Alert(
                            title: Text("Geri Bildirim"),
                            message: Text("Geri bildiriminiz için teşekkür ederiz!"),
                            dismissButton: .default(Text("Tamam"))
                        )
                    }
                }
            }
            .navigationTitle("Ayarlar")
        }
    }
}

struct SettingsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        SettingsView()
    }
}
