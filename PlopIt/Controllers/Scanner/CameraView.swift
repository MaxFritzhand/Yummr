//
//  CameraView.swift
//  PlopIt
//
//  Created by Max Fritzhand on 1/18/22.
//

/*
 
Abstract:
A view that displays the camera image and capture button.
*/
import Foundation
import SwiftUI

/// This is the app's primary view. It contains a preview area, a capture button, and a thumbnail view
/// showing the most recenty captured image.
struct CameraView: View {
    static let buttonBackingOpacity: CGFloat = 0.15
    
    
    @ObservedObject var model: CameraViewModel
    
   // @Binding var count: Int
 
    @State private var showInfo: Bool = false
    
    let aspectRatio: CGFloat = 4.0 / 3.0
    let previewCornerRadius: CGFloat = 15.0
    
    var body: some View {
        
        
        NavigationView {
            GeometryReader { geometryReader in
                // Place the CameraPreviewView at the bottom of the stack.
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all)
                    
                    // Center the preview view vertically. Place a clip frame
                    // around the live preview and round the corners.
                    VStack {
                        Spacer()
                        CameraPreviewView(session: model.session)
                            .frame(width: geometryReader.size.width,
                                   height: geometryReader.size.width * aspectRatio,
                                   alignment: .center)
                            //.clipShape(RoundedRectangle(cornerRadius: previewCornerRadius))
                            .onAppear { model.startSession() }
                            .onDisappear { model.pauseSession() }
                            .overlay(
                                Image("markers")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.all))
                
                            .gesture(DragGesture(minimumDistance: 0).onEnded({ (value) in
                                model.updateFocus(withCoordinate: value)
//                                showFeedback(withCoordinate: value)
                                }))
                            //.overlay(ScanToolbarView())
                        Spacer()
                    }
                    
                    VStack {
                        // The app shows this view when showInfo is true.
                        ScanToolbarView(model: model, showInfo: $showInfo).padding(.horizontal)
                        if showInfo {
                            InfoPanelView(model: model)
                                .padding(.horizontal).padding(.top)
                        }
                        Spacer()
                        CaptureButtonPanelView(model: model, width: geometryReader.size.width)
                    }
                }
            }
            .navigationTitle(Text(""))
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    func showFeedback(withCoordinate: DragGesture.Value) -> UIView {
        let overlayView = UIView(frame: .infinite)
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)

            let path = CGMutablePath()

            path.addRoundedRect(in: CGRect(x: 15, y: overlayView.center.y-100, width: overlayView.frame.width-30, height: 200), cornerWidth: 5, cornerHeight: 5)

            path.closeSubpath()
            
            let shape = CAShapeLayer()
            shape.path = path
            shape.lineWidth = 3.0
            shape.strokeColor = UIColor.blue.cgColor
            shape.fillColor = UIColor.blue.cgColor
            
            overlayView.layer.addSublayer(shape)
            
            path.addRect(CGRect(origin: .zero, size: overlayView.frame.size))

            let maskLayer = CAShapeLayer()
            maskLayer.backgroundColor = UIColor.black.cgColor
            maskLayer.path = path
            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd

            overlayView.layer.mask = maskLayer
            overlayView.clipsToBounds = true
            
            return overlayView
    }
}


/// This view displays the image thumbnail, capture button, and capture mode button.
struct CaptureButtonPanelView: View {
    @ObservedObject var model: CameraViewModel
    
    @State var count: Int = 0
    
    @State var isDisabled = true
    
   // @Binding var count: Int
   
    
    /// This property stores the full width of the bar. The view uses this to place items.
    var width: CGFloat
    
    //change back to 20, once count is fixed
    var condition: Bool { count < 1 }
    
