/// -*- tab-width: 4; Mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-

// user defined variables

#ifdef USERHOOK_VARIABLES

///////////////////////////////
// HoodCopter Custom Payload //
///////////////////////////////

#define HOOD_RANGE1_ANALOG_PIN 4 // left
#define HOOD_RANGE2_ANALOG_PIN 5 // center
#define HOOD_RANGE3_ANALOG_PIN 6 // right

ModeFilterInt16_Size7 hood_range1_mode_filter(3);
ModeFilterInt16_Size7 hood_range2_mode_filter(3);
ModeFilterInt16_Size7 hood_range3_mode_filter(3);

static AP_HAL::AnalogSource *hood_range1_analog_source;
static AP_HAL::AnalogSource *hood_range2_analog_source;
static AP_HAL::AnalogSource *hood_range3_analog_source;

static AP_RangeFinder_SharpGP2Y *hood_range1; // left
static AP_RangeFinder_SharpGP2Y *hood_range2; // center
static AP_RangeFinder_SharpGP2Y *hood_range3; // right



/////////////////////////////
// Hood Autonomous Control //
/////////////////////////////

#define HOOD_AUTO_STATE_LANDED   0
#define HOOD_AUTO_STATE_TAKEOFF  1
#define HOOD_AUTO_STATE_LOITER   2
#define HOOD_AUTO_STATE_RTL      3
#define HOOD_AUTO_STATE_LANDING  4
#define HOOD_AUTO_STATE_NAVIGATE 5

static uint8_t hood_control_current_state = HOOD_AUTO_STATE_LANDED;
static uint8_t hood_control_next_state = HOOD_AUTO_STATE_TAKEOFF;

static uint32_t hood_control_loiter_time = 0;
static uint32_t hood_control_loiter_start = 0;
static uint32_t hood_control_loiter_duration = 60; // amount of time to loiter (seconds)

#endif  // USERHOOK_VARIABLES
