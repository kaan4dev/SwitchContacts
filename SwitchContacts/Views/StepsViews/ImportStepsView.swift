import SwiftUI

struct ImportStepsView: View
{
    @State private var selectedTab = 0
    @Environment(\.dismiss) private var dismiss
    
    var body: some View
    {
        VStack(spacing: 10)
        {
            // Close Button
            HStack
            {
                Button
                {
                    dismiss()
                }
                label:
                {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.colors.MainTextColor)
                }
                .padding(.leading, 16)
                Spacer()
            }
            
            // Header
            Text("Switch Contacts")
                .font(.title)
                .foregroundColor(Color.colors.MainTextColor)
            
            Image(systemName: "point.topright.arrow.triangle.backward.to.point.bottomleft.scurvepath.fill")
                .imageScale(.large)
                .foregroundColor(Color.colors.SecondaryTextColor)
            
            Divider()
                .background(Color.colors.MainTextColor)
            
            ImportStepsTabView(selectedTab: $selectedTab)
            
            Divider()
                .background(Color.colors.MainTextColor)
            
            TabView(selection: $selectedTab)
            {
                ScrollView
                {
                    CSVStepsContentView()
                }
                .tag(0)
                
                ScrollView
                {
                    VCFStepsContentView()
                }
                .tag(1)
                
                ScrollView
                {
                    PDFStepsContentView()
                }
                .tag(2)
                
                ScrollView
                {
                    ExcelStepsContentView()
                }
                .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: selectedTab)
        }
    }
}

struct CSVStepsContentView: View
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

struct VCFStepsContentView: View
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

struct PDFStepsContentView: View
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

struct ExcelStepsContentView: View
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

#Preview
{
    ImportStepsView()
}

struct ImportStepsSheetView: View
{
    @State private var selectedTab = 0
    @Environment(\.dismiss) private var dismiss
    
    var body: some View
    {
        VStack
        {
            HStack
            {
                Button
                {
                    dismiss()
                }
                label:
                {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.colors.MainTextColor)
                }
                .padding(.leading, 16)
                Spacer()
            }
            
            ImportSheetStepsTabView(selectedTab: $selectedTab)
            
            if selectedTab == 0
            {
                GoogleStepsView()
            }
            else
            {
                LocalPhoneStepsView()
            }
            Spacer()
        }
    }
}

#Preview
{
    ImportStepsSheetView()
}
