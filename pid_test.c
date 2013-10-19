/* INCOMPLETE */

/* PID Test 
http://programmers.stackexchange.com/questions/186124/programming-pid-loops-in-c
Last updated 10/19/13
 */
 
/*
output = Kp * err + (Ki * ierr * dt) + (Kd * derr /dt);
*/ 
double Kp = 1//Proptional Constant.
double Ki = 1//Integral Constant.
double Kd = 1//Derivative Constant.
double err; //Expected Output - Actual Output ie. error;
double err_prev; //last value
double ierr=0; //int from previous loop + err; ( i.e. integral error )
double derr=0; //err - err from previous loop; ( i.e. differential error)
double dt = 1.0; //execution time of loop. (seconds)
/*
where initially 'der' and 'int' would be zero. If you use a delay function in code to tune the loop frequency to say 1 KHz then your dt would be 0.001 seconds.
Drawning in C
*/

//I found this excellent code for PID in C, though it doesn't cover every aspect of it, its a good one nonetheless.
//get value of setpoint from user
double setpoint = 13.4; //volts, float voltage
static double output;
while(1){
	wdt_reset(); // reset Timer
	for(;;) {
  // write code to escape loop on receiving a keyboard interrupt.
	static double adcout;
	adcout = readadc(voltage_chan);// read the value of Vin from ADC ( Analogue to digital converter).
	err_prev = err;	//holds value of previous error
	err = setpoint - adcout; //calculate error
	ierr += err; //integral error
	derr = (err - err_prev); //differential error
	output = Kp * err + (Ki + ierr * dt) + (Kd * derr/dt);// Calculate the output using the formula discussed previously.
	printf("Kp: %f\n
	Kd: %f\n
	Ki: %f\n
	Err: %f\n
	Prev: %f\n
	iErr: %f\n
	dErr: %f\n
	dt: %f\n");
	low_power_mode(); //sleep until wdt reset
	}
	
  // Apply the calculated outpout to DAC ( digital to analogue converter).
  // wait till the Timer reach 'dt' seconds.
}
