//
//  HelpPageView.swift
//  PlopIt
//
//  Created by Max Fritzhand on 1/20/22.
//

/*

Abstract:
Help and tutorial views.
*/
import SwiftUI

/// This method implements a tabbed tutorial view that the app displays when the user presses the help button.
struct HelpPageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            
         
            //background color of that being black
            Color(red: 0, green: 0, blue: 0.01, opacity: 1.0)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
         
                TabView {
                    ObjectHelpPageView()
                    PhotographyHelpPageView()
                    EnvironmentHelpPageView()
                }
                .tabViewStyle(PageTabViewStyle())
            VStack{
                HStack{
                    Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .padding(20)
                        //.background(Color.white.cornerRadius(10))
                })
                }
                Spacer()
                Spacer()
            }
            
        }
        .navigationTitle("Scanning Info")
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TutorialPageView: View {
    let pageName: String
    let imageName: String
    let imageCaption: String
    let pros: [String]
    let cons: [String]
    
    var body: some View {
        
        GeometryReader { geomReader in
            
          
            VStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 0.9 * geomReader.size.width)
                
                Text(imageCaption)
                    .foregroundColor(.white)
                    .padding(.bottom)
                    // Pad the view a total of 25% (12.5% on each side).
                    .padding(.horizontal, geomReader.size.width / 12.5)
                    .multilineTextAlignment(.center)
                
                //Add color to divider .. give it a white
                Divider()
                
                ProConListView(pros: pros, cons: cons)
                    .padding()
                
                
                Spacer()
            }
            .frame(width: geomReader.size.width, height: geomReader.size.height)
        }
        .navigationBarTitle(pageName, displayMode: .inline)
        
        //Add nav bar here  ^^^ have X button here and use state change from camera view
        
    }
}

struct ObjectHelpPageView: View {
    var body: some View {
        TutorialPageView(pageName: "Object Characteristics",
                         imageName: "ObjectCharacteristicsTips",
                         imageCaption: "Opaque, matte objects with varied surface textures scan best."
                            + "  Capture all sides of your food dish in a series of orbits.\n",
                         pros: ["Varied Surface Texture",
                                "Non-reflective, matte surface",
                                "Solid, opaque" ],
                         cons: ["Uniform Surface Texture",
                                "Shiny",
                                "Transparent, transluscent",
                                "Thin structures"])
    }
}

struct PhotographyHelpPageView: View {
    var body: some View {
        TutorialPageView(pageName: "Photography Tips",
                         imageName: "PhotographyTips",
                         imageCaption: "Adjacent shots should have 70% overlap or more for alignment."
                            + "  Each food dish will need a different number of photos, but aim for between 20-200.",
                         pros: ["Capture all sides of an object",
                                "Capture between 20-200 images",
                                "70%+ overlap between photos",
                                "Consistent focus and image quality" ],
                         cons: ["Parts of object out of frame",
                                "Inconsistent camera settings"])
    }
}

struct EnvironmentHelpPageView: View {
    var body: some View {
        TutorialPageView(pageName: "Environment Characteristics",
                         imageName: "EnvironmentTips",
                         imageCaption: "Make sure you have even, good lighting and a stable environment for scanning."
                            + "  If scanning outdoors, cloudy days work best.\n",
                         pros: ["Diffuse lighting \u{2601}",
                                "Space around intended object" ],
                         cons: ["Sunny, directional lighting",
                                "Inconsistent shadows"])
    }
}

struct ProConListView: View {
    let pros: [String]
    let cons: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(pros, id: \.self) { pro in
                PositiveLabel(pro)
            }
            PositiveLabel("HIDDEN SPACER").hidden()
            ForEach(cons, id: \.self) { con in
                NegativeLabel(con)
            }
        }
    }
}

/// This label uses the `.secondary` color for its text and has a green checkmark icon. It's used to
/// denote good capture practices.
struct PositiveLabel: View {
    let text: String
    
    init(_ text: String) { self.text = text }
    
    var body: some View {
        Group {
            Label(title: {
                Text(text)
                    .foregroundColor(.white)
            }, icon: {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(Color.green)
            })
        }
    }
}

/// This label uses the `.secondary` color for its text and has a red X icon. It's used to denote bad
/// capture practices.
struct NegativeLabel: View {
    let text: String
    
    init(_ text: String) { self.text = text }
    
    var body: some View {
        Group {
            Label(title: {
                Text(text)
                    .foregroundColor(.white)
            }, icon: {
                Image(systemName: "xmark.circle")
                    .foregroundColor(Color.red)
            })
        }
    }
}

#if DEBUG
struct HelpPageView_Previews: PreviewProvider {
    static var previews: some View {
        HelpPageView()
    }
}
#endif // DEBUG
