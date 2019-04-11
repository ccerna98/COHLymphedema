//
//  ExerciseGuideViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/12/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit
import CoreBluetooth

class ExerciseGuideViewController: UIViewController {
    
    var deg = Double()
    var up = true
    let delay: Double = 50
    var step: Double = 0
    let stepMax: Double = 250
    
    // global variables
    var colorTheme: UIColor!
    var exerciseName: String!
    var exerciseImage: UIImage!
    
    // subviews
    let headerView = Header()
    var activeGraph = SweepGraph()
    
    // construction variables
    private let backButton = UIButton()
//    private let exLabel = UILabel()
    private let exImageView = UIImageView()
    private let instrLabel = UILabel()
    
    // bluetooth variables
    var storingData = false
    
    var timestep = [Float]()
    var q0 = [[Float]]()
    var q1 = [[Float]]()
    var q2 = [[Float]]()
    var q3 = [[Float]]()
    
    private var serviceUUID = CBUUID(string: "2f391f0f-1c30-46fb-a972-a22c2f7570ee")
    private var char0UUID = CBUUID(string: "beb5483e-36e1-4688-b7f5-ea07361b26a8")
    
    let startButton = UIButton()
    
    // for debugging purposes
    let countLabel = UILabel()
    let valueLabel = UILabel()
    
    private var centralManager: CBCentralManager!
    private var wearablePeripheral: CBPeripheral!
    
    private var onVC = true // true if the user is on the current view controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: (self as CBCentralManagerDelegate), queue: nil, options: nil)
        
        setupViews()
        setupConstraints()
        
        // call for placement purposes
//        self.view.layoutIfNeeded()
//        showBorder(view: backButton)
//        showBorder(view: exLabel)
//        showBorder(view: exImageView)
//        showBorder(view: instrLabel)
//        showBorder(view: activeGraph)
//        showBorder(view: startButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        onVC = true
        centralManager.scanForPeripherals(withServices: [serviceUUID])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        onVC = false
        if let peripheral = wearablePeripheral {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    // send user back to main exercise view controller if pressed
    @objc func backButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toExerciseVCfromGuideVC", sender: sender)
    }

}

extension ExerciseGuideViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: [serviceUUID])
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        wearablePeripheral = peripheral
        wearablePeripheral.delegate = (self as CBPeripheralDelegate)
        centralManager.stopScan()
        centralManager.connect(wearablePeripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        print(peripheral.name ?? "not detected")
        wearablePeripheral.discoverServices([serviceUUID])
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("\(peripheral.name ?? "Unknown device") disconnected")
        if onVC {
            print("Scanning for peripherals...")
            centralManager.scanForPeripherals(withServices: [serviceUUID])
        }
    }
}

extension ExerciseGuideViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }

        for characteristic in characteristics {
            print(characteristic)

            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if step > stepMax {
            step = 0

            if up && deg >= 150 {
                up = false
            } else if !up && deg <= 0 {
                up = true
            } else {
                if up {
                    deg += 0.06 * stepMax
                } else {
                    deg -= 0.06 * stepMax
                }
            }

            activeGraph.setSweepGraphValue(value: degToRad(deg: deg))

        } else {
            step += delay
        }
        
        switch characteristic.uuid {
        case char0UUID:
            let data = characteristic.value!
            let farr: [Float] = dataToFloats(data: data, numFloats: 17)

            if storingData {
                timestep.append(farr[0])
                q0.append([farr[1], farr[2], farr[3], farr[4]])
                q1.append([farr[5], farr[6], farr[7], farr[8]])
                q2.append([farr[9], farr[10], farr[11], farr[12]])
                q3.append([farr[13], farr[14], farr[15], farr[16]])

                countLabel.text = ""//"number of entries: \(timestep.count)"

                var str0 = ""
                var str1 = ""
                var str2 = ""
                var str3 = ""

                for i in 0..<4 {
                    str0 += "\(String(format: "%.3f", q0.last?[i] ?? Float(i))) "
                    str1 += "\(String(format: "%.3f", q1.last?[i] ?? Float(i))) "
                    str2 += "\(String(format: "%.3f", q2.last?[i] ?? Float(i))) "
                    str3 += "\(String(format: "%.3f", q3.last?[i] ?? Float(i))) "
                }
                valueLabel.text = ""//"timestep: \(String(format: "%.3f", timestep.last ?? 0.001)) \nq0: \(str0) \nq1: \(str1) \nq2: \(str2) \nq3: \(str3)"
            } else {
                countLabel.text = ""//"number of entries: "
                valueLabel.text = ""//"timestep:  \nq0:  \nq1:  \nq2:  \nq3: "
            }
        default:
            break
        }
    }
}

