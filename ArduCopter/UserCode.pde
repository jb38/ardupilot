/// -*- tab-width: 4; Mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-

#ifdef USERHOOK_INIT
void userhook_init()
{
    hood_range1_analog_source = hal.analogin->channel(HOOD_RANGE1_PIN);
    hood_range2_analog_source = hal.analogin->channel(HOOD_RANGE2_PIN);
    hood_range3_analog_source = hal.analogin->channel(HOOD_RANGE3_PIN);
    
    hood_range1 = new AP_RangeFinder_SharpGP2Y(hood_range1_analog_source, 
                                               &hood_range1_mode_filter);
    hood_range2 = new AP_RangeFinder_SharpGP2Y(hood_range2_analog_source, 
                                               &hood_range2_mode_filter);
    hood_range3 = new AP_RangeFinder_SharpGP2Y(hood_range3_analog_source, 
                                               &hood_range3_mode_filter);
}
#endif

#ifdef USERHOOK_FASTLOOP
void userhook_FastLoop()
{
    // put your 100Hz code here
}
#endif

#ifdef USERHOOK_50HZLOOP
void userhook_50Hz()
{
    // put your 50Hz code here
}
#endif

#ifdef USERHOOK_MEDIUMLOOP
void userhook_MediumLoop() // 10Hz
{
    /*
    // read the sensors
    int16_t hood_dist_1 = hood_range1->read();
    int16_t hood_dist_2 = hood_range2->read();
    int16_t hood_dist_3 = hood_range3->read();
    
    // build points with the values
    
    // left/right are at 45* angles pointed across the bow
    
    // center is straight out
    */
}
#endif

#ifdef USERHOOK_SLOWLOOP
void userhook_SlowLoop()
{
    // put your 3.3Hz code here
}
#endif

#ifdef USERHOOK_SUPERSLOWLOOP
void userhook_SuperSlowLoop()
{
    // put your 1Hz code here
    // if disarmed, return
    if(!motors.armed()) {
        return;
    }

    switch (hood_control_current_state) {
    
        case HOOD_AUTO_STATE_LANDED:
            if (control_mode == AUTO) {
                if (hood_control_next_state == HOOD_AUTO_STATE_TAKEOFF) {
                    hood_control_current_state = hood_control_next_state;
                    hood_control_next_state = HOOD_AUTO_STATE_LOITER;
                    do_takeoff(); // commands_logic.pde:233
                }
            }
            break;
            
        case HOOD_AUTO_STATE_TAKEOFF:
            if (verify_takeoff()) { // commands_logic.pde:462
                hood_control_current_state = hood_control_next_state; // LOITER
                hood_control_next_state = HOOD_AUTO_STATE_RTL;
                hood_control_loiter_start = millis();
                hood_control_loiter_time = 0;
                set_mode(OF_LOITER); // system.pde:336
            }
            break;
            
        case HOOD_AUTO_STATE_LOITER:
            if (hood_control_loiter_time >= hood_control_loiter_duration) {
                hood_control_current_state = hood_control_next_state; // RTL
                hood_control_next_state = HOOD_AUTO_STATE_LANDING;
                set_mode(RTL); // system.pde:336
            } else {
                hood_control_loiter_time = (millis() - hood_control_loiter_start) / 1000;
            }
            break;
        
        case HOOD_AUTO_STATE_RTL:
            if (verify_RTL()) {
                hood_control_current_state = hood_control_next_state;
                hood_control_next_state = HOOD_AUTO_STATE_LANDED;
                set_mode(LAND); // system.pde:336
            }
            break;
                    
        case HOOD_AUTO_STATE_LANDING:
        	if (verify_land()) {
        	    hood_control_current_state = hood_control_next_state; // LANDED
                hood_control_next_state = HOOD_AUTO_STATE_LANDED;
                // land automatically disarms
        	}
            break;
            
        case HOOD_AUTO_STATE_NAVIGATE:
        
            break;
            
        default:
            break;
            
    }
}
#endif