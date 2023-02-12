//
//  ReviewPhotos.swift
//  PlopIt
//
//  Created by Max Fritzhand on 3/18/22.
//

import SwiftUI

struct ReviewPhotos: View {
    
    private let columnSpacing: CGFloat = 3
    /// This array defines the vertical layout for portrait orientation.
    let portraitLayout: [GridItem] = [ GridItem(.flexible())]
    //@Binding var zoomedCapture: CaptureInfo?
    
    /// This is the data model the capture session uses.
    @ObservedObject var model: CameraViewModel
    
    /// This property holds the folder the user is currently viewing.
    @ObservedObject private var captureFolderState: CaptureFolderState
    
    @State var zoomedCapture: CaptureInfo? = nil
    
    
    
    
    
    let usingCurrentCaptureFolder: Bool
    
    /// This initializer creates a capture gallery view for the active capture session.
    init(model: CameraViewModel) {
        self.model = model
        self.captureFolderState = model.captureFolderState!
        usingCurrentCaptureFolder = true
    }
    
    /// This initializer creates a capture gallery view for a previously created capture folder.
    init(model: CameraViewModel, observing captureFolderState: CaptureFolderState) {
        self.model = model
        self.captureFolderState = captureFolderState
        usingCurrentCaptureFolder = (model.captureFolderState?.captureDir?.lastPathComponent
                                     == captureFolderState.captureDir?.lastPathComponent)
    }
        
    var body: some View {
        NavigationView{
            ZStack{
                Color.white
                    .ignoresSafeArea()
                VStack{
                    
                    if zoomedCapture != nil {
                        VStack {
                            FullSizeImageView(captureInfo: zoomedCapture!, model: model)
                                .onTapGesture{
                                    zoomedCapture = nil

                                }
//                                .onReceive(zoomedCapture!) { _ in
//                                    self.zoomedCapture!
//                                             }
                            
                                  
                        }
                        
                        HStack {
                            
                            Button(action: {
                                captureFolderState.removeCapture(captureInfo: zoomedCapture!,
                                                                 deleteData: true)
                                zoomedCapture = nil
                            }) {
                                
                                
                                ZStack{
                                    
                                    Image(systemName:"circle.fill")
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 45))
                                        .padding(.bottom, 35)
                                    Image(systemName:"trash")
                                        .foregroundColor(Color.black)
                                        .font(.system(size: 25))
                                        .padding(.bottom, 35)
                                }
                            }.padding()
                            Spacer()
                        }
                    }
                    
                    
                    
                    
                    
                    Spacer()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(captureFolderState.captures, id: \.id) { captureInfo in
                                
                                GeometryReader { geometryReader in
                                    
                                    GalleryCell(captureInfo: captureInfo,
                                                cellWidth: 120,
                                                cellHeight: 180,
                                                zoomedCapture: $zoomedCapture)
                                        .onTapGesture(count: 10, perform: {
                                                    zoomedCapture = zoomedCapture!
                                                    
                                                })
                                    
                                }
                               
                            
                            }
                            
                            .frame(width: 88, height: 180)
                            .padding(.horizontal)
                            
                        }
                    }
                    .background(.white)
                    
                    HStack{
                        
                        Button(action:  {
                            //move back
                            
//                            if zoomedCapture != nil {
//
//                        FullSizeImageView(captureInfo: zoomedCapture!)
//                        }
                            
                            
                        }, label : {
                            
                            Image(systemName: "chevron.backward")
                                .foregroundColor(Color.black)
                                .font(.system(size: 25))
                                .padding(.trailing, 20)
                        })
                        
                        
                        Button(action:  {
                            
                            //move forward
                            
                            
                        }, label : {
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.black)
                                .font(.system(size: 25))
                                .padding(.leading, 20)
                        })
                        
                        
                        
                        
                    }
                    
                }
            }
      
        }
        .navigationBarTitle(Text("REVIEW"), displayMode: .inline)
                .background(NavigationConfigurator { nc in
                    nc.navigationBar.barTintColor = .black
                nc.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
       
        })
     .navigationViewStyle(StackNavigationViewStyle())
    }
}
struct NavigationConfigurator: UIViewControllerRepresentable {
    
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}

//struct ReviewPhotos_Previews: PreviewProvider {
//    static var previews: some View {
//        ReviewPhotos()
//    }
//}
