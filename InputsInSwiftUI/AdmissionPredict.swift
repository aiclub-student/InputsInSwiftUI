//
//  AdmissionPredict.swift in InputsInSwiftUI
//
//  Created by Amit Gupta on 8/21/22.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct AdmissionPredict: View {
    @State var prediction: String = "I don't know yet"
    
    @State var params: Parameters = [:]
    @State var greScore: Float = 315
    @State var toeflScore: Float = 106
    @State var universityRating: Int = 3
    @State var sopValue: Int = 3
    @State var lorValue: Int = 3
    @State var cgpaValue: Float = 8.36
    @State var researchValue: Int = 1
    
    @State var regionChoice = "East"
    
    let minCgpa=6.0, maxCgpa=10.0, minGre=290, maxGre=340, minToefl=90, maxToefl=120
    
    let regions = [
        "East":"Eastern",
        "West":"Western",
        "North":"To North",
        "South":"To South"
    ]
    
    let uploadURL = "https://4c9kil1hsi.execute-api.us-east-1.amazonaws.com/Predict/448d1e79-95c2-4535-bada-41843c7d7279"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Inputs")) {
                    VStack {
                        HStack {
                            Image(systemName: "minus")
                            Slider(value: $greScore.onChange(predictAI), in: 290...340)
                            Image(systemName: "plus")
                        }.foregroundColor(Color.green)
                        Text("GRE Score: \(greScore, specifier: "%.0f")")
                    }
                    VStack {
                        HStack {
                            Image(systemName: "minus")
                            Slider(value: $toeflScore.onChange(predictAI), in: 90...120)
                            Image(systemName: "plus")
                        }.foregroundColor(Color.green)
                        Text("TOEFL Score: \(toeflScore, specifier: "%.0f")")
                    }
                    VStack {
                        HStack {
                            Image(systemName: "minus")
                            Slider(value: $cgpaValue.onChange(predictAI), in: 6...10)
                            Image(systemName: "plus")
                        }.foregroundColor(Color.green)
                        Text("CGPA: \(cgpaValue, specifier: "%.2f")")
                    }
                    Stepper(value: $universityRating.onChange(predictAI), in: 1...5) {
                        Text("University Rating: \(self.universityRating)")
                    }
                    Stepper(value: $sopValue.onChange(predictAI), in: 1...5){
                        Text("SOP: \(self.sopValue)")
                    }
                    Stepper(value: $lorValue.onChange(predictAI), in: 1...5) {
                        Text("LOR: \(self.lorValue)")
                    }
                    Stepper(value: $researchValue.onChange(predictAI), in: 0...1) {
                        Text("Research Value: \(self.researchValue)")
                    }
                    Picker("Region", selection: $regionChoice.onChange(predictAI)) {
                        ForEach(regions.sorted(by:>), id: \.key) {
                            Text($1)
                        }
                    }
                    // .pickerStyle(.wheel)
                }.accentColor(Color.green)
                Section {
                    HStack {
                        Text("Prediction:").font(.largeTitle)
                        Spacer()
                        Text(prediction)
                    }
                }
            }.navigationBarTitle(Text("Admit or No Admit"),displayMode: .inline)
        }.onAppear(perform: predictAI)
    }
    
    func predictAI() {
        print("Just got the call to PredictAI()")
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        params["GRE Score"] = String(greScore)
        params["TOEFL Score"] = String(toeflScore)
        params["University Rating"] = String(universityRating)
        params["SOP"] = String(sopValue)
        params["LOR"] = String(lorValue)
        params["CGPA"] = String(cgpaValue)
        params["Research"] = String(researchValue)
        
        debugPrint("Calling the AI service with parameters=",params)
        
        AF.request(uploadURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            
            //debugPrint("AF.Response:",response)
            switch response.result {
            case .success(let value):
                var json = JSON(value)
                //debugPrint("Initial value is ",value)
                //debugPrint("Initial JSON is ",json)
                let body = json["body"].stringValue
                //debugPrint("Initial Body is ",body)
                json = JSON.init(parseJSON: body)
                debugPrint("Second JSON is ",json)
                let predictedLabel = json["predicted_label"].stringValue
                //debugPrint("Predicted label equals",predictedLabel)
                let s = (Float(predictedLabel) ?? -0.01)*100
                self.prediction=String(format: "%.1f%%", s)
            case .failure(let error):
                print("\n\n Request failed with error: \(error)")
            }
        }
    }
    
    init() {
        
        // UI look-and-feel
        UINavigationBar.appearance().backgroundColor = .yellow
        /*
         UINavigationBar.appearance().titleTextAttributes = [
         .foregroundColor: UIColor.darkGray,
         .font : UIFont(name:"HelveticaNeue", size: 30)!]
         */
    }
}

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}

struct AdmissionPredict_Previews: PreviewProvider {
    static var previews: some View {
        AdmissionPredict()
    }
}
