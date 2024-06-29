//
//  HealthDataManager.swift
//  test1
//
//  Created by Michelle Hou on 6/28/24.
//

import Foundation
import HealthKit

class HealthDataManager {
    static let shared = HealthDataManager()
    let healthStore = HKHealthStore()

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let allTypes = Set([
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!,
            HKObjectType.quantityType(forIdentifier: .bloodGlucose)!,
            HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!,
            HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!,
            HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!
        ])

        healthStore.requestAuthorization(toShare: nil, read: allTypes, completion: completion)
    }

    func fetchData(for identifier: HKQuantityTypeIdentifier, completion: @escaping ([HKQuantitySample]?, Error?) -> Void) {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: identifier) else {
            completion(nil, NSError(domain: "com.example.HealthDataManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid sample type"]))
            return
        }

        let query = HKSampleQuery(sampleType: sampleType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            completion(samples as? [HKQuantitySample], error)
        }

        healthStore.execute(query)
    }
}
