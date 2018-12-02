//
//  MeasureVC.swift
//  SafeSpace
//
//  Created by Neal Soni on 12/1/18.
//  Copyright © 2018 Neal Soni. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MeasureVC: UIViewController, ARSCNViewDelegate {
    
    // MARK: - Interface Builder Connections
    @IBOutlet var sceneView: ARSCNView!
    
    // Spheres nodes
    var spheres: [SCNNode] = []
    var type: String?
    // Measurement label
    var measurementLabel = UILabel()
    var lineNode: SCNNode?
    // MARK: - Methods
    override func viewDidLoad() {
        
        if (type == nil){
            type = "door"
        }
        print("This vc is of type: \(type!)")
        super.viewDidLoad()
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = sweetBlue
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationItem.title = "Measure a \(self.type!.capitalized)"

        // Creates a background for the label
        measurementLabel.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100)
        
        // Makes the background white
        measurementLabel.backgroundColor = .white
        
        // Sets some default text
        measurementLabel.text = "0 inches"
        
        // Centers the text
        measurementLabel.textAlignment = .center
        
        // Adds the text to the
        view.addSubview(measurementLabel)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Creates a tap handler and then sets it to a constant
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        // Sets the amount of taps needed to trigger the handler
        tapRecognizer.numberOfTapsRequired = 1
        
        // Adds the handler to the scene view
        sceneView.addGestureRecognizer(tapRecognizer)
    }
    
    // Called when tap is detected
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        // Gets the location of the tap and assigns it to a constant
        let location = sender.location(in: sceneView)
        
        // Searches for real world objects such as surfaces and filters out flat surfaces
        let hitTest = sceneView.hitTest(location, types: [ARHitTestResult.ResultType.featurePoint])
        
        // Assigns the most accurate result to a constant if it is non-nil
        guard let result = hitTest.last else { return }
        
        // Converts the matrix_float4x4 to an SCNMatrix4 to be used with SceneKit
        let transform = SCNMatrix4.init(result.worldTransform)
        
        // Creates an SCNVector3 with certain indexes in the matrix
        let vector = SCNVector3Make(transform.m41, transform.m42, transform.m43)
        
        // Makes a new sphere with the created method
        let sphere = newSphere(at: vector)
        
        // Checks if there is at least one sphere in the array
        if let first = spheres.first {
            
            // Adds a second sphere to the array
            spheres.append(sphere)
            measurementLabel.text = "\(sphere.distance(to: first).rounded()) inches"
            if (lineNode != nil){
                lineNode!.removeFromParentNode();
            }
            
            let measureLine = LineNode(from: (spheres.first?.position)!,
                                       to: (spheres.last?.position)!, lineColor: UIColor.orange)
            measureLine.name = "measureLine"
            lineNode = measureLine
            // Add the Node to the scene.
            sceneView.scene.rootNode.addChildNode(measureLine)
            // If more that two are present...
            if spheres.count > 2 {
                
                
                // Iterate through spheres array
                for sphere in spheres {
                    
                    // Remove all spheres
                    sphere.removeFromParentNode()
                }
                
                // Remove extraneous spheres
                spheres = [spheres[2]]
                
            }
            
            
            // If there are no spheres...
        } else {
            // Add the sphere
            spheres.append(sphere)
        }
        
        // Iterate through spheres array
        for sphere in spheres {
            
            // Add all spheres in the array
            self.sceneView.scene.rootNode.addChildNode(sphere)
        }
    }
    
    // Creates measuring endpoints
    func newSphere(at position: SCNVector3) -> SCNNode {
        
        // Creates an SCNSphere with a radius of 0.4
        let sphere = SCNSphere(radius: 0.01)
        
        // Converts the sphere into an SCNNode
        let node = SCNNode(geometry: sphere)
        
        // Positions the node based on the passed in position
        node.position = position
        
        // Creates a material that is recognized by SceneKit
        let material = SCNMaterial()
        
        // Converts the contents of the PNG file into the material
        material.diffuse.contents = UIColor.orange
        
        // Creates realistic shadows around the sphere
        material.lightingModel = .blinn
        
        // Wraps the newly made material around the sphere
        sphere.firstMaterial = material
        
        // Returns the node to the function
        return node
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    @IBAction func cancelPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addPressed(_ sender: AnyObject) {
        
        
        if (type! == "door"){
            NetworkManager.sharedInstance.selectedPlaceDoorWidths?.append((measurementLabel.text! as NSString).floatValue)
            print("added to door: \((measurementLabel.text! as NSString).floatValue)")
            print("\(NetworkManager.sharedInstance.selectedPlaceDoorWidths)")
        }else{
            NetworkManager.sharedInstance.selectedPlaceTableHights?.append((measurementLabel.text! as NSString).floatValue)
            print("added to table: \((measurementLabel.text! as NSString).floatValue)")
            print("\(NetworkManager.sharedInstance.selectedPlaceTableHights)")
        }
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extensions
extension SCNNode {
    
    // Gets distance between two SCNNodes
    func distance(to destination: SCNNode) -> CGFloat {
        
        // Meters to inches conversion
        let inches: Float = 39.3701
        
        // Difference between x-positions
        let dx = destination.position.x - position.x
        
        // Difference between y-positions
        let dy = destination.position.y - position.y
        
        // Difference between z-positions
        let dz = destination.position.z - position.z
        
        // Formula to get meters
        let meters = sqrt(dx*dx + dy*dy + dz*dz)
        
        // Returns inches
        return CGFloat(meters * inches)
    }
}




extension SCNNode {
    static func createLineNode(fromNode: SCNNode, toNode: SCNNode, andColor color: UIColor) -> SCNNode {
        let line = lineFrom(vector: fromNode.position, toVector: toNode.position)
        let lineNode = SCNNode(geometry: line)
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = color
        line.materials = [planeMaterial]
        return lineNode
    }
    
    static func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        return SCNGeometry(sources: [source], elements: [element])
    }
}
class LineNode: SCNNode {
    
    init(from vectorA: SCNVector3, to vectorB: SCNVector3, lineColor color: UIColor) {
        super.init()
        
        let height = self.distance(from: vectorA, to: vectorB)
        
        self.position = vectorA
        let nodeVector2 = SCNNode()
        nodeVector2.position = vectorB
        
        let nodeZAlign = SCNNode()
        nodeZAlign.eulerAngles.x = Float.pi/2
        
        let box = SCNBox(width: 0.003, height: height, length: 0.001, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = color
        box.materials = [material]
        
        let nodeLine = SCNNode(geometry: box)
        nodeLine.position.y = Float(-height/2) + 0.001
        nodeZAlign.addChildNode(nodeLine)
        
        self.addChildNode(nodeZAlign)
        
        self.constraints = [SCNLookAtConstraint(target: nodeVector2)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func distance(from vectorA: SCNVector3, to vectorB: SCNVector3)-> CGFloat {
        return CGFloat (sqrt(
            (vectorA.x - vectorB.x) * (vectorA.x - vectorB.x)
                +   (vectorA.y - vectorB.y) * (vectorA.y - vectorB.y)
                +   (vectorA.z - vectorB.z) * (vectorA.z - vectorB.z)))
    }
    
}
