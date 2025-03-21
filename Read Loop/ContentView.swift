//
//  ContentView.swift
//  Read Loop
//
//  Created by Pieter Yoshua Natanael on 06/08/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var textToRead = ""                // Text to be read by the synthesizer
    @State private var isReading = false             // Track if the reading is ongoing
    @State private var timer: Timer?                 // Timer for looping the speech
    @State private var playbackRate: Float = 0.3     // Playback speed for the speech
    
    let speechSynthesizer = AVSpeechSynthesizer()    // Speech synthesizer instance

    var body: some View {
        VStack {
            // Title

            Text("Read Loop")
                .font(.largeTitle.bold())
                .padding()

            // Text Editor
            TextEditor(text: $textToRead)
                .font(.largeTitle)
                .font(.title)
                .padding()

            // Start/Stop Button
            HStack {
                Button(action: {
                    if isReading {
                        stopLoop()
                    } else {
                        startLoop()
                    }
                    isReading.toggle()
                }) {
                    Text(isReading ? "Stop" : "Start")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(isReading ? Color.red : Color.purple)
                        .cornerRadius(10)
                }
     
                
                Button(action: {
                    #if os(iOS)
                    textToRead = UIPasteboard.general.string ?? ""
                    #elseif os(macOS)
                    if let clipboardText = NSPasteboard.general.string(forType: .string) {
                        textToRead = clipboardText
                    }
                    #endif
                }) {
                    Image(systemName: "doc.on.clipboard.fill")
//                        .font(.system(size: 15))
                        .foregroundColor(Color.purple)
//                        .padding()
                }

//                Button(action: {
//                                  // Paste functionality
//                                  textToRead = UIPasteboard.general.string ?? ""
//                              }) {
//                                  Image(systemName: "doc.on.clipboard.fill")
//                                      .font(.system(size: 30))
//                                      .foregroundColor(Color.purple)
//                                      .padding()
//                              }
                
                
                Button(action: {
                    textToRead = ""
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.purple)
                }
                         
                              Spacer()
                
                
            }
            
            // Playback Speed Slider
            HStack {
                Text("Speed")
                Slider(value: $playbackRate, in: 0.05...0.6, step: 0.05) {
                    Text("Playback Speed")
                }
                .accentColor(.purple)
                .padding()
                Text(String(format: "%.2fx", playbackRate))
            }
            .padding()
        }
    }

    // Function to speak text
    func speak(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.rate = playbackRate
        speechSynthesizer.speak(speechUtterance)
    }
    
    func startLoop() {
        // Use a while loop to continuously speak until stopped
        DispatchQueue.global(qos: .background).async {
            while self.isReading {
                self.speak(text: self.textToRead)
                
                // Wait until speech is finished before next iteration
                while self.speechSynthesizer.isSpeaking && self.isReading {
                    Thread.sleep(forTimeInterval: 0.1)
                }
            }
        }
    }

    func stopLoop() {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
    
}

    // Function to start the text-to-speech loop
//    func startLoop() {
//        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
//            self.speak(text: self.textToRead)
//        }
//    }
//    
    // Function to stop the text-to-speech loop
