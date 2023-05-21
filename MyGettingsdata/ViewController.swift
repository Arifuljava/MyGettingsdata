//
//  ViewController.swift
//  MyGettingsdata
//
//  Created by sang on 21/5/23.
//

import UIKit
import CoreBluetooth

import SwiftUI
import CoreBluetooth
import UIKit
import CoreGraphics

//idintifier
//60520B00-43C3-55D4-E8C6-A2B64733D833
//pher
//0x2828e40d0


class ViewController: UIViewController ,  CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource{
    
    private var centralManager: CBCentralManager?
          private var discoveredPeripherals: [CBPeripheral] = []
    //cnc
      var manager:CBCentralManager!
      var peripheral:CBPeripheral!

      let BEAN_NAME = "AC695X_1(BLE)"
      var myCharacteristic : CBCharacteristic!
          
          var isMyPeripheralConected = false
    
    
    @IBOutlet weak var tableView: UITableView!
    var coreCenter = CBCentralManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
             tableView.dataSource = self
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
                       tableView.delegate = self
                       tableView.dataSource = self

                // Do any additional setup after loading the view.
                
                manager = CBCentralManager(delegate: self, queue: nil)
        
        
        
    }
    @objc func centralManagerDidUpdateState(_ central: CBCentralManager) {
             if central.state == .poweredOn {
                 if let peripheral = peripheral {
                             if peripheral.state == .connected {
                                 // The peripheral is connected
                                 print("Peripheral is connected.")
                             } else {
                                 // The peripheral is not connected
                                 print("Peripheral is not connected.")
                                 central.scanForPeripherals(withServices: nil, options: nil)
                             }
                         } else {
                             // No peripheral is currently assigned
                             print("No peripheral assigned.")
                             central.scanForPeripherals(withServices: nil, options: nil)
                         }
                 
             } else {
                 print("Bluetooth is not available.")
             }
         }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
               if !discoveredPeripherals.contains(peripheral) {
                  
                   discoveredPeripherals.append(peripheral)
                   tableView.reloadData()
                   
               }
             //  print(mainflagg.description)
               if peripheral.name?.contains("AC695X_1(BLE)") == true {
                  

                           self.peripheral = peripheral
                           self.peripheral.delegate = self

                           manager.connect(peripheral, options: nil)
                   peripheral.delegate = self
                   peripheral.discoverServices(nil)
                
                           print("My  discover peripheral", peripheral)
                   self.manager.stopScan()
   //check pherifiral
                  
                   
                   
                       }
               
               
               
    }
    //
    // MARK: - UITableViewDelegate & UITableViewDataSource
  @objc  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let peripheral = discoveredPeripherals[indexPath.row]
       let devicename = peripheral.identifier.uuidString
     
      
       
   }
       
     @objc   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          /// print("se")
           return discoveredPeripherals.count
       }
       
      @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
           let peripheral = discoveredPeripherals[indexPath.row]
           cell.textLabel?.text = peripheral.name ?? "Unknown Device"
           cell.detailTextLabel?.text = peripheral.identifier.uuidString
         
           return cell
       }
   func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
       if let error = error {
           print("Failed to connect to peripheral: \(error.localizedDescription)")
       } else {
           print("Failed to connect to peripheral")
       }
       // Perform any necessary error handling or recovery steps
   }
  
   
   
  @objc  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            isMyPeripheralConected = true //when connected change to true
            peripheral.delegate = self
            peripheral.discoverServices(nil)
        
    
        print("Conn \(peripheral)")
        var statusMessage = "Connected Successfully with this device : "+BEAN_NAME.description
      
        
        
            
        }

       
       func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
           isMyPeripheralConected = false //and to falso when disconnected
           var statusMessage = "Can't  connected with this device : "+BEAN_NAME.description
         
           print("dis")
       }
   func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
       print("not connect")
   }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
                 guard let services = peripheral.services else { return }
                 
                 for service in services {
                   peripheral.discoverCharacteristics(nil, for: service)
                     print("Discoveri")
                 }
             }
    private var printerCharacteristic: CBCharacteristic!
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
                guard let characteristics = service.characteristics else { return }
                
                for characteristic in characteristics {
                    if characteristic.properties.contains(.writeWithoutResponse) {
                        printerCharacteristic = characteristic
                        var ttt = "fggfgfg"
                        guard let data = ttt.data(using: .utf8) else { return }
                        
                        peripheral.writeValue(data, for: printerCharacteristic, type: .withoutResponse)
                        print("print ready")
                        break
                    }
                }
            }
    
}



