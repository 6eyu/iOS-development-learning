//
//  StretchyHeaderView.swift
//  StickyHeader
//
//  Created by vliu on 22/2/2022.
//  the code is from https://www.youtube.com/watch?v=PQD6z0bNeHo by Kavsoft

import SwiftUI

struct StretchyHeaderView: View {
    var body: some View {
        Home()
    }
}

struct StretchyHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        StretchyHeaderView()
    }
}

struct Home: View {
    
    // for sticky header view
    @State var time = Timer.publish(every: 0.1, on: .current, in: .tracking).autoconnect()
    @State var show = false
    
    var body: some View {
        ZStack(alignment: .top) {

            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    GeometryReader { g in
                        Color.yellow
                            // fixing the view to the top will give strechy effect...
                            .offset(y: g.frame(in: .global).minY > 0 ? -g.frame(in: .global).minY : 0)
                            // increasing heigh by drag amount
                            .frame(height: g.frame(in: .global).minY > 0 ? UIScreen.main.bounds.height / 2.2 + g.frame(in: .global).minY : UIScreen.main.bounds.height / 2.2)
                            .onReceive(self.time) { _ in
                                
                                // its not a time...
                                // for tracking the image is scrolled out or not...
                                let y = g.frame(in: .global).minY
                                if -y > (UIScreen.main.bounds.height / 2.2) - 50 {
                                    withAnimation {
                                        self.show = true
                                    }
                                } else {
                                    withAnimation {
                                        self.show = false
                                    }
                                }
                            }
                    }
                    // fixing default height
                    .frame(height: UIScreen.main.bounds.height / 2.2)

                    
                    VStack {
                        HStack {
                            Text("New Games We Love")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Text("See All")
                                    .fontWeight(.bold)
                            }
                        }
                        
                        VStack(spacing: 20) {
                            ForEach(data) { i in
                                CardView(data: i)
                            }
                        }
                    }
                    .padding()
                    Spacer()
                }
            }
            
            if self.show {
                TopView()
            }
        }
        .edgesIgnoringSafeArea(.top)

    }
}

struct TopView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    Image(systemName: "app.gift")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.primary)
                    
                    Text("Arcade")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                Text("One Month free, then $4.99/month.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer(minLength: 0)
            
            Button {
                
            } label: {
                Text("Try It Free")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 25)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
        }
        // for non safe area phones padding will be 15...
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top == 0 ? 15 : (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 5)
        .padding(.horizontal)
        .padding(.bottom)
        .background(BlurBackground())
    }

}

struct BlurBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        // for dark mode adoption
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}


struct CardView: View {
    var data: Card
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            data.color
                .frame(width: 90, height: 90)
            VStack(alignment: .leading, spacing: 6) {
                Text(data.title)
                    .fontWeight(.bold)
                
                Text(data.subTitle)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack(spacing: 12) {
                    Button {
                        
                    } label: {
                        Text("GET")
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 25)
                            .background(Color.primary.opacity(0.6))
                            .clipShape(Capsule())
                    }
                    
                    Text("In-App\nPurchases")
                        .font(.caption)
                }

            }
            
            Spacer(minLength: 0)
        }
    }
}

struct Card: Identifiable {
    var id: Int
    var color: Color
    var title: String
    var subTitle: String
}

var data = [
    Card(id: 0, color: .green, title: "Zombie Gunship Survival", subTitle: "Tour the apocalyse"),
    Card(id: 1, color: .gray, title: "Portal", subTitle: "Travel through dimensions"),
    Card(id: 2, color: .blue, title: "Wave Form", subTitle: "Fun enagaing wave game"),
    Card(id: 3, color: .brown, title: "Temple Run", subTitle: "Run for your life"),
    Card(id: 4, color: .cyan, title: "World of Warcraft", subTitle: "Be whoever you want"),
    Card(id: 5, color: .mint, title: "Alto's Adventure", subTitle: "A snowboarding odyssey"),
    Card(id: 6, color: .pink, title: "Space Frog", subTitle: "Jump and have fun"),
    Card(id: 7, color: .purple, title: "Dinosaur Mario", subTitle: "Keep running")
]
