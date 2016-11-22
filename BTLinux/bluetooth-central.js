/**
* bluetooth-central.js
* a code to communicate with LE device, using noble 
*/

var async = require('async');
var noble = require('noble');
var moment = require('moment');

var serviceUUID = "740efdc9e0ce4b308c18577d8275c17f";
var characteristicUUID = "534b0ed747de4e5a9e3eda4bd3b33d2e";

var counter = 1;
var batteryLevelCharacteristic = null;
var iphone = null;

noble.on('stateChange', function(state) {
	console.log('state change');
	
  if (state === 'poweredOn') {
  	console.log('scanning started');
    noble.startScanning([serviceUUID], false);
  } //else {
    //noble.stopScanning();
  //}
});

noble.on('discover', function(peripheral) {
	iphone = peripheral;

	iphone.connect(function(error) {
		console.log('connected to peripheral: ' + iphone.uuid);

		iphone.discoverServices([serviceUUID], function(error, services) {
			console.log(services.length + ' services found')

			if (services.length > 0) {
				noble.stopScanning();

				var batteryService = services[0];
				console.log('Discovered Context Data service');

				batteryService.discoverCharacteristics([characteristicUUID], function(error, characteristics) {
					batteryLevelCharacteristic = characteristics[0];
					console.log('Discovered Context Data characteristic');

					batteryLevelCharacteristic.on('read', function(data, isNotification) {
						var now = moment();
						var formatted = now.format('YYYY-MM-DD HH:mm:ss:SSS');
						// console.log('received from '+peripheral.uuid+': '+ data.toString('hex'));
						console.log('['+formatted+'] received from '+peripheral.uuid+': '+ data.toString('hex'));

						// if (data.toString('hex') == '454f4d') {
						// 	console.log('counter: ' + counter++);
						// }
                        //
						// if (counter == 28) {
						// 	batteryLevelCharacteristic.unsubscribe(function(err){
						// 		if (!err) {
						// 			console.log('successfully unsubscribe');
						// 			counter = 0; // reset counter
                        //
						// 			batteryLevelCharacteristic.subscribe(function(err){
						// 				if (err) {
						// 					console.log(err);
						// 				} else {
						// 					console.log('Context data notification is now on');
						// 				}
						// 			});
						// 		} else {
						// 			console.log('error unsubscribing');
						// 		}
						// 	});
						// }
					});

					// true to enable notify
					// batteryLevelCharacteristic.notify(true, function(error) {
					//   console.log('Context data notification is now on');
					// });

					batteryLevelCharacteristic.subscribe(function(err){
						if (err) {
							console.log(err);
						} else {
							console.log('Context data notification is now on');
						}
					});
				});
			}
		});
	});

	iphone.on('disconnect', function () {
		console.log('disconnected');
		// iphone.disconnect();

		iphone.connect(function (err) {
			if (!err) {
				iphone.connect(function(error) {
					console.log('connected to peripheral: ' + iphone.uuid);

					iphone.discoverServices([serviceUUID], function(error, services) {
						console.log(services.length + ' services found')

						if (services.length > 0) {
							noble.stopScanning();

							var batteryService = services[0];
							console.log('Discovered Context Data service');

							batteryService.discoverCharacteristics([characteristicUUID], function(error, characteristics) {
								batteryLevelCharacteristic = characteristics[0];
								console.log('Discovered Context Data characteristic');

								batteryLevelCharacteristic.on('read', function(data, isNotification) {
									var now = moment();
									var formatted = now.format('YYYY-MM-DD HH:mm:ss:SSS');
									// console.log('received from '+peripheral.uuid+': '+ data.toString('hex'));
									console.log('['+formatted+'] received from '+peripheral.uuid+': '+ data.toString('hex'));
								});

								batteryLevelCharacteristic.subscribe(function(err){
									if (err) {
										console.log(err);
									} else {
										console.log('Context data notification is now on');
									}
								});
							});
						}
					});
				});
			} else {
				console.log(err);
			}
		});
	});
});