    var body: some View {
        // Add the bottom panel, which contains the thumbnail and capture button.
        ZStack(alignment: .center) {

            HStack {
                //Thumbnail View
                ThumbnailView(model: model)
                    .frame(width: width / 3)
                    .padding(.horizontal)
                   .padding(.top, 10)
                
                Spacer()
            }
            
            VStack{
                //GIVES BACK NUMBER OF PHOTOS. X needs to be replaced with variable linking to associated amount
              //  Text("\(count) Photo(s) Taken")
            HStack {
                Spacer()
                CaptureButton(model: model, count: $count)
                Spacer()
                }
            }
          
            //Done Button
            HStack{
                Spacer()
                
                //are you sure you want to proceed? It is always good to more pictures...
                
                NavigationLink(destination: CaptureGalleryView(model: model)){
                    
 
                    Image(systemName: condition ? "" :  "checkmark"  )
                        .foregroundColor(condition ? .red : .green)
                        .font(.system(size: 20))
                    Text("Done")
                        .foregroundColor(condition ? .white : .black)
                }
                .padding()
                .background(condition ? .gray : .white)
                .cornerRadius(10)
                .disabled(count < 1)
                .padding(.trailing, 30)
                .padding(.top, 10)
                
            }
        
        }
    }
    
  
    
}



/// This is a custom "toolbar" view the app displays at the top of the screen. It includes the current capture
/// status and buttons for help and detailed information. The user can tap the entire top panel to
/// open or close the information panel.
struct ScanToolbarView: View {
    
    @ObservedObject var model: CameraViewModel
    @Binding var showInfo: Bool
    //@State var count: Int = 0
    @State var showHelper = false
    @State var showAlert = false
    
    //@State var alertTitle: String = ""
    
    @State var alertType: MyAlerts? = nil
    
    @State var isAssistanceModeOn: Bool = true
    
    
    var imageURL: Data = Data()
    var url: URL?
    //var condition: Bool { count < 20 }
    
    @Environment(\.uiHostingControllerPresenter) private var uiHostingControllerPresenter
    //
    
    enum MyAlerts{
        case success
        case error
    }
    var body: some View {
        ZStack {
            HStack {
                //Instructions View    --> sheet view
        
                Button(action: {
                               self.showHelper.toggle()
                        }) {
                        Image(systemName: "questionmark.circle")
                                .foregroundColor(Color.white)
                                .font(.system(size: 25))
                    }
                    .sheet(isPresented: $showHelper){
                            HelpPageView()
                    }

               // Spacer()
                
                Button(action: {
                    withAnimation{
                        self.isAssistanceModeOn.toggle()
                        
                        //add assistanceMode function that displays a popup after 30pics and says to switch to angle 1, 2, 3
                        
                        }
                }) {
                    Image(systemName: self.isAssistanceModeOn == true ? "rectangle.on.rectangle.circle" : "rectangle.on.rectangle.slash.circle.fill")
                        .foregroundColor(Color.white)
                        .font(.system(size: 25))
                    
                }
                       
 
                
                
                
                
                
                Button(action: {
                    withAnimation {
                        model.advanceToNextCaptureMode()
                    }
                }, label: {
                    ZStack {
       
                        switch model.captureMode {
                        case .automatic3:
                            Capsule(style: .circular)
                                .frame(width: 60,
                                       height: 25)
                                .foregroundColor(Color.yellow)
                                .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
                            Image(systemName: "timer").foregroundColor(Color.black)
                                .padding(.trailing, 15)
                            Text("  3s").foregroundColor(Color.black)
                                //.font(.system(size: 25))
                                .padding(.leading, 12)
                                .frame(width: 50,
                                       height: 25,
                                       alignment: .trailing)
                        case .automatic2:
                            Capsule(style: .circular)
                                .frame(width: 60,
                                       height: 25)
                                .foregroundColor(Color.yellow)
                                .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
                            Image(systemName: "timer").foregroundColor(Color.black)
                                .padding(.trailing, 15)
                            Text("  2s").foregroundColor(Color.black)
                                //.font(.system(size: 25))
                                .padding(.leading, 12)
                                .frame(width: 50,
                                       height: 25,
                                       alignment: .trailing)
                        case .manual:
                            Circle()
                                .stroke(.white)
                                .frame(width: 30,
                                       height: 25)
                            Image(systemName: "timer").foregroundColor(Color.white)
                                //.font(.system(size: 25))
                                .frame(width: 30,
                                       height: 25,
                                       alignment: .center)
                        }
                    }
                })
                
                
                Spacer()
                
                //Close Button
                Button(action: {
                   

                    print("Pressed Closed!")
                    
                    withAnimation {
                        //uiHostingControllerPresenter?.dismiss()
                        //if images <20 -- then discard data. If >20 and then hit X, have popup modal that asks if they want to discard or 'checkout'.
                      
                        alertType = .error
                        showAlert.toggle()
                        
                         
                    }
                }){
                    Image(systemName: "x.circle")
                        .foregroundColor(Color.white)
                        .font(.system(size: 25))
                }
                .alert(isPresented: $showAlert, content: {
                 
                  getAlert()
                    
                })
            }
            
        }
    }
    
    
    func getAlert() -> Alert {
        
        switch alertType{
        case .error:
            return Alert(
                
                title: Text("End Session"),
                message: Text("Do you want to discard data or continue?"),
                primaryButton: .default(Text("Continue"), action: { showAlert.toggle()}),
                secondaryButton: .destructive(Text("Discard Data"), action: {
                    removeOldSessionDirectories()
                    uiHostingControllerPresenter?.dismiss()
                   }))
        case .success:
            return Alert(
                title:  Text("Unsaved Data!"),
                message: Text("If you would like to save - please select Checkout"),
                primaryButton: .default(Text("Checkout"), action: { uiHostingControllerPresenter?.dismiss()
                           }),
                secondaryButton: .destructive(Text("Discard Data"), action: {
                               removeOldSessionDirectories()
                               uiHostingControllerPresenter?.dismiss()
              }))
        default:
            return Alert(title: Text("ERROR"))
        }
    }
    
    
    
