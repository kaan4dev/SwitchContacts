import SwiftUI

struct StepsSplashView: View
{
    @State private var showingExportSteps = false
    @State private var showingImportSteps = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View
    {
        VStack
        {
            LogoAndNameView()
            
            Spacer()
            
            VStack
            {
                Spacer()
                VStack
                {
                    Text("Lütfen adımlarını detaylıca\ngörmek istediğiniz işlemi seçiniz.")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color.colors.MainTextColor,
                                    Color.colors.SecondaryTextColor
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                        .minimumScaleFactor(0.7)
                    
                    
                    Image(colorScheme == .light ? "stepsSplashBackgroundLight" : "stepsSplashBackgroundDark")
                        .resizable()
                        .frame(width: 250, height: 200)
                        .frame(maxWidth: .infinity)
                        .padding()

                }
                
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
