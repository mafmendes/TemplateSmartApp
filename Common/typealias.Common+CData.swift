import Foundation

public struct CommonCoreDataNameSpace {
    private init() { }
    public struct FRP { private init() { } }
    public struct NonFRP { private init() { } }
}

//
// NON Function Reactive Programing (FRP) Version
//

public typealias Common_NonFRPCDataStore = CommonCoreDataNameSpace.NonFRP.CDataStoreManager

//
// Function Reactive Programing (FRP) Version
//

public typealias Common_FRPCDataStore         = CommonCoreDataNameSpace.FRP.CDataStoreManager
public typealias Common_FRPCDataStoreProtocol = CDataFRPComposedProtocol // Composition of Create, Fetch, Delete and Save Protocols

//
// Sugar protocol extensions

public typealias Common_CoreDataSugarProtocol = CDataComposedProtocols

// Map CDataProject to SmartProject
public typealias RJSCDataNameSpace = CommonCoreDataNameSpace
