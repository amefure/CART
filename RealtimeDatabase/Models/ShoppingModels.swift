import SwiftUI

struct ShoppingGroup:Identifiable{
    var id:String
    var name:String
    var list:[ShoppingItem]
}

struct ShoppingItem:Identifiable{
    var id:String
    var name:String
    var shopped:Bool
}

struct Menu{
    var week:[String]
    var memo:String
}
