import SwiftUI

struct ImportStepsTabView: View 
{
    @Binding var selectedTab: Int
    
    var body: some View 
    {
        HStack(spacing: 0) 
        {
            ForEach(0..<4)
            {
                index in
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

#Preview 
{
    ImportStepsTabView(selectedTab: .constant(0))
}
