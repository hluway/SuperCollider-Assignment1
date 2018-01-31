SerialPort.closeAll;
SerialPort.devices;
~port= SerialPort.new("/dev/tty.usbmodem1441",115200);

(
~lastButtonValue= ~buttonVal;
Tdef(\postValues, {
	{

		if(~lastButtonValue!= ~buttonVal,
			{

				~lastButtonValue= ~buttonVal;
				~lastButtonValue.asAscii.digit.postln;
				~synth.set(\gate, ~lastButtonValue.asAscii.digit);

			}
		);
 	0.01.wait;
	}.loop;

}).play;


)
s.boot;


~lastButtonValue.asAscii.digit;

(
~synth ={

	arg gate = 0;

	var sig, env;
	sig=Saw.ar([60,61],0.5);
	sig=LPF.ar(sig,2000);
	env= Env.adsr.kr(0,gate);
	sig=sig*env;
}.play;


)


~synth.set(\gate,0);