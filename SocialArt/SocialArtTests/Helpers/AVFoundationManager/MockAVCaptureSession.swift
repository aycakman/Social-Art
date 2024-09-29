//
//  MockAVCaptureSession.swift
//  SocialArtTests
//
//  Created by Ayca Akman on 5.12.2023.
//

@testable import SocialArt
import UIKit
import AVFoundation

final class MockAVCaptureSession: AVCaptureSessionProtocol {

    var invokedInputsGetter = false
    var invokedInputsGetterCount = 0
    var stubbedInputs: [AVCaptureInput]! = []

    var inputs: [AVCaptureInput] {
        invokedInputsGetter = true
        invokedInputsGetterCount += 1
        return stubbedInputs
    }

    var invokedAddInput = false
    var invokedAddInputCount = 0
    var invokedAddInputParameters: (input: AVCaptureInput, Void)?
    var invokedAddInputParametersList = [(input: AVCaptureInput, Void)]()

    func addInput(_ input: AVCaptureInput) {
        invokedAddInput = true
        invokedAddInputCount += 1
        invokedAddInputParameters = (input, ())
        invokedAddInputParametersList.append((input, ()))
    }

    var invokedCanAddInput = false
    var invokedCanAddInputCount = 0
    var invokedCanAddInputParameters: (input: AVCaptureInput, Void)?
    var invokedCanAddInputParametersList = [(input: AVCaptureInput, Void)]()
    var stubbedCanAddInputResult: Bool! = false

    func canAddInput(_ input: AVCaptureInput) -> Bool {
        invokedCanAddInput = true
        invokedCanAddInputCount += 1
        invokedCanAddInputParameters = (input, ())
        invokedCanAddInputParametersList.append((input, ()))
        return stubbedCanAddInputResult
    }

    var invokedAddOutput = false
    var invokedAddOutputCount = 0
    var invokedAddOutputParameters: (output: AVCaptureOutput, Void)?
    var invokedAddOutputParametersList = [(output: AVCaptureOutput, Void)]()

    func addOutput(_ output: AVCaptureOutput) {
        invokedAddOutput = true
        invokedAddOutputCount += 1
        invokedAddOutputParameters = (output, ())
        invokedAddOutputParametersList.append((output, ()))
    }

    var invokedCanAddOutput = false
    var invokedCanAddOutputCount = 0
    var invokedCanAddOutputParameters: (output: AVCaptureOutput, Void)?
    var invokedCanAddOutputParametersList = [(output: AVCaptureOutput, Void)]()
    var stubbedCanAddOutputResult: Bool! = false

    func canAddOutput(_ output: AVCaptureOutput) -> Bool {
        invokedCanAddOutput = true
        invokedCanAddOutputCount += 1
        invokedCanAddOutputParameters = (output, ())
        invokedCanAddOutputParametersList.append((output, ()))
        return stubbedCanAddOutputResult
    }

    var invokedBeginConfiguration = false
    var invokedBeginConfigurationCount = 0

    func beginConfiguration() {
        invokedBeginConfiguration = true
        invokedBeginConfigurationCount += 1
    }

    var invokedRemoveInput = false
    var invokedRemoveInputCount = 0
    var invokedRemoveInputParameters: (input: AVCaptureInput, Void)?
    var invokedRemoveInputParametersList = [(input: AVCaptureInput, Void)]()

    func removeInput(_ input: AVCaptureInput) {
        invokedRemoveInput = true
        invokedRemoveInputCount += 1
        invokedRemoveInputParameters = (input, ())
        invokedRemoveInputParametersList.append((input, ()))
    }

    var invokedCommitConfiguration = false
    var invokedCommitConfigurationCount = 0

    func commitConfiguration() {
        invokedCommitConfiguration = true
        invokedCommitConfigurationCount += 1
    }

    var invokedStartRunning = false
    var invokedStartRunningCount = 0

    func startRunning() {
        invokedStartRunning = true
        invokedStartRunningCount += 1
    }
}
