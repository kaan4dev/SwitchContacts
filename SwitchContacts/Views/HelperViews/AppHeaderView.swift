import SwiftUI

struct AppHeaderView: View
{
    @State private var showFeatures = false

    
    var body: some View
    {
        HStack
        {
            Spacer()
            
            VStack
            {
                Text("Switch Contacts")
                    .font(.title)
                    .foregroundColor(Color.colors.MainTextColor)
                
                Image(systemName: "point.topright.arrow.triangle.backward.to.point.bottomleft.scurvepath.fill")
                    .imageScale(.large)
                    .foregroundColor(Color.colors.SecondaryTextColor)
                   
            }
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            
            Spacer()
            
            Button
            {
                showFeatures.toggle()
            }
            label:
            {
                Image(systemName: "wand.and.stars.inverse")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color.colors.SecondaryTextColor)
                    .padding(.trailing, 10)
            }
        }
        .sheet(isPresented: $showFeatures)
        {
            FeaturesView()
        }
               
        Divider()
            .background(Color.colors.MainTextColor)
    }
}

#Preview
{
    AppHeaderView()
}
