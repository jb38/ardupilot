/*
 *  AP_RangeFinder_test
 *  Code by DIYDrones.com
 */

// includes
#include <AP_Common.h>
#include <AP_Progmem.h>
#include <AP_Param.h>
#include <AP_HAL.h>
#include <AP_Math.h>
#include <AP_RangeFinder.h>
#include <AP_ADC.h>
#include <AP_ADC_AnalogSource.h>
#include <Filter.h>
#include <AP_Buffer.h>
#include <AP_HAL_AVR.h>

// For APM1 we use built in ADC for sonar reads from an analog pin
#if CONFIG_HAL_BOARD == HAL_BOARD_APM1 && SONAR_TYPE <= AP_RANGEFINDER_MAXSONARHRLV
# define USE_ADC_ADS7844  // use APM1's built in ADC and connect sonar to pitot tube
#endif

// define Pitot tube's ADC Channel
#define AP_RANGEFINDER_PITOT_TYPE_ADC_CHANNEL 7

#ifndef AP_RANGEFINDER_ANALOG_PIN
  #define AP_RANGEFINDER_ANALOG_PIN 4
#endif

////////////////////////////////////////////////////////////////////////////////
// hal.console-> ports
////////////////////////////////////////////////////////////////////////////////

const AP_HAL::HAL& hal = AP_HAL_BOARD_DRIVER;

// declare global instances
ModeFilterInt16_Size7 mode_filter(3);

#ifdef USE_ADC_ADS7844
AP_ADC_ADS7844 adc;
AP_ADC_AnalogSource adc_analog_source(&adc,
        AP_RANGEFINDER_PITOT_TYPE_ADC_CHANNEL, 0.25);// use Pitot tube
#endif

AP_RangeFinder_SharpGP2Y *rf;

void setup()
{
    hal.console->println("Range Finder Test v1.1");
    hal.console->println("Sensor Type: Sharp GP2Y");

#ifdef USE_ADC_ADS7844
    adc.Init();   // APM ADC initialization
    AP_HAL::AnalogSource *analog_source = &adc_analog_source;
#else     
    AP_HAL::AnalogSource *analog_source = hal.analogin->channel(
            AP_RANGEFINDER_ANALOG_PIN);
#endif
    rf = new AP_RangeFinder_SharpGP2Y(analog_source, &mode_filter);
}

void loop()
{
    hal.console->print("dist:");
    hal.console->print(rf->read());
    hal.console->print("\traw:");
    hal.console->print(rf->raw_value);
    hal.console->println();

    hal.scheduler->delay(100);
}

AP_HAL_MAIN();
