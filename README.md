# ``miSpeechKit``

miSpeechKit helps you to use speech recognition in your application.


## Overview

miSpeechKit is intended to provide easy access to SpeaKING functions for integrators. The focus is on the "developer experience". The Framwork should have a functional scope that is as simple and logical as possible. It should be easy to switch from and to other SDKs of the mi (e.g. .net SDK or Web SDK).

## Installation

In order to be able to use it within an application, it is necessary to insert the delivered SDK in the project settings under "Frameworks, Libraries and Embedded Content" and to import "miSpeechKit" in the respective classes.

After importing the Framework, the functionalities described in the next chapters are available.

### Getting started

After adding the Framework to your project you can start using it in your application.

#### Quickstart

This is a basic implementation of the miSpeechKit. Further information about the methods can be found here: ``IRecognition``.

Information about the RecognitionDelegate can be found here: ``IRecognitionDelegate``

``` swift
import Foundation
import miSpeechKit

public class QuickStart: IRecognitionDelegate {
    
    public func onResult(result: ResultChangedEventArgs) {
        print(result)
    }

    public func onError(message: String) {
        print(error)
    }

    public func onStateChanged(e: StateChangedEventArgs){
        print(e.state)
    }
        
    public func initialize() async throws {
        let context = try MISpeech.createAuthenticationContext(user: username, password: password)
        let recognitionContext = try MISpeech.createRecognitionContext(user: "Test")

        self.recognition = try await MISpeech.createRecognitionAsync(server: nil, context: context)

        self.recognition?.stateChanged.addHandler(handler: onStateChanged)
        self.recognition?.resultChanged.addHandler(handler: onResult)
        self.recognition?.errorOccured.addHandler(handler: onError)

        try await self.recognition?.initializeAsync(recognitionContext)
    }

    public func start() {
        try await self.recognition!.startAsync(previousText: "", followingText: "")
    }

    public func stop() {
        try await self.recognition!.stopAsync()
    }

    public func cleanup() {
        try await self.recognition!.cleanupAsync()
    }
}    
```
