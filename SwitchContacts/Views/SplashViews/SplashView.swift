import SwiftUI

struct SplashView: View
{
    @State private var offset: CGFloat = 0
    @State private var showMainView = false
    @State private var logoScale: CGFloat = 1
    @State private var textOpacity: Double = 0
    
    var body: some View
    {
        ZStack
        {
            if showMainView
            {
                ContentView()
                    .transition(.move(edge: .trailing))
            }
            else
            {
                ZStack
                {
                    Color.colors.SplashBackgroundColor
                        .ignoresSafeArea()
                    
                    VStack(spacing: 40)
                    {
                        Spacer()
                            .frame(height: 60)
                        
                        Image("phoneImagePng")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .scaleEffect(logoScale)
                            .onAppear
                            {
                                withAnimation(.easeInOut(duration: 2).repeatForever())
                                {
                                    logoScale = 1.1
                                }
                                withAnimation(.easeIn(duration: 1))
                                {
                                    textOpacity = 1
                                }
                            }
                        
                        VStack(spacing: 25)
                        {
                            Text("Switch Contacts'a\nHoşgeldiniz")
                                .foregroundColor(Color.colors.SplashTextColor)
                                .font(.system(size: 32, weight: .bold))
                                .multilineTextAlignment(.center)
                                .opacity(textOpacity)
                            
                            VStack
                            {
                                Text("Telefon rehberinizi")
                                    .foregroundColor(Color.colors.SplashTextColor)
                                    .font(.system(size: 22))
                                
                                Text("Android cihazınıza aktarmanın\nen kolay yolu.")
                                    .foregroundColor(Color.colors.SplashTextColor)
                                    .font(.system(size: 22))
                                    .multilineTextAlignment(.center)
                            }
                            .opacity(textOpacity)
                        }
                        .padding(.horizontal, 30)
                        
                        Spacer()
                        
                        VStack(spacing: 15)
                        {
                            Image(systemName: "chevron.up")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color.colors.SplashTextColor)
                                .opacity(0.8)
                                .offset(y: offset == 0 ? 5 : 0)
                                .animation(
                                    Animation.easeInOut(duration: 1.2)
                                        .repeatForever(autoreverses: true),
                                    value: offset
                                )
                            
                            Text("Başlamak için yukarı kaydırın")
                                .foregroundColor(Color.colors.SplashTextColor)
                                .font(.system(size: 18))
                        }
                        .padding(.bottom, 40)
                    }
                    .offset(y: offset)
                    .gesture(
                        DragGesture()
                            .onChanged
                            {
                                gesture in
                                if gesture.translation.height < 0
                                {
                                    offset = gesture.translation.height
                                }
                            }
                            .onEnded
                            {
                                gesture in
                                if gesture.translation.height < -100
                                {
                                    withAnimation(.spring())
                                    {
                                        showMainView = true
                                    }
                                }
                                else
                                {
                                    withAnimation(.spring())
                                    {
                                        offset = 0
                                    }
                                }
                            }
                    )
                }
                .animation(.spring(), value: offset)
            }
        }
        .animation(.easeInOut, value: showMainView)
    }
}

#Preview
{
    SplashView()
}