// MARK: button actions
extension ExerciseGuideViewController {
    @objc func startTapped(_ sender: UIButton) {
        if storingData {
            storingData = false
            
            let alert = UIAlertController(title: "Exercise paused", message: "\nSubmit to upload the data from your current session.\nRestart to clear the data from your current session.\nResume to continue where you left off.", preferredStyle: .actionSheet)
            // submit
            alert.addAction(UIAlertAction(title: "Submit", style: .destructive, handler: { [] (_) in
                // if submit, add data, clear local variables, turn off receiving, and toggle button
                // add data

                self.timestep.removeAll()
                self.q0.removeAll()
                self.q1.removeAll()
                self.q2.removeAll()
                self.q3.removeAll()

                let dismissAlert = UIAlertController(title: "Great job!", message: "Data submitted!", preferredStyle: .alert)
                dismissAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { [] (_) in
                    self.toggleStartButton(running: self.storingData)
                }))
                self.present(dismissAlert, animated: true, completion: nil)
            }))
            // restart
            alert.addAction(UIAlertAction(title: "Restart", style: .destructive, handler: { [] (_) in
                // if restart, clear local variables, turn off receiving, and toggle button
                self.timestep.removeAll()
                self.q0.removeAll()
                self.q1.removeAll()
                self.q2.removeAll()
                self.q3.removeAll()

                let dismissAlert = UIAlertController(title: "Success", message: "Data cleared!", preferredStyle: .alert)
                dismissAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { [] (_) in
                    self.toggleStartButton(running: self.storingData)
                }))
                self.present(dismissAlert, animated: true, completion: nil)
            }))
            // if resume, do nothing
            alert.addAction(UIAlertAction(title: "Resume", style: .cancel, handler: { [] (_) in
                self.storingData = true
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            storingData = true
            toggleStartButton(running: storingData)
        }
    }
    
    private func toggleStartButton(running: Bool) {
        if running {
            startButton.setTitle("Exercise running... click to pause", for: .normal)
            startButton.setTitleColor(.white, for: .normal)
            startButton.setButtonFrame(borderWidth: 1.0, borderColor: .clear, cornerRadius: 15, fillColor: hsbShadeTint(color: colorTheme, sat: 0.50))
        } else {
            startButton.setTitle("Click to start exercise", for: .normal)
            startButton.setTitleColor(.white, for: .normal)
            startButton.setButtonFrame(borderWidth: 1.0, borderColor: .clear, cornerRadius: 15, fillColor: UIColor(white: 0, alpha: 0.20))
        }
        self.view.addSubview(startButton)
    }
}

extension ExerciseGuideViewController: ViewConstraintProtocol {
    internal func setupViews() {
        headerView.updateHeader(text: exerciseName, color: colorTheme.hsbSat(0.40), fsize: 30)
        self.view.addSubview(headerView)
        
        backButton.setButtonParams(color: .gray, string: "Back", ftype: "Montserrat-Regular", fsize: 16, align: .center)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        // setup back button
        backButton.setButtonParams(color: .gray, string: "Back", ftype: "Montserrat-Regular", fsize: 16, align: .center)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        // setup exercise label
//        exLabel.setLabelParams(color: .white, string: exerciseName,
//                               ftype: "Montserrat-Regular", fsize: 30, align: .center)
//        self.view.addSubview(exLabel)
        
        // setup image view
        exImageView.frame = .zero
        exImageView.image = exerciseImage
        self.view.addSubview(exImageView)
        
        
        // setup instruction label
        instrLabel.setLabelParams(color: .gray, string: "Instructions: Replace me with a proper description if needed",
                                  ftype: "Montserrat-Regular", fsize: 14, align: .left)
        self.view.addSubview(instrLabel)
        
        // setup button labels
        startButton.setButtonParams(color: .white, string: "Click to start exercise", ftype: "Montserrat-Regular", fsize: 20, align: .center)
        startButton.setButtonFrame(borderWidth: 1.0, borderColor: .clear, cornerRadius: 15, fillColor: UIColor(white: 0, alpha: 0.20))
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        self.view.addSubview(startButton)
        
        // setup graph
        activeGraph.updateSweepGraph(color: colorTheme, start: degToRad(deg: 0), max: degToRad(deg: 150), left: true, value: degToRad(deg: 60))
        self.view.addSubview(activeGraph)
        
        countLabel.setLabelParams(color: .black, string: "-", ftype: "Montserrat-Regular", fsize: 14, align: .left)
        self.view.addSubview(countLabel)
        valueLabel.setLabelParams(color: .black, string: "-", ftype: "Montserrat-Regular", fsize: 14, align: .left)
        self.view.addSubview(valueLabel)
    }
    
