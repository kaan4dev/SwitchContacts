import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Switch Contacts")
                    .font(.title)
                    .foregroundColor(Color("MainTextColor"))
                
                Image(systemName: "point.topright.arrow.triangle.backward.to.point.bottomleft.scurvepath.fill")
                    .imageScale(.large)
                    .foregroundColor(Color("SecondaryTextColor"))
                
                Spacer()
                
                VStack(spacing: 90) {
                    Button {
                        // Action for "Dönüştür"
                    } label: {
                        VStack {
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .frame(width: 75, height: 100)
                                .imageScale(.large)
                                .foregroundColor(Color("MainTextColor"))
                            
                            Text("Dönüştür")
                                .imageScale(.large)
                                .foregroundColor(Color("SecondaryTextColor"))
                        }
                    }
                    
                    Button {
                        // Action for "Aktarma Adımları"
                    } label: {
                        Text("Aktarma Adımları")
                            .imageScale(.large)
                            .foregroundColor(Color("SecondaryTextColor"))
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
}