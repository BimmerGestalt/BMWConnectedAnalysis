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
| 0 | replaying | |
| 1 | climate.ACCompressor | |
| 3 | climate.ACMode | |
| 4 | climate.ACSystemTemperatures | |
| 5 | climate.driverSettings | |
| 6 | climate.passengerSettings | |
| 7 | climate.residualHeat | |
| 8 | climate.seatHeatDriver | |
| 9 | climate.seatHeatPassenger | |
| 10 | communication.currentCallInfo | |
| 11 | communication.lastCallInfo | {"lastCallInfo":{"name":"","number":"","numberType":89159028}} |
| 12 | controls.convertibleTop | |
| 13 | controls.cruiseControl | |
| 15 | controls.defrostRear | |
| 16 | controls.headlights | |
| 18 | controls.lights | |
| 20 | controls.startStopStatus | |
| 21 | controls.sunroof | |
| 22 | controls.turnSignal | |
| 23 | controls.windowDriverFront | |
| 24 | controls.windowDriverRear | |
| 25 | controls.windowPassengerFront | |
| 26 | controls.windowPassengerRear | |
| 27 | controls.windshieldWiper | |
| 28 | driving.acceleration | |
| 29 | driving.acceleratorPedal | |
| 30 | driving.averageConsumption | |
| 31 | driving.averageSpeed | |
| 32 | driving.brakeContact | |
| 34 | driving.clutchPedal | |
| 35 | driving.DSCActive | |
| 36 | driving.ecoTip | |
| 37 | driving.gear | |
| 38 | driving.keyPosition | |
| 39 | driving.odometer | {"odometer":41811} |
| 40 | driving.parkingBrake | |
| 41 | driving.shiftIndicator | |
| 42 | driving.speedActual | |
| 43 | driving.speedDisplayed | |
| 44 | driving.steeringWheel | |
| 45 | driving.mode | {"mode":3} |
| 46 | engine.consumption | {"consumption":0} |
| 47 | engine.info | {"info":{"numberOfGears":6,"numberOfCylinders":4,"fuelType":4,"gearboxType":0,"displacement":2000}} |
| 50 | engine.RPMSpeed | |
| 51 | engine.status | |
| 52 | engine.temperature | |
| 53 | engine.torque | |
| 54 | entertainment.multimedia | {"multimedia":{"title":" ","artist":" ","album":" ","source":0}} |
| 55 | entertainment.radioFrequency | |
| 56 | entertainment.radioStation | |
| 57 | navigation.currentPositionDetailedInfo | {"currentPositionDetailedInfo":{"street":"S Street Ln","houseNumber":"","crossStreet":"","city":"City Name, CA","country":"United States"}} |
| 59 | navigation.finalDestination | |
| 60 | navigation.finalDestinationDetailedInfo | |
| 61 | navigation.GPSExtendedInfo | {"GPSExtendedInfo":{"altitude":65530,"heading":144,"quality":443,"speed":32768}} |
| 62 | navigation.GPSPosition | {"GPSPosition":{"latitude":12.345678,"longitude":-12.345678}} |
| 63 | navigation.guidanceStatus | {"guidanceStatus":0} |
| 65 | navigation.infoToNextDestination | {"infoToNextDestination":{"airDistance":4294967.295,"direction":255,"distance":4294967.295,"remainingTime":-1,"routeHandle":0}} |
| 66 | navigation.nextDestination | {"nextDestination":{"name":"","type":0,"latitude":0.000000,"longitude":0.000000}} |
| 67 | navigation.nextDestinationDetailedInfo | |
| 68 | sensors.battery | |
| 70 | sensors.doors | |
| 71 | sensors.fuel | {"fuel":{"range":522,"reserve":0,"tanklevel":39}} |
| 72 | sensors.PDCRangeFront | |
| 73 | sensors.PDCRangeRear | |
| 74 | sensors.PDCStatus | {"PDCStatus":1} |
| 76 | sensors.seatOccupiedPassenger | |
| 77 | sensors.seatbelt | |
| 78 | sensors.temperatureExterior | {"temperatureExterior":14.0} |
| 79 | sensors.temperatureInterior | |
| 81 | sensors.trunk | |
| 82 | vehicle.country | {"country":2} |
| 83 | vehicle.language | {"language":3} |
| 84 | vehicle.type | {"type":49} |
| 85 | vehicle.unitSpeed | |
| 86 | vehicle.units | {"units":{"airPressure":3,"consumption":3,"date":2,"time":2,"temperature":2,"fuel":1,"distance":2,"speedometerDigital":3,"sportPower":2,"sportTorque":2,"electricConsumption":1}} |
| 87 | vehicle.VIN | |
| 88 | engine.rangeCalc | |
| 89 | engine.electricVehicleMode | |
| 90 | driving.SOCHoldState | |
| 91 | driving.electricalPowerDistribution | |
| 92 | driving.displayRangeElectricVehicle | {"displayRangeElectricVehicle":4095} |
| 93 | sensors.SOCBatteryHybrid | {"SOCBatteryHybrid":255.00} |
| 94 | sensors.batteryTemp | |
| 95 | hmi.iDrive | |
| 96 | driving.ecoRangeWon | |
| 97 | climate.airConditionerCompressor | |
| 98 | controls.startStopLEDs | |
| 99 | driving.ecoRange | |
| 100 | driving.FDRControl | |
| 101 | driving.keyNumber | |
| 102 | navigation.infoToFinalDestination | |
| 103 | navigation.units | |
| 104 | sensors.lid | |
| 105 | sensors.seatOccupiedDriver | |
| 106 | sensors.seatOccupiedRearLeft | |
| 107 | sensors.seatOccupiedRearRight | |
| 108 | vehicle.systemTime | |
| 109 | vehicle.time | |
| 110 | driving.drivingStyle | {"accelerate":0.0,"brake":0.0,"shift":0.0} |
| 111 | driving.displayRangeElectricVehicle | |
| 112 | navigation.routeElapsedInfo | |
| 113 | hmi.tts | |
| 114 | hmi.graphicalContext | |
