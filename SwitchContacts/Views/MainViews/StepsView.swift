import SwiftUI

struct StepsView: View
{
    var body: some View
    {
        HStack
        {
            Image("googleContactsIcon")
                .resizable()
                .frame(width:100, height: 100)
            Text("Google Kişiler")
        }
    }
} 
#Preview
{
    StepsView()
}
