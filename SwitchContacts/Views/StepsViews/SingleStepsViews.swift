import SwiftUI
import Foundation

struct GoogleStepsView: View
{
    var body: some View
    {
        VStack(spacing: 20)
        {
            Image("googleContactsIcon")
                .resizable()
                .frame(width: 100, height: 100)
            
            Text("Google Kişiler\nKullanarak Rehber Aktarma")
                .font(.title2)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.colors.MainTextColor)
            
            VStack(alignment: .leading, spacing: 10)
            {
                StepText(number: 1, text: "SwitchContacts uygulamamızdan .vcf seçeneğini seçerek rehber dosyanızı dışarı aktarın.")
                StepText(number: 2, text: "Dışa aktardığınız dosyayı mail, mesaj uygulamaları, dosya aktarım uygulamarı, bluetooth vb. şekilde rehberinizi aktarmak istediğiniz telefonunuza gönderin ve indirin.")
                StepText(number: 3, text: "Aktarmak istediğiniz telefonunuza 'Google Kişiler' uygulamasını indirin ve uygulamayı açın.")
                StepText(number: 4, text: "Ekranın sağ altında bulunan 'Düzenle' seçeneğine basın.")
                StepText(number: 5, text: "Aşağı kaydırarak 'Dosyadan içe aktar' seçeneğine dokunun.")
                StepText(number: 6, text: "Rehberinizi aktarmak istediğiniz telefona indirdiğiniz dosyayı seçin.")
                StepText(number: 8, text: "Rehberinizde seçtiğiniz kişiler cihazınıza kaydedilecektir.")
            }
        }
        .padding()
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
            
            Text("Telefon Rehberinden Dışa Aktarma")
                .font(.title2)
                .foregroundColor(Color.colors.MainTextColor)
            
            VStack(alignment: .leading, spacing: 10)
            {
                StepText(number: 1, text: "Telefonunuzun 'Kişiler' veya 'Rehber' uygulamasını açın.")
                StepText(number: 2, text: "Sağ üstteki üç nokta (⋮) simgesine dokunun ve 'Ayarlar'ı açın.")
                StepText(number: 3, text: "'Kişileri Yönet' veya 'Kişileri Dışa Aktar' seçeneğini bulun.")
                StepText(number: 4, text: ".vcf formatında dışa aktarmayı seçin.")
                StepText(number: 5, text: "Dosyanızı telefon hafızasına veya SD karta kaydedin.")
            }
        }
        .padding()
    }
}

struct CSVStepsView: View
{
    var body: some View
    {
        VStack(spacing: 20)
        {
            Image(systemName: "doc.text")
                .resizable()
                .frame(width: 100, height: 100)
            
            Text("CSV Dosyası İçe Aktarma")
                .font(.title2)
                .foregroundColor(Color.colors.MainTextColor)
            
            VStack(alignment: .leading, spacing: 10)
            {
                StepText(number: 1, text: "Bilgisayarınızda veya telefonunuzda CSV dosyanızı oluşturun.")
                StepText(number: 2, text: "İlk satırda başlıklar şu şekilde olmalı: Ad, Soyad, Telefon, Email.")
                StepText(number: 3, text: "Uygulamamızda 'İçe Aktar' butonuna basın.")
                StepText(number: 4, text: "Cihazınızdan CSV dosyanızı seçin ve içeri aktarma işlemini tamamlayın.")
            }
        }
        .padding()
    }
}

struct VCFStepsView: View
{
    var body: some View
    {
        VStack(spacing: 20)
        {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 100, height: 100)
            
            Text("VCF (vCard) Dosyası İçe Aktarma")
                .font(.title2)
                .foregroundColor(Color.colors.MainTextColor)
            
            VStack(alignment: .leading, spacing: 10)
            {
                StepText(number: 1, text: "VCF dosyanızı Google Kişiler veya telefonunuzdan dışa aktarın.")
                StepText(number: 2, text: "Uygulamamızda 'İçe Aktar' butonuna basın.")
                StepText(number: 3, text: "Cihazınızdan VCF dosyanızı seçin.")
                StepText(number: 4, text: "Kişileriniz otomatik olarak aktarılacaktır.")
            }
        }
        .padding()
    }
}

struct PDFStepsView: View
{
    var body: some View
    {
        VStack(spacing: 20)
        {
            Image(systemName: "doc.fill")
                .resizable()
                .frame(width: 100, height: 100)
            
            Text("PDF Dosyası İçe Aktarma")
                .font(.title2)
                .foregroundColor(Color.colors.MainTextColor)
            
            VStack(alignment: .leading, spacing: 10)
            {
                StepText(number: 1, text: "PDF dosyanızı hazırlayın (tercihen tablo formatında).")
                StepText(number: 2, text: "Uygulamamızda 'İçe Aktar' butonuna basın.")
                StepText(number: 3, text: "Cihazınızdan PDF dosyanızı seçin.")
                StepText(number: 4, text: "Uygulama, PDF içeriğini tarayarak kişileri otomatik olarak çıkartacaktır.")
            }
        }
        .padding()
    }
}

struct ExcelStepsView: View
{
    var body: some View
    {
        VStack(spacing: 20)
        {
            Image(systemName: "tablecells")
                .resizable()
                .frame(width: 100, height: 100)
            
            Text("Excel Dosyası İçe Aktarma")
                .font(.title2)
                .foregroundColor(Color.colors.MainTextColor)
            
            VStack(alignment: .leading, spacing: 10)
            {
                StepText(number: 1, text: "Excel dosyanızı oluşturun.")
                StepText(number: 2, text: "İlk satır başlıkları şu şekilde olmalı: Ad, Soyad, Telefon, Email.")
                StepText(number: 3, text: "Uygulamamızda 'İçe Aktar' butonuna basın.")
                StepText(number: 4, text: "Cihazınızdan Excel dosyanızı seçin.")
                StepText(number: 5, text: "Veriler otomatik olarak içe aktarılacaktır.")
            }
        }
        .padding()
    }
}

/// Adımları göstermek için ortak bir yapı
struct StepText: View
{
    let number: Int
    let text: String
    
    var body: some View
    {
        HStack(alignment: .top)
        {
            Text("\(number).")
                .font(.headline)
                .foregroundColor(Color.colors.MainTextColor)
                .padding(.trailing, 5)
            
            Text(text)
                .font(.body)
                .foregroundColor(Color.colors.SecondaryTextColor)
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview
{
    GoogleStepsView()
}
