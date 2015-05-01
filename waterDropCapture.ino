#define ATTINY

#include <Streaming.h>

/*
 * light blue -> sender
 * black -> receiver
 */

// ATtiny85
// A0, A1 -> 5, 6
// Digital 2, 3, 4 -> 7, 2, 3
const int sensorPin = A0;
const int tunePin = A1;
const int focusPin = 2;
const int shutterPin = 3;
const int ledPin = 4;

const int height = 0.50; // cm
const int shutDelay = sqrt(height * 2 / 9.81) * 1000; // calculated by falling drop s=0.5*9.81*t^2
const int holdDelay = 100; // time to keep the bottom pressed and release bottom
const int photoDelay = 5000; // minimum time between release and press
const int sensibility = 25; // depending on the surrounded light
int sensorValue = 1023;
int sensorValueCalibrated = 1023;
int tuneValue = 0;

void setup() {
#ifndef ATTINY
	Serial.begin(9600);
	Serial << "calculated shutDelay: " << shutDelay << endl;
#endif
	setPin();
	calibrateSensorValue();
	pressFocus();
}

void loop() {
	sensorValue = analogRead(sensorPin);
	tuneValue = map(analogRead(tunePin), 0, 1023, -50, 50); // between -50 ... 50 ms tolerance
	if (sensorValue + sensibility < sensorValueCalibrated) {
#ifndef ATTINY
		Serial << endl << "Sensor Value: " << sensorValue << endl;
		Serial << "tuneValue: " << tuneValue << endl;
#endif
		digitalWrite(ledPin, HIGH);
		delay(shutDelay + tuneValue);
		pressShut();
		delay(holdDelay);
		releaseShut();
		releaseFocus();
		delay(photoDelay);
		pressFocus();
		digitalWrite(ledPin, LOW);
	}
}

void setPin() {
	pinMode(ledPin, OUTPUT);
	pinMode(focusPin, OUTPUT);
	pinMode(shutterPin, OUTPUT);
	digitalWrite(ledPin, LOW);
	digitalWrite(focusPin, LOW);
	digitalWrite(shutterPin, LOW);
}

void calibrateSensorValue() {
	for (int i = 0; i < 2000; i++) {
		sensorValue = analogRead(sensorPin);
		if (sensorValue < sensorValueCalibrated) {
			sensorValueCalibrated = sensorValue;
		}
	}
#ifndef ATTINY
	Serial << "Calibrated Value: " << sensorValueCalibrated << endl;
#endif
}

void pressFocus() {
	digitalWrite(focusPin, HIGH);
#ifndef ATTINY
	Serial << "pressed focus" << endl;
#endif
}

void pressShut() {
	digitalWrite(shutterPin, HIGH);
#ifndef ATTINY
	Serial << "pressed shut" << endl;
#endif
}

void releaseFocus() {
	digitalWrite(focusPin, LOW);
#ifndef ATTINY
	Serial << "released focus" << endl;
#endif
}

void releaseShut() {
	digitalWrite(shutterPin, LOW);
#ifndef ATTINY
	Serial << "released shut" << endl;
#endif
}

