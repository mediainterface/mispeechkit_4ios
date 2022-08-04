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

This is a basic implementation of the miSpeechKit. Further information about the methods can be found here: [IRecognition](https://mediainterface.github.io/mispeechkit_4ios/documentation/mispeechkit/irecognition).

Information about the RecognitionDelegate can be found here: [IRecognitionDelegate](https://mediainterface.github.io/mispeechkit_4ios/documentation/mispeechkit/irecognitiondelegate)

``` swift
import Foundation
import miSpeechKit

public class QuickStart: IRecognitionDelegate {
    
    public func onResult(result: String) {
        print(result)
    }

    public func onError(message: String) {
        print(error)
    }

    public func onStateChanged(newState: SessionState){
        print(newState)
    }
        
    public func initialize() {
        let context = AuthenticationContext(system: "Testsystem", user: "Diktierer", password: "")
        SpeaKING.getRecognition("http://SpeaKINGServer", context: context, delegate: self) { recognition, error in
            if (nil != error) {
                print(error: error!.errorMessage)
            }
            else {
                self.recognition = recognition
                let recognitionContext = RecognitionContext(user: "Diktierer", vocabulary: "Beispielwortschatz")
                self.recognition?.initialize(recognitionContext, completion: { _ in })
            }
        }
    }

    public func start() {
        if nil != self.recognition {
            self.recognition?.start(previousText: "", followingText: "", completion: { success in })
        }
    }

    public func stop() {
        if nil != self.recognition {
            self.recognition?.stop(completion: { success in })
        }
    }

    public func cleanup() {
        if nil != self.recognition {
            self.recognition?.cleanup(completion: { success in })
        }
    }
}    
```