//    func stopLoop() {
//        timer?.invalidate()
//        timer = nil
//        speechSynthesizer.stopSpeaking(at: .immediate)
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*
import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var textToRead = ""
    @State private var isReading = false
    @State private var timer: Timer? // Mark timer as @State
    @State private var showAd: Bool = false
    @State private var showExplain: Bool = false
    @State private var playbackRate: Float = 0.3 //speed
    
    let speechSynthesizer = AVSpeechSynthesizer()

    var body: some View {
       
        VStack {
            //AdView button
//            HStack{
//                Button(action: {
//                                    }) {
//                    Image(systemName: "")
//                        .font(.system(size: 30))
////                        .foregroundColor(.white)
//                        .padding()
//                    Spacer()
//                    Button(action: {
//                        showExplain = true
//                    }) {
//                        Image(systemName: "questionmark.circle.fill")
//                            .font(.system(size: 30))
//                            .foregroundColor(Color.purple)
////                            .foregroundColor(.white)
//                            .padding()
//                    }
//                }
//            }

            
            Text("Read Loop")
                .font(.largeTitle.bold())
                .padding()

            TextEditor(text: $textToRead)
                .font(.title)
                .padding()

            Button(action: {
                if isReading {
                    stopLoop()
                } else {
                    startLoop()
                }
                isReading.toggle()
            }) {
                Text(isReading ? "Stop" : "Start")
                    .bold()
                    .frame(maxWidth: .infinity)

                    .padding()
                    .foregroundColor(.white)
                    .background(isReading ? Color.red : Color.purple)
                    .cornerRadius(10)
            }
            
            HStack {
                Text("Speed")
                Slider(value: $playbackRate, in: 0.05...0.6, step: 0.05) {
                    Text("Playback Speed")
                }
                .accentColor(.purple)
                .padding()
                Text(String(format: "%.2fx", playbackRate))
            }
            .padding()
        }
        //ViewAd and other button
//        .sheet(isPresented: $showAd) {
//            ShowAdView(onConfirm: {
//                showAd = false
//            })
//        }
        
//        .sheet(isPresented: $showExplain) {
//            ShowExplainView(onConfirm: {
//                showExplain = false
//            })
//        }
//        .padding()
    }

    func speak(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.rate = playbackRate
        speechSynthesizer.speak(speechUtterance)
    }
    

    func startLoop() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            self.speak(text: self.textToRead) // Explicitly use self here
        }
    }

    func stopLoop() {
        timer?.invalidate()
        timer = nil
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//struct ShowAdView: View {
//   var onConfirm: () -> Void
//
//    var body: some View {
//        ScrollView {
//            VStack {
//                Text("Behind the Scenes.")
//                                    .font(.title)
//                                    .padding()
//                                    .foregroundColor(.white)
//
//                                // Your ad content here...
//
//                                Text("Thank you for buying our app with a one-time fee, it helps us keep up the good work. Explore these helpful apps as well. ")
//                    .font(.title3)
//                                    .foregroundColor(.white)
//                                    .padding(.horizontal)
//                                    .multilineTextAlignment(.center)
//                
//                
//                
//             
//             Text("SingLOOP.")
//                 .font(.title)
// //                           .monospaced()
//                 .padding()
//                 .foregroundColor(.white)
//                 .onTapGesture {
//                     if let url = URL(string: "https://apps.apple.com/id/app/sing-l00p/id6480459464") {
//                         UIApplication.shared.open(url)
//                     }
//                 }
// Text("Record your voice effortlessly, and play it back in a loop.") // Add your 30 character description here
//                    .font(.title3)
////                    .italic()
//                   .multilineTextAlignment(.center)
//                   .padding(.horizontal)
//                   .foregroundColor(.white)
//                
//                Text("Time Tell.")
//                    .font(.title)
////                           .monospaced()
//                    .padding()
//                    .foregroundColor(.white)
//                    .onTapGesture {
//                        if let url = URL(string: "https://apps.apple.com/app/time-tell/id6479016269") {
//                            UIApplication.shared.open(url)
//                        }
//                    }
//  Text("it will announce the time every 30 seconds, no more guessing and checking your watch, for time-sensitive tasks, workouts, and mindfulness exercises.") // Add your 30 character description here
//                      .font(.title3)
////                                 .italic()
//                      .multilineTextAlignment(.center)
//                      .padding(.horizontal)
//                      .foregroundColor(.white)
//                
//             
//                
//                Text("Insomnia Sheep.")
//                    .font(.title)
//     //                           .monospaced()
//                    .padding()
//                    .foregroundColor(.white)
//                    .onTapGesture {
//                        if let url = URL(string: "https://apps.apple.com/id/app/insomnia-sheep/id6479727431") {
//                            UIApplication.shared.open(url)
//                        }
//                    }
//             Text("Design to ease your mind and help you relax leading up to sleep.") // Add your 30 character description here
//                                 .font(.title3)
////                                 .italic()
//                                 .padding(.horizontal)
//                                 .multilineTextAlignment(.center)
//                                 .foregroundColor(.white)
//                           
//                           Text("LoopSpeak.")
//                               .font(.title)
//     //                           .monospaced()
//                               .padding()
//                               .foregroundColor(.white)
//                               .onTapGesture {
//                                   if let url = URL(string: "https://apps.apple.com/id/app/loopspeak/id6473384030") {
//                                       UIApplication.shared.open(url)
//                                   }
//                               }
//             Text("Type or paste your text, play in loop, and enjoy hands-free narration.") // Add your 30 character description here
//                                 .font(.title3)
////                                 .italic()
//                                 .multilineTextAlignment(.center)
//                                 .padding(.horizontal)
//                                 .foregroundColor(.white)
//                           
//                           Text("iProgramMe.")
//                               .font(.title)
//     //                           .monospaced()
//                               .padding()
//                               .foregroundColor(.white)
//                               .onTapGesture {
//                                   if let url = URL(string: "https://apps.apple.com/id/app/iprogramme/id6470770935") {
//                                       UIApplication.shared.open(url)
//                                   }
//                               }
//             Text("Custom affirmations, schedule notifications, stay inspired daily.") // Add your 30 character description here
//                                 .font(.title3)
////                                 .italic()
//                                 .multilineTextAlignment(.center)
//                                 .padding(.horizontal)
//                                 .foregroundColor(.white)
//                           
//                        
//                      
//                           Text("TemptationTrack.")
//                               .font(.title)
//     //                           .monospaced()
//                               .padding()
//                               .foregroundColor(.white)
//                               .onTapGesture {
//                                   if let url = URL(string: "https://apps.apple.com/id/app/temptationtrack/id6471236988") {
//                                       UIApplication.shared.open(url)
//                                   }
//                               }
//             Text("One button to track milestones, monitor progress, stay motivated.") // Add your 30 character description here
//                                 .font(.title3)
////                                 .italic()
//                                 .multilineTextAlignment(.center)
//                                 .padding(.horizontal)
//                                 .foregroundColor(.white)
//
//
//               Spacer()
//
//               Button("Close") {
//                   // Perform confirmation action
//                   onConfirm()
//               }
//               .font(.title)
//               .padding()
//               .foregroundColor(.black)
//               .background(Color.white)
//               .cornerRadius(25.0)
//               .padding()
//           }
//           .padding()
//           .background(Color(#colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)))
//           .cornerRadius(15.0)
//       .padding()
//        }
//   }
//}
//
//
//// MARK: - App Card View
//struct AppCardView: View {
//    var imageName: String
//    var appName: String
//    var appDescription: String
//    var appURL: String
//    
//    var body: some View {
//        HStack {
//            Image(imageName)
//                .resizable()
//                .scaledToFill()
//                .frame(width: 60, height: 60)
//                .cornerRadius(7)
//            
//            VStack(alignment: .leading) {
//                Text(appName)
//                    .font(.title3)
//                Text(appDescription)
//                    .font(.caption)
//            }
//            .frame(alignment: .leading)
//            
//            Spacer()
//            Button(action: {
//                if let url = URL(string: appURL) {
//                    UIApplication.shared.open(url)
//                }
//            }) {
//                Text("Try")
//                    .font(.headline)
//                    .padding()
//                    .foregroundColor(.white)
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
//        }
//    }
//}
//
//// MARK: - Explain View
//struct ShowExplainView: View {
//    var onConfirm: () -> Void
//
//    var body: some View {
//        ScrollView {
//            VStack {
//               HStack{
//                   Text("Ads & App Functionality")
//                       .font(.title3.bold())
//                   Spacer()
//               }
//                Divider().background(Color.gray)
//              
//                //ads
//                VStack {
//                    HStack {
//                        Text("Ads")
//                            .font(.largeTitle.bold())
//                        Spacer()
//                    }
//                    ZStack {
//                        Image("threedollar")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .cornerRadius(25)
//                            .clipped()
//                            .onTapGesture {
//                                if let url = URL(string: "https://b33.biz/three-dollar/") {
//                                    UIApplication.shared.open(url)
//                                }
//                            }
//                    }
//                    // App Cards
//                    VStack {
//                        
//                        Divider().background(Color.gray)
//                        AppCardView(imageName: "bst", appName: "Blink Screen Time", appDescription: "Using screens can reduce your blink rate to just 6 blinks per minute, leading to dry eyes and eye strain. Our app helps you maintain a healthy blink rate to prevent these issues and keep your eyes comfortable.", appURL: "https://apps.apple.com/id/app/blink-screen-time/id6587551095")
//                        
//                        
//                        Divider().background(Color.gray)
//                        
//                        AppCardView(imageName: "dryeye", appName: "Dry Eye Read", appDescription: "The go-to solution for a comfortable reading experience, by adjusting font size and color to suit your reading experience.", appURL: "https://apps.apple.com/id/app/dry-eye-read/id6474282023")
//                        
//                        Divider().background(Color.gray)
//                        AppCardView(imageName: "sos", appName: "SOS Light", appDescription: "SOS Light is designed to maximize the chances of getting help in emergency situations.", appURL: "https://apps.apple.com/app/s0s-light/id6504213303")
//                        
//                        Divider().background(Color.gray)
//                        AppCardView(imageName: "worry", appName: "Worry Bin", appDescription: "Worry Bin empowers you to take control of your mental well-being.", appURL: "https://apps.apple.com/id/app/worry-bin/id6498626727")
//                        
//                        Divider().background(Color.gray)
//                        AppCardView(imageName: "worth", appName: "Whats your worth?", appDescription: "Designed to help users calculate their life insurance requirements and overall personal net worth.", appURL: "https://apps.apple.com/id/app/whats-your-worth/id6503180257")
//                        
//                        Divider().background(Color.gray)
//                        AppCardView(imageName: "bodycam", appName: "BODYCam", appDescription: "Record videos effortlessly and discreetly.", appURL: "https://apps.apple.com/id/app/b0dycam/id6496689003")
//                        Divider().background(Color.gray)
//                        // Add more AppCardViews here if needed
//                        // App Data
//                     
//                        
//                        AppCardView(imageName: "timetell", appName: "TimeTell", appDescription: "Announce the time every 30 seconds, no more guessing and checking your watch, for time-sensitive tasks.", appURL: "https://apps.apple.com/id/app/loopspeak/id6473384030")
//                        Divider().background(Color.gray)
//                        
//                        AppCardView(imageName: "SingLoop", appName: "Sing LOOP", appDescription: "Record your voice effortlessly, and play it back in a loop.", appURL: "https://apps.apple.com/id/app/sing-l00p/id6480459464")
//                        Divider().background(Color.gray)
//                        
//                        AppCardView(imageName: "angry", appName: "Angry Kid", appDescription: "Guide for parents.Empower your child's emotions. Journal anger, export for parent understanding.", appURL: "https://apps.apple.com/id/app/angry-kid/id6499461061")
//                        Divider().background(Color.gray)
//                        
//                        AppCardView(imageName: "insomnia", appName: "Insomnia Sheep", appDescription: "Design to ease your mind and help you relax leading up to sleep.", appURL: "https://apps.apple.com/id/app/insomnia-sheep/id6479727431")
//                       
//                        Divider().background(Color.gray)
//                        
//                        AppCardView(imageName: "iprogram", appName: "iProgramMe", appDescription: "Custom affirmations, schedule notifications, stay inspired daily.", appURL: "https://apps.apple.com/id/app/iprogramme/id6470770935")
//                        Divider().background(Color.gray)
//                        
//                        AppCardView(imageName: "temptation", appName: "TemptationTrack", appDescription: "One button to track milestones, monitor progress, stay motivated.", appURL: "https://apps.apple.com/id/app/temptationtrack/id6471236988")
//                        Divider().background(Color.gray)
//                    
//                    }
//                    Spacer()
//
//                   
//                   
//                }
////                .padding()
////                .cornerRadius(15.0)
////                .padding()
//                
//                //ads end
//                
//                
//                HStack{
//                    Text("App Functionality")
//                        .font(.title.bold())
//                    Spacer()
//                }
//               
//               Text("""
//               •Type or paste your text
//               •Press the start button to initiate the speech loop
//               •Press stop to stop the speech loop
//               •Use the slider to adjust reading speed.
//               •We do not collect data
//               """)
//               .font(.title3)
//               .multilineTextAlignment(.leading)
//               .padding()
//               
//               Spacer()
//                
//                HStack {
//                    Text("LoopSpeak is developed by Three Dollar.")
//                        .font(.title3.bold())
//                    Spacer()
//                }
//
//               Button("Close") {
//                   // Perform confirmation action
//                   onConfirm()
//               }
//               .font(.title)
//               .padding()
//               .cornerRadius(25.0)
//               .padding()
//           }
//           .padding()
//           .cornerRadius(15.0)
//           .padding()
//        }
//    }
//}
#Preview {
    ContentView()
}
*/
