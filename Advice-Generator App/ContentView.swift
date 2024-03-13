//
//  ContentView.swift
//  Advice-Generator App
//
//  Created by Marcos Fabian Chong Megchun on 12/03/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var advice: AdviceResponse?
    
    
    var body: some View {
        var id = String(advice?.slip.id ?? 117)
        VStack {
            VStack {
                Text("ADVICE #\(id)")
                    .font(.custom("Manrope-ExtraBold", size: 16))
                    .foregroundColor(Color("Neon-Green"))
                    .padding(.bottom, 10)
                    .shadow(color: Color("Neon-Green"), radius: 0)
                Text(advice?.slip.advice ?? "It is easy to sit up and take notice, what´s difficult is getting up and taking action.")
                    .font(.custom("Manrope-ExtraBold", size: 28))
                    .foregroundColor(Color("Light-Cyan"))
                Image("pattern-divider-mobile")
            }
            .padding(20)
            .padding(.bottom, 30)
            .frame(maxWidth: .infinity)
            .background(
                Color("Dark-Grayish-Blue")
            )
            .cornerRadius(10)
            Button(action: {
                Task {
                    advice = try await getAdvice()
                }
            }, label: {
                Image("icon-dice")
                  .resizable()
                  .frame(width: 25, height: 25)
                  .foregroundColor(.white)
                  .padding(20)
                  .background(Color("Neon-Green"))
                  .clipShape(Circle())
                  .offset(y: -40)

            })
        }
        .padding()
        .font(.custom("Manrope-ExtraBold", size: 28))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color("Dark-Blue")
        )
        .ignoresSafeArea()
    }
    
    func getAdvice() async throws -> AdviceResponse {
        let endpoint = "https://api.adviceslip.com/advice"
        guard let url = URL(string: endpoint) else { throw AdviceError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw AdviceError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(AdviceResponse.self, from: data)
        } catch {
            throw AdviceError.invalidData
        }
    }
    
}


struct AdviceResponse: Decodable  {
    let slip: Advice
}

struct Advice: Decodable {
    let id: Int
    let advice: String
}

enum AdviceError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
