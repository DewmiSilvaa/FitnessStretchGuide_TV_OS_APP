import SwiftUI

extension View {
    func customTextFieldStyle() -> some View {
        self
            .padding(10)
            .background(Color.black)
            .foregroundColor(.red)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.red, lineWidth: 2)
            )
            .cornerRadius(8)
    }
    
    func customTextAreaStyle() -> some View {
        self
            .padding(10)
            .background(Color.black)
            .foregroundColor(.red)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.red, lineWidth: 2)
            )
            .cornerRadius(8)
    }
    
    func customButtonStyle(isDisabled: Bool = false) -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding()
            .background(isDisabled ? Color.gray : Color.red.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(10)
            .font(.headline)
    }
}
