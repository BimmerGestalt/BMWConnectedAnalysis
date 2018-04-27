---
layout: page
title: BMW Car Data Service
permalink: /cds/
---

The car's Etch service provides a set of functions prefixed with `cds_`, perhaps standing for Car Data Service, which provide a way for the phone app to receive live-updating information about the car.

## CDS Subscription

The Connected app calls `cds_create` to receive an integer handle. Then, for each data point it wants, it:

  1. It calls `cds_addPropertyChangedEventHandler(handle:int, ident:string, propertyName:string, intervalLimit:int)`
  2. It triggers an instant fetch by calling `cds_getPropertyAsync(handle:int, ident:string, propertyName:string)`

Then, the car will call the client callback method `cds_onPropertyChangedEvent(handle:int, ident:string, propertyName:string, propertyValue:string)` with a JSON payload. Changes to the data point will be sent this same way, but no more often than the requested `intervalLimit` in milliseconds.

## CDS Data points

| Ident | Name | Example Value |
| ---- | ---- | ----------- |
| 0 | replaying | {"error":400} |
| 1 | climate.ACCompressor | {"ACCompressor":1} |
| 3 | climate.ACMode | {"ACMode":{"maxCool":0,"recirculation":1,"defrost":0}} |
| 4 | climate.ACSystemTemperatures | {"ACSystemTemperatures":{"evaporator":19,"heatExchanger":19}} |
| 5 | climate.driverSettings | {"driverSettings":{"desiredTemperature":20.0,"program":2,"automaticBlower":1}} |
| 6 | climate.passengerSettings | {"passengerSettings":{"desiredTemperature":20.0,"program":63,"automaticBlower":1}} |
| 7 | climate.residualHeat | {"residualHeat":3} |
| 8 | climate.seatHeatDriver | {"seatHeatDriver":0} |
| 9 | climate.seatHeatPassenger | {"seatHeatPassenger":0} |
| 10 | communication.currentCallInfo | {"currentCallInfo":{"name":" ","number":" "}} |
| 11 | communication.lastCallInfo | {"lastCallInfo":{"name":"","number":"","numberType":89159028}} |
| 12 | controls.convertibleTop | {"error":401} |
| 13 | controls.cruiseControl | {"cruiseControl":{"desiredSpeed":30,"status":0}} |
| 15 | controls.defrostRear | {"defrostRear":0} |
| 16 | controls.headlights | {"headlights":1} |
| 18 | controls.lights | {"lights":{"brights":0,"parking":1,"frontFog":0,"rearFog":0}} |
| 20 | controls.startStopStatus | {"startStopStatus":128} |
| 21 | controls.sunroof | {"sunroof":{"openPosition":0,"tiltPosition":0,"status":0}} |
| 22 | controls.turnSignal | {"turnSignal":0} |
| 23 | controls.windowDriverFront | {"windowDriverFront":{"position":2,"status":1,"drive":0}} |
| 24 | controls.windowDriverRear | {"windowDriverRear":{"position":0,"status":0,"drive":0}} |
| 25 | controls.windowPassengerFront | {"windowPassengerFront":{"position":0,"status":0,"drive":0}} |
| 26 | controls.windowPassengerRear | {"windowPassengerRear":{"position":0,"status":0,"drive":0}} |
| 27 | controls.windshieldWiper | {"windshieldWiper":0} |
| 28 | driving.acceleration | {"acceleration":{"lateral":-0.19,"longitudinal":65535.00}} |
| 29 | driving.acceleratorPedal | {"acceleratorPedal":{"position":0,"ecoPosition":0}} |
| 30 | driving.averageConsumption | {"averageConsumption":{"averageConsumption1":27.2,"averageConsumption2":4093.0,"unit":3}} |
| 31 | driving.averageSpeed | {"averageSpeed":{"averageSpeed1":24.7,"averageSpeed2":4093.0,"unit":2}} |
| 32 | driving.brakeContact | {"brakeContact":0} |
| 34 | driving.clutchPedal | {"clutchPedal":{"position":0}} |
| 35 | driving.DSCActive | {"DSCActive":0} |
| 36 | driving.ecoTip | {"ecoTip":0} |
| 37 | driving.gear | {"gear":0} |
| 38 | driving.keyPosition | {"keyPosition":{"running":1,"starting":0,"accessory":1}} |
| 39 | driving.odometer | {"odometer":41811} |
| 40 | driving.parkingBrake | {"parkingBrake":2} |
| 41 | driving.shiftIndicator | {"shiftIndicator":0} |
| 42 | driving.speedActual | {"speedActual":0} |
| 43 | driving.speedDisplayed | {"speedDisplayed":0} |
| 44 | driving.steeringWheel | {"steeringWheel":{"angle":-10.5,"speed":-0.0,"error":0}} |
| 45 | driving.mode | {"mode":3} |
| 46 | engine.consumption | {"consumption":0} |
| 47 | engine.info | {"info":{"numberOfGears":6,"numberOfCylinders":4,"fuelType":4,"gearboxType":0,"displacement":2000}} |
| 50 | engine.RPMSpeed | {"RPMSpeed":0} |
| 51 | engine.status | {"status":0} |
| 52 | engine.temperature | {"temperature":{"engine":19,"oil":18}} |
| 53 | engine.torque | {"torque":0} |
| 54 | entertainment.multimedia | {"multimedia":{"title":" ","artist":" ","album":" ","source":0}} |
| 55 | entertainment.radioFrequency | {"radioFrequency":88500} |
| 56 | entertainment.radioStation | {"radioStation":{"frequency":88500,"name":"KQED HD","HDMode":1,"HDChannel":1,"nameInfo":6}} |
| 57 | navigation.currentPositionDetailedInfo | {"currentPositionDetailedInfo":{"street":"S Street Ln","houseNumber":"","crossStreet":"","city":"City Name, CA","country":"United States"}} |
| 59 | navigation.finalDestination | |
| 60 | navigation.finalDestinationDetailedInfo | |
| 61 | navigation.GPSExtendedInfo | {"GPSExtendedInfo":{"altitude":65530,"heading":144,"quality":443,"speed":32768}} |
| 62 | navigation.GPSPosition | {"GPSPosition":{"latitude":12.345678,"longitude":-12.345678}} |
| 63 | navigation.guidanceStatus | {"guidanceStatus":0} |
| 65 | navigation.infoToNextDestination | {"infoToNextDestination":{"airDistance":4294967.295,"direction":255,"distance":4294967.295,"remainingTime":-1,"routeHandle":0}} |
| 66 | navigation.nextDestination | {"nextDestination":{"name":"","type":0,"latitude":0.000000,"longitude":0.000000}} |
| 67 | navigation.nextDestinationDetailedInfo | |
| 68 | sensors.battery | {"battery":72} |
| 70 | sensors.doors | {"doors":{"driver":1,"passenger":0,"driverRear":2,"passengerRear":2}} |
| 71 | sensors.fuel | {"fuel":{"range":522,"reserve":0,"tanklevel":39}} |
| 72 | sensors.PDCRangeFront | {"PDCRangeFront":{"outLeft":253,"left":117,"middleLeft":96,"middleRight":95,"right":37,"outRight":0}} |
| 73 | sensors.PDCRangeRear | {"PDCRangeRear":{"outLeft":254,"left":253,"middleLeft":50,"middleRight":50,"right":253,"outRight":254}} |
| 74 | sensors.PDCStatus | {"PDCStatus":1} |
| 76 | sensors.seatOccupiedPassenger | {"seatOccupiedPassenger":0} |
| 77 | sensors.seatbelt | {"seatbelt":{"driverFront":0,"passengerFront":0,"driverRear":2,"passengerRear":2,"centerRear":2}} |
| 78 | sensors.temperatureExterior | {"temperatureExterior":14.0} |
| 79 | sensors.temperatureInterior | {"temperatureInterior":20.7} |
| 81 | sensors.trunk | {"trunk":0} |
| 82 | vehicle.country | {"country":2} |
| 83 | vehicle.language | {"language":3} |
| 84 | vehicle.type | {"type":49} |
| 85 | vehicle.unitSpeed | {"unitSpeed":1} |
| 86 | vehicle.units | {"units":{"airPressure":3,"consumption":3,"date":2,"time":2,"temperature":2,"fuel":1,"distance":2,"speedometerDigital":3,"sportPower":2,"sportTorque":2,"electricConsumption":1}} |
| 87 | vehicle.VIN | {"VIN":"T123456"} |
| 88 | engine.rangeCalc | {"rangeCalc":{"energyREXGenerator":65535,"energyEMotorTraction":65535,"energyEMotorRecuperation":65535,"auxConsumerEnergy":65535,"auxConsumerEnergyBaseLoad":65535}} |
| 89 | engine.electricVehicleMode | {"electricVehicleMode":15} |
| 90 | driving.SOCHoldState | {"SOCHoldState":3} |
| 91 | driving.electricalPowerDistribution | {"error":401} |
| 92 | driving.displayRangeElectricVehicle | {"displayRangeElectricVehicle":4095} |
| 93 | sensors.SOCBatteryHybrid | {"SOCBatteryHybrid":255.00} |
| 94 | sensors.batteryTemp | {"batteryTemp":255} |
| 95 | hmi.iDrive | |
| 96 | driving.ecoRangeWon | {"ecoRangeWon":0.8} |
| 97 | climate.airConditionerCompressor | {"airConditionerCompressor":{"actualPower":255,"dualMode":3,"actualTorque":0}} |
| 98 | controls.startStopLEDs | {"startStopLEDs":0} |
| 99 | driving.ecoRange | {"ecoRange":118} |
| 100 | driving.FDRControl | {"FDRControl":512} |
| 101 | driving.keyNumber | {"keyNumber":1} |
| 102 | navigation.infoToFinalDestination | |
| 103 | navigation.units | {"units":4} |
| 104 | sensors.lid | {"lid":0} |
| 105 | sensors.seatOccupiedDriver | {"seatOccupiedDriver":4} |
| 106 | sensors.seatOccupiedRearLeft | {"seatOccupiedRearLeft":4} |
| 107 | sensors.seatOccupiedRearRight | {"seatOccupiedRearRight":4} |
| 108 | vehicle.systemTime | {"systemTime":85651502} |
| 109 | vehicle.time | {"time":{"hour":21,"minute":52,"second":13,"date":26,"month":4,"weekday":4,"year":2018}} |
| 110 | driving.drivingStyle | {"accelerate":0.0,"brake":0.0,"shift":0.0} |
| 111 | driving.displayRangeElectricVehicle | {"displayRangeElectricVehicle":4095} |
| 112 | navigation.routeElapsedInfo | |
| 113 | hmi.tts | {"TTSState":{"state":1,"currentblock":-2,"blocks":0,"type":"","languageavailable":1}} |
| 114 | hmi.graphicalContext | {"error":400} |
| 115 | sensors.PDCRangeFront2 | {"error":400} |
| 116 | sensors.PDCRangeRear2 | {"error":400} |
| 117 | cds.apiRegistry | {"error":400} |
| 118 | api.carcloud | {"error":400} |
| 119 | api.startJSApp | {"error":400} |