    func getDirctoriesFromURL(url: URL?) -> [URL]? {
        guard let url = url else { return nil }
        var directories = [URL]()
        if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
            for case let fileURL as URL in enumerator {
                do {
                    let fileAttributes = try fileURL.resourceValues(forKeys:[.isDirectoryKey])
                    if fileAttributes.isDirectory! {
                        directories.append(fileURL)
                    }
                   
                } catch { print(error, fileURL) }
            }
            return directories
        }
        return nil
    }
    
    func removeOldSessionDirectories() {
       if let url = self.url {
           let directoryPath = url.deletingLastPathComponent().absoluteString
           guard let newURL = URL(string: directoryPath) else { return }
           let directoriesURL = self.getDirctoriesFromURL(url: newURL)
           if let directoriesURLs = directoriesURL , !directoriesURLs.isEmpty {
               for directoryURL in directoriesURLs {
                   if directoryURL.lastPathComponent != self.url?.lastPathComponent {
                       CaptureFolderState.removeCaptureFolder(folder: directoryURL)
                   }
               }
           }
          
       }
   }
    
    
}
/// This capture button view is modeled after the Camera app button. The view changes shape when the
/// user starts shooting in automatic mode.
struct CaptureButton: View {
    static let outerDiameter: CGFloat = 80
    static let strokeWidth: CGFloat = 4
    static let innerPadding: CGFloat = 10
    static let innerDiameter: CGFloat = CaptureButton.outerDiameter -
        CaptureButton.strokeWidth - CaptureButton.innerPadding
    static let rootTwoOverTwo: CGFloat = CGFloat(2.0.squareRoot() / 2.0)
    static let squareDiameter: CGFloat = CaptureButton.innerDiameter * CaptureButton.rootTwoOverTwo -
        CaptureButton.innerPadding
    
    
    
    //@State var count: Int = 0
    @Binding var count: Int
   
    @ObservedObject var model: CameraViewModel
    
    init(model: CameraViewModel, count: Binding<Int>) {
        self.model = model
        self._count = count
    }
    var condition: Bool { count < 20 }
    var body: some View {
        
        VStack{
            //currently only works for manual
        //Text("\(count) Photo(s) Taken")
          ///      .foregroundColor(condition ? .yellow : .green)
        HStack{
         //   if count > 20{
        Button(action: {
            
            model.captureButtonPressed()
            //Counts photos
            self.count += 1
            
        }, label: {
            if model.isAutoCaptureActive {
                AutoCaptureButtonView(model: model)
            } else {
                ManualCaptureButtonView()
            }
        }).disabled(!model.isCameraAvailable || !model.readyToCapture)
            }
        }
    }
}

