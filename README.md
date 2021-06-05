# iOS-OSC-Timer

This application is made for Stad-S by Sujin Jung, 2021 SSLI Exhibition.

![IMG_4758](https://user-images.githubusercontent.com/79373845/120902937-14ad1b00-c67e-11eb-9534-3f3067a58da4.jpeg)

## How to build

Open OSC_Timer.xcodeproj.    
If you want to repeat time between 4:00 to 4:20,    
```swift
var count: Int = 240 //60s * 4 = 4:00
var startCount: Int = 240 //60s * 4 = 4:00
var repeatCount: Int = 260 //60s * 4 + 20 = 4:20
```
Connect your any ios devices.    
Build it.

## Settings in iOS

Go to Settings - WiFi - Click information of your WiFi - You can see your IPAddress.

<img src="https://user-images.githubusercontent.com/79373845/118238390-6a553400-b4d3-11eb-8ed0-b94d49cd9416.jpg" width = "350" height = "700">

## Settings in Max/MSP

Set the host by the IPAddress.

<img width="300" alt="Screen Shot 2021-05-14 at 4 50 56 PM" src="https://user-images.githubusercontent.com/79373845/118239316-90c79f00-b4d4-11eb-92f2-6a65a90a0d12.png">

## Run
4:00 ~ 4:20

![OSC_Timer_Simulate mov](https://user-images.githubusercontent.com/79373845/118239864-42ff6680-b4d5-11eb-8a7f-f65088a888be.gif)
