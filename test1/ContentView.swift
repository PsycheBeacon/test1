//
//  ContentView.swift
//  test1
//
//  Created by Michelle Hou on 6/28/24.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @State private var steps: [HKQuantitySample] = []
    @State private var error: Error?

    var body: some View {
        NavigationView {
            List(steps, id: \.uuid) { sample in
                VStack(alignment: .leading) {
                    Text("Date: \(sample.startDate)")
                    Text("Steps: \(sample.quantity.doubleValue(for: HKUnit.count()))")
                }
            }
            .navigationTitle("Health Data")
            .onAppear {
                requestHealthData()
            }
        }
    }

    func requestHealthData() {
        HealthDataManager.shared.requestAuthorization { success, error in
            if success {
                fetchStepData()
            } else {
                self.error = error
            }
        }
    }

    func fetchStepData() {
        HealthDataManager.shared.fetchData(for: .stepCount) { samples, error in
            if let samples = samples {
                DispatchQueue.main.async {
                    self.steps = samples
                }
            } else {
                DispatchQueue.main.async {
                    self.error = error
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