/// This is a helper view for the `CaptureButton`. It implements the shape for automatic capture mode.
struct AutoCaptureButtonView: View {
    @ObservedObject var model: CameraViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.red)
                .frame(width: CaptureButton.squareDiameter,
                       height: CaptureButton.squareDiameter,
                       alignment: .center)
                .cornerRadius(5)
            TimerView(model: model, diameter: CaptureButton.outerDiameter)
        }
    }
}

/// This is a helper view for the `CaptureButton`. It implements the shape for manual capture mode.
struct ManualCaptureButtonView: View {
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color.white, lineWidth: CaptureButton.strokeWidth)
                .frame(width: CaptureButton.outerDiameter,
                       height: CaptureButton.outerDiameter,
                       alignment: .center)
            Circle()
                .foregroundColor(Color.white)
                .frame(width: CaptureButton.innerDiameter,
                       height: CaptureButton.innerDiameter,
                       alignment: .center)
        }
    }
}


/// This view shows a thumbnail of the last photo captured, similar to the  iPhone's Camera app. If there isn't
/// a previous photo, this view shows a placeholder.
///
///
struct ThumbnailView: View {
    private let thumbnailFrameWidth: CGFloat = 60.0
    private let thumbnailFrameHeight: CGFloat = 60.0
    private let thumbnailFrameCornerRadius: CGFloat = 10.0
    private let thumbnailStrokeWidth: CGFloat = 2
    
    @ObservedObject var model: CameraViewModel
    
    
    
    
    init(model: CameraViewModel) {
        self.model = model
    }
    
    var body: some View {
        //Change navigation link to be ReviewPhotos
        NavigationLink(destination: ReviewPhotos(model: model)) {
            if let capture = model.lastCapture {
                if let preview = capture.previewUiImage {
                    ThumbnailImageView(uiImage: preview,
                                       width: thumbnailFrameWidth,
                                       height: thumbnailFrameHeight,
                                       cornerRadius: thumbnailFrameCornerRadius,
                                       strokeWidth: thumbnailStrokeWidth)
                } else {
                    // Use full-size if no preview.
                    ThumbnailImageView(uiImage: capture.uiImage,
                                       width: thumbnailFrameWidth,
                                       height: thumbnailFrameHeight,
                                       cornerRadius: thumbnailFrameCornerRadius,
                                       strokeWidth: thumbnailStrokeWidth)
                }
            } else {  // When no image, use icon from the app bundle.
                Image(systemName: "photo.on.rectangle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(16)
                    .frame(width: thumbnailFrameWidth, height: thumbnailFrameHeight)
                    .foregroundColor(.primary)
                    .overlay(
                        RoundedRectangle(cornerRadius: thumbnailFrameCornerRadius)
                            .fill(Color.white)
                            .opacity(Double(CameraView.buttonBackingOpacity))
                            .frame(width: thumbnailFrameWidth,
                                   height: thumbnailFrameWidth,
                                   alignment: .center)
                    )
            }
        }
    }
}

struct ThumbnailImageView: View {
    var uiImage: UIImage
    var thumbnailFrameWidth: CGFloat
    var thumbnailFrameHeight: CGFloat
    var thumbnailFrameCornerRadius: CGFloat
    var thumbnailStrokeWidth: CGFloat
    
    init(uiImage: UIImage, width: CGFloat, height: CGFloat, cornerRadius: CGFloat,
         strokeWidth: CGFloat) {
        self.uiImage = uiImage
        self.thumbnailFrameWidth = width
        self.thumbnailFrameHeight = height
        self.thumbnailFrameCornerRadius = cornerRadius
        self.thumbnailStrokeWidth = strokeWidth
    }
    var body: some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: thumbnailFrameWidth, height: thumbnailFrameHeight)
            .cornerRadius(thumbnailFrameCornerRadius)
            .clipped()
            .overlay(RoundedRectangle(cornerRadius: thumbnailFrameCornerRadius)
                        .stroke(Color.primary, lineWidth: thumbnailStrokeWidth))
            .shadow(radius: 10)
    }
}

//#if DEBUG
//struct CameraView_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraView(model: CameraViewModel())
//    }
//}
//#endif // DEBUG
