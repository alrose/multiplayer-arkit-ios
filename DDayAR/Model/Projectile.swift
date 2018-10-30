//
//  Projectile.swift
//  DDayAR
//
//  Created by Alvaro Rose on 10/28/18.
//  Copyright © 2018 Alvaro Rose. All rights reserved.
//

import Foundation
import simd
import SceneKit

class Projectile: NSObject, Codable {
        
    var position: float3
    var orientation: simd_quatf
    var velocity = float3()
    var angularVelocity = float4()
    
    init(node: SCNNode) {
        self.position = node.presentation.simdWorldPosition
        self.orientation = node.presentation.simdOrientation
        
        if let physicsBody = node.physicsBody {
            velocity = physicsBody.simdVelocity
            angularVelocity = physicsBody.simdAngularVelocity
        }
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            //let encodedPosition = try encoder.encode(position)
            try container.encode(position, forKey: CodingKeys.position)
            try container.encode(orientation, forKey: CodingKeys.orientation)
            try container.encode(velocity, forKey: CodingKeys.velocity)
            try container.encode(angularVelocity, forKey: CodingKeys.angularVelocity)
        } catch {
            print(error)
        }
    }
    
    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let position = try values.decode(float3.self, forKey: .position)
        let orientation = try values.decode(simd_quatf.self, forKey: .orientation)
        let velocity = try values.decode(float3.self, forKey: .velocity)
        let angularVelocity = try values.decode(float4.self, forKey: .angularVelocity)
        let node = SCNNode(position: position, orientation: orientation, velocity: velocity, angularVelocity: angularVelocity)
        
        self.init(node: node)
    }
//
//    func encode(with aCoder: NSCoder) {
//        do {
//            let encodedPosition = try aCoder.encode(position)
//            aCoder.encode(position, forKey: CodingKeys.position.rawValue)
//            aCoder.encode(orientation, forKey: CodingKeys.orientation.rawValue)
//            aCoder.encode(velocity, forKey: CodingKeys.velocity.rawValue)
//            aCoder.encode(angularVelocity, forKey: CodingKeys.angularVelocity.rawValue)
//        } catch {
//            print(error)
//        }
//    }
    
//    required convenience init?(coder aDecoder: NSCoder) {
//        guard let position = aDecoder.decodeObject(forKey: CodingKeys.position.rawValue) as? float3 else {return nil}
//        guard let orientation = aDecoder.decodeObject(forKey: CodingKeys.orientation.rawValue) as? simd_quatf else {return nil}
//        guard let velocity = aDecoder.decodeObject(forKey: CodingKeys.velocity.rawValue) as? float3 else {return nil}
//        guard let angularVelocity = aDecoder.decodeObject(forKey: CodingKeys.angularVelocity.rawValue) as? float4 else {return nil}
//
//        let node = SCNNode(position: position, orientation: orientation, velocity: velocity, angularVelocity: angularVelocity)
//
//        self.init(node: node)
//    }
    
    enum CodingKeys: String, CodingKey {
        case position
        case orientation
        case velocity
        case angularVelocity
    }
    
}
