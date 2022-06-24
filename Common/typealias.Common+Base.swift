//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

public struct CommonNameSpace {
    private init() { }
}

public class Common_Preview {

}

public typealias Common_AppAndDeviceInfo = CommonNameSpace.AppAndDeviceInfo   // Utilities for apps and device info. Things like `isSimulator`, `hasNotch`, etc
public typealias Common_Constants        = CommonNameSpace.Constants          // Util constants like `defaultDelay`, etc
public typealias Common_Logs             = CommonNameSpace.Logger             // Simple logger. Handles verbose, warning and errors
public typealias Common_Utils            = CommonNameSpace.Utils              // Utilities like `onDebug`, `onRelease`, `executeOnce`, etc
public typealias Common_Convert          = CommonNameSpace.Convert            // Types conversion utilities. Things like `isBase64`, `toB64String`, `toBinary`, etc

// MARK: - Utils SwiftUI

public typealias Common_ViewControllerRepresentable = CommonNameSpace.ViewControllerRepresentable
public typealias Common_ViewRepresentable           = CommonNameSpace.ViewRepresentable2

// MARK: - Networking

public typealias Common_NetworMonitor = CommonNameSpace.NetworkUtils.NetworMonitor
public typealias Common_Reachability  = CommonNameSpace.NetworkUtils.Reachability

// MARK: - Cool Stuff

public typealias Common_OperationQueueManager = CommonNameSpace.OperationQueues.OperationQueueManager
public typealias Common_GenericStore          = CommonNameSpace.GenericStore
public typealias Common_Cronometer            = CommonNameSpace.Cronometer         // Utilities class for measure operations time

// MARK: - Property Wrappers

public typealias Common_Defaults       = CommonNameSpace.UserDefaults

// MARK: - Value types

public typealias Common_Result        = CommonNameSpace.Result
public typealias Common_Response      = CommonNameSpace.Response
public typealias Common_CacheStrategy = CommonNameSpace.CacheStrategy
public typealias Common_ColorScheme   = CommonNameSpace.ColorScheme // Ligth | Dark -> RENAME to InterfaceStyle

public typealias App_ShadowStrength = FilterStrength
public typealias App_FadeType       = FilterStrength
public typealias App_FilterStrength = FilterStrength

public typealias Common_ImageSFSymbol = ImageSFSymbol 

public typealias GenericObservableObjectForHashable = CommonNameSpace.GenericObservableObjectForHashable
public typealias GenericChangesPublisher            = CommonNameSpace.GenericChangesPublisher
