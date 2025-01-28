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

struct CSVStepsView: View
{
    var body: some View
    {
        VStack(spacing: 20)
        {
            Image(systemName: "doc.text")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(Color.colors.MainTextColor)
            
            Text("CSV Dosyası İçe Aktarma")
                .font(.title2)
                .foregroundColor(Color.colors.MainTextColor)
            
            Text("1. CSV dosyanızı hazırlayın\n2. Dosyanın sütun başlıkları: Ad, Soyad, Telefon, Email olmalı\n3. Uygulamamızdan 'İçe Aktar' butonuna basın\n4. CSV dosyanızı seçin")
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.colors.SecondaryTextColor)
                .padding()
        }
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
                .foregroundColor(Color.colors.MainTextColor)
            
            Text("VCF Dosyası İçe Aktarma")
                .font(.title2)
                .foregroundColor(Color.colors.MainTextColor)
            
            Text("1. VCF (vCard) dosyanızı hazırlayın\n2. Uygulamamızdan 'İçe Aktar' butonuna basın\n3. VCF dosyanızı seçin\n4. Kişileriniz otomatik olarak aktarılacak")
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.colors.SecondaryTextColor)
                .padding()
        }
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
                .foregroundColor(Color.colors.MainTextColor)
            
            Text("PDF Dosyası İçe Aktarma")
                .font(.title2)
                .foregroundColor(Color.colors.MainTextColor)
            
            Text("1. PDF dosyanızı hazırlayın\n2. Dosya içeriği tablo formatında olmalı\n3. Uygulamamızdan 'İçe Aktar' butonuna basın\n4. PDF dosyanızı seçin\n5. Tablodan kişiler otomatik çıkarılacak")
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.colors.SecondaryTextColor)
                .padding()
        }
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
                .foregroundColor(Color.colors.MainTextColor)
            
            Text("Excel Dosyası İçe Aktarma")
                .font(.title2)
                .foregroundColor(Color.colors.MainTextColor)
            
            Text("1. Excel dosyanızı hazırlayın\n2. İlk satır: Ad, Soyad, Telefon, Email olmalı\n3. Uygulamamızdan 'İçe Aktar' butonuna basın\n4. Excel dosyanızı seçin\n5. Veriler otomatik dönüştürülecek")
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.colors.SecondaryTextColor)
                .padding()
        }
    }
}
