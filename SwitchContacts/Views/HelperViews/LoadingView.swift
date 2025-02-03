import SwiftUI

struct LoadingView: View
{
    var body: some View
    {
        Color.black.opacity(0.3)
            .ignoresSafeArea()
        ProgressView()
            .scaleEffect(1.5)
            .progressViewStyle(CircularProgressViewStyle(tint: Color.colors.MainTextColor))
    }
}

#Preview {
    LoadingView()
}