    internal func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        // add back button constraints
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        backButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        
        // add exercise label constraints
//        exLabel.translatesAutoresizingMaskIntoConstraints = false
//        exLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 35).isActive = true
//        exLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        exLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
//        exLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20).isActive = true
        
        
        // add exercise image constraints
        exImageView.translatesAutoresizingMaskIntoConstraints = false
        exImageView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        exImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        exImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
//        exImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        exImageView.widthAnchor.constraint(equalTo: exImageView.heightAnchor, multiplier: 16/9).isActive = true
        
        // add instruction label constraints
        instrLabel.translatesAutoresizingMaskIntoConstraints = false
        instrLabel.topAnchor.constraint(equalTo: exImageView.bottomAnchor, constant: 20).isActive = true
        instrLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        instrLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
//        instrLabel.bottomAnchor.constraint(equalTo: exImageView.bottomAnchor, constant: 0).isActive = true
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.topAnchor.constraint(equalTo: instrLabel.bottomAnchor, constant: 20).isActive = true
        startButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        startButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // add graph constraints
        activeGraph.translatesAutoresizingMaskIntoConstraints = false
        activeGraph.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20).isActive = true
        activeGraph.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -70).isActive = true
        activeGraph.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        activeGraph.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.topAnchor.constraint(equalTo: exImageView.topAnchor).isActive = true
        countLabel.leadingAnchor.constraint(equalTo: exImageView.leadingAnchor).isActive = true
        countLabel.trailingAnchor.constraint(equalTo: exImageView.trailingAnchor).isActive = true
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 20).isActive = true
        valueLabel.leadingAnchor.constraint(equalTo: countLabel.leadingAnchor).isActive = true
        valueLabel.trailingAnchor.constraint(equalTo: countLabel.trailingAnchor).isActive = true
    }
}

//            let alert = UIAlertController(title: "Exercise stopped", message: "Resume to continue where you left off.", preferredStyle: .alert)
//            // submit
//            alert.addAction(UIAlertAction(title: "Submit", style: .destructive, handler: { [] (_) in
//                let submitAlert = UIAlertController(title: "Are you sure?", message: "Submitting will upload all of your session data up until now.", preferredStyle: .alert)
//                // if submit, add data, clear local variables, turn off receiving, and toggle button
//                submitAlert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { [] (_) in
//                    self.storingData = false
//                    // add data
//                    // clear local variables
//                    let dismissAlert = UIAlertController(title: "Success", message: "Data submitted!", preferredStyle: .alert)
//                    dismissAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { [] (_) in
//                        self.toggleStartButton(running: self.storingData)
//                    }))
//                    self.present(dismissAlert, animated: true, completion: nil)
//                }))
//                // if resume, do nothing
//                submitAlert.addAction(UIAlertAction(title: "Resume", style: .cancel, handler: nil))
//                self.present(submitAlert, animated: true, completion: nil)
//            }))
//            // restart
//            alert.addAction(UIAlertAction(title: "Restart", style: .destructive, handler: { [] (_) in
//                let restartAlert = UIAlertController(title: "Are you sure?", message: "Restarting will delete all of your session data up until now.", preferredStyle: .alert)
//                // if restart, clear local variables, turn off receiving, and toggle button
//                restartAlert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { [] (_) in
//                    self.storingData = false
//                    // clear local variables
//                    let dismissAlert = UIAlertController(title: "Success", message: "Data cleared!", preferredStyle: .alert)
//                    dismissAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { [] (_) in
//                        self.toggleStartButton(running: self.storingData)
//                    }))
//                    self.present(dismissAlert, animated: true, completion: nil)
//                }))
//                // if resume, do nothing
//                restartAlert.addAction(UIAlertAction(title: "Resume", style: .cancel, handler: nil))
//                self.present(restartAlert, animated: true, completion: nil)
//            }))
//            // if resume, do nothing
//            alert.addAction(UIAlertAction(title: "Resume", style: .cancel, handler: nil))
//            self.present(alert, animated: true, completion: nil)
