//
//  ViewController.swift
//  DDayAR
//
//  Created by Alvaro Rose on 10/28/18.
//  Copyright © 2018 Alvaro Rose. All rights reserved.
//

import simd
import ARKit
import Foundation
import SceneKit

public let power: Float = 50.0

extension ARFrame.WorldMappingStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notAvailable:
            return "Not Available"
        case .limited:
            return "Limited"
        case .extending:
            return "Extending"
        case .mapped:
            return "Mapped"
        }
    }
}

public func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

extension float3: Codable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let x = try values.decode(Float.self, forKey: .x)
        let y = try values.decode(Float.self, forKey: .y)
        let z = try values.decode(Float.self, forKey: .z)
        self.init(x, y, z)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
        try container.encode(z, forKey: .z)
    }
    
    private enum CodingKeys: String, CodingKey {
        case x,y,z
    }
}

extension float4: Codable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let x = try values.decode(Float.self, forKey: .x)
        let y = try values.decode(Float.self, forKey: .y)
        let z = try values.decode(Float.self, forKey: .z)
        let w = try values.decode(Float.self, forKey: .w)
        self.init(x, y, z, w)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
        try container.encode(z, forKey: .z)
        try container.encode(w, forKey: .w)

    }
    
    private enum CodingKeys: String, CodingKey {
        case x,y,z,w
    }
}
extension float4 {
    var xyz: float3 {
        return float3(x, y, z)
    }
}

extension simd_quatf: Codable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let vector = try values.decode(float4.self, forKey: .vector)
        self.init(vector: vector)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(vector, forKey: .vector)
    }
    
    private enum CodingKeys: String, CodingKey {
        case vector
    }
}

extension float4x4 {
    var translation: float3 {
        return float3(columns.3.x, columns.3.y, columns.3.z)
    }

    init(translation vector: float3) {
        self.init(float4(1, 0, 0, 0),
                  float4(0, 1, 0, 0),
                  float4(0, 0, 1, 0),
                  float4(vector.x, vector.y, vector.z, 1))
    }
}

extension SCNNode {
    convenience init(position: float3, orientation: simd_quatf, velocity: float3, angularVelocity: float4) {
        self.init(geometry: SCNSphere(radius: 0.1))
        self.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        self.position = SCNVector3(position.x, position.y, position.z)
        
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: self, options: nil))
        body.isAffectedByGravity = false
        self.physicsBody = body
        
        self.physicsBody?.applyForce(SCNVector3(orientation.vector.x * power, orientation.vector.y * power, orientation.vector.z * power), asImpulse: true)
    }
    
    convenience init(orientation: SCNVector3, position: SCNVector3, loaction: SCNVector3) {
        self.init(geometry: SCNSphere(radius: 0.1))
        self.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        self.position = position
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: self, options: nil))
        body.isAffectedByGravity = false
        self.physicsBody = body
        self.physicsBody?.applyForce(SCNVector3(orientation.x * power, orientation.y * power, orientation.z * power), asImpulse: true)
    }
}

extension SCNPhysicsBody {
    var simdVelocity: float3 {
        get { return float3(velocity) }
        set { velocity = SCNVector3(newValue) }
    }
    
    var simdAngularVelocity: float4 {
        get { return float4(angularVelocity) }
        set { angularVelocity = SCNVector4(newValue) }
    }
    
    var simdVelocityFactor: float3 {
        get { return float3(velocityFactor) }
        set { velocityFactor = SCNVector3(newValue) }
    }
    
    var simdAngularVelocityFactor: float3 {
        get { return float3(angularVelocityFactor) }
        set { angularVelocityFactor = SCNVector3(newValue) }
    }
    
    func applyForce(_ force: float3, asImpulse impulse: Bool) {
        applyForce(SCNVector3(force), asImpulse: impulse)
    }
    
    func applyTorque(_ torque: float4, asImpulse impulse: Bool) {
        applyTorque(SCNVector4(torque), asImpulse: impulse)
    }
}


