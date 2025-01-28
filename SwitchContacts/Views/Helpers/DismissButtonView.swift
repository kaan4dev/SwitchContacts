import SwiftUI

struct DismissButtonView: View
{
    @Environment(\.dismiss) private var dismiss
    
    var body: some View
    {
        Button
        {
            dismiss()
        }
        label:
        {
            Image(systemName: "xmark.circle")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(Color.colors.MainTextColor)
        }
        .padding(.leading, 16)
        Spacer()
    }
}

#Preview
{
    DismissButtonView()
}
