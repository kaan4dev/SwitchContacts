import SwiftUI

struct ImportView: View
{
    @Binding var showingSteps: Bool
    @State private var showAdvancedImportView = false

    var body: some View
    {
        VStack(spacing: 90)
        {
            Button
            {
                showAdvancedImportView = true
            }
            label:
            {
                VStack
                {
                    Image(systemName: "square.and.arrow.down")
                        .resizable()
                        .frame(width: 75, height: 100)
                        .imageScale(.large)
                        .foregroundColor(Color.colors.MainTextColor)

                    Text("İçe Aktar")
                        .imageScale(.large)
                        .foregroundColor(Color.colors.SecondaryTextColor)
                }
            }

            Button
            {
                showingSteps = true
            }
            label:
            {
                Text("İçe Aktarma Adımları")
                    .imageScale(.large)
                    .foregroundColor(Color.colors.ButtonTextColor)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
            }
            .background(Color.colors.ButtonBackgroundColor)
            .cornerRadius(30)
        }
        .padding()
        .sheet(isPresented: $showAdvancedImportView)
        {
            AdvancedImportView()
        }
    }
}

#Preview
{
    ImportView(showingSteps: .constant(false))
}
