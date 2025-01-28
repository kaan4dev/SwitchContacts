import SwiftUI

struct ImportStepsTabView: View 
{
    @Binding var selectedTab: Int
    
    var body: some View 
    {
        HStack(spacing: 0) 
        {
            ForEach(0..<4) { index in
                Button 
                {
                    selectedTab = index
                } 
                label: 
                {
                    VStack 
                    {
                        Image(systemName: getTabIcon(index))
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text(getTabTitle(index))
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .foregroundColor(selectedTab == index ? Color.colors.MainTextColor : Color.colors.SecondaryTextColor)
                    .background(selectedTab == index ? Color.colors.ButtonBackgroundColor.opacity(0.2) : Color.clear)
                }
            }
        }
    }
    
    private func getTabIcon(_ index: Int) -> String 
    {
        switch index 
        {
            case 0: return "doc.text"
            case 1: return "person.crop.circle"
            case 2: return "doc.fill"
            case 3: return "tablecells"
            default: return ""
        }
    }
    
    private func getTabTitle(_ index: Int) -> String 
    {
        switch index 
        {
            case 0: return "CSV"
            case 1: return "VCF"
            case 2: return "PDF"
            case 3: return "Excel"
            default: return ""
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

struct ImportSheetStepsTabView: View
{
    @Binding var selectedTab: Int
    
    var body: some View
    {
        @Environment(\.dismiss) var dismiss
        
            HStack(spacing: 0)
            {
                ForEach(0..<4) { index in
                    Button
                    {
                        selectedTab = index
                    }
                    label:
                    {
                        VStack
                        {
                            Image(systemName: getTabIcon(index))
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text(getTabTitle(index))
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .foregroundColor(selectedTab == index ? Color.colors.MainTextColor : Color.colors.SecondaryTextColor)
                        .background(selectedTab == index ? Color.colors.ButtonBackgroundColor.opacity(0.2) : Color.clear)
                    }
                }
            }
        }
    }
    
    private func getTabIcon(_ index: Int) -> String
    {
        switch index
        {
            case 0: return "doc.text"
            case 1: return "person.crop.circle"
            case 2: return "doc.fill"
            case 3: return "tablecells"
            default: return ""
        }
    }
    
    private func getTabTitle(_ index: Int) -> String
{
    switch index
    {
    case 0: return "CSV"
    case 1: return "VCF"
    case 2: return "PDF"
    case 3: return "Excel"
    default: return ""
    }
    
}
#Preview 
{
    ImportSheetStepsTabView(selectedTab: .constant(0))
}
