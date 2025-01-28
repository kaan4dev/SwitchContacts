import SwiftUI

struct StepsSplashView: View
{
    @State private var showingExportSteps = false
    @State private var showingImportSteps = false
    
    var body: some View
    {
        VStack
        {
            LogoAndNameView()
            
            Spacer()
            
            HStack
            {
                Button
                {
                    showingExportSteps.toggle()
                }
            label:
                {
                    VStack
                    {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(Color.colors.MainTextColor)
                        
                        Text("Dışa Aktarma Adımları")
                            .foregroundColor(Color.colors.MainTextColor)
                    }
                    .frame(width: 150)
                    .padding(.vertical, 10)
                    .background(Color.colors.ButtonBackgroundColor.opacity(0.2))
                }
                
                
                Button
                {
                    showingImportSteps.toggle()
                }
            label:
                {
                    VStack
                    {
                        Image(systemName: "square.and.arrow.down")
                            .foregroundColor(Color.colors.MainTextColor)
                        
                        
                        Text("İçe Aktarma Adımları")
                            .foregroundColor(Color.colors.MainTextColor)
                        
                    }
                    .frame(width: 150)
                    
                    .padding(.vertical, 10)
                    .background(Color.colors.ButtonBackgroundColor.opacity(0.2))
                }
            }
            
            Spacer()
        }
        .sheet(isPresented: $showingExportSteps)
        {
            ExportStepsSheetView()
        }
        .sheet(isPresented: $showingImportSteps)
        {
            ImportStepsSheetView()
        }

    }
}

#Preview
{
    StepsSplashView()
}
