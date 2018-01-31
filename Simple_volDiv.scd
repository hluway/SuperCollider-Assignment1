
SerialPort.closeAll;
SerialPort.devices;
~port= SerialPort.new("/dev/tty.usbmodem14511",115200);

(

~intArray=[ ];
Tdef(\readValues, {

	{

		~ascii=~port.read;

	case

		{~ascii==nil} {nil}

		{~ascii.asAscii.isDecDigit}
		{~intArray=~intArray.add(~ascii.asAscii.digit)}

		{~ascii.asAscii.isAlpha}
		{
			~val=~intArray.convertDigits;
			~intArray=[ ];


		}

		{true} {nil};



	}.loop;

}).play;
)

Tdef(\readValues).stop;

~val;

{SinOsc.ar(LFNoise0.kr(40).range(~val,~val*1500), mul:0.1)}.play;

 {SinOsc.ar(LFNoise0.kr(40+~val).range(~val,~val*1500), mul:0.1)}.play;

 {SinOsc.ar(LFNoise0.kr(~val*100).range(~val*10,~val*1500), mul:~val/100)}.play;

{SinOsc.ar(440+~val)}.play.postln;

(
~synth={

	arg freq=10;
	var sig;
	//sig=SinOsc.ar(freq);
	sig=SinOsc.ar(LFNoise0.kr(freq).range(100,1500), mul:0.1);
	//sig= LPF.ar(sig, freq,0.2);
}.play
)
(
~synth2={

	arg freq=1000;
	var sig;
	sig=WhiteNoise(1|2);
	sig= LPF.ar(sig, freq,0.2);
}.play
)


(
Tdef(\addSinWaves,{

	{

		~synth.set(\freq,~val.linexp(199,201,202,203));
		~synth2.set(\freq,~val.linexp(21,38,69,977));
		0.02.wait;



	}.loop

}).play

)


(
Tdef(\addSinWaves,{

	{

		~synth.set(\freq,~val.linexp(21,38,69,977));
		~synth2.set(\freq,~val.linexp(21,38,69,977));
		0.02.wait;



	}.loop

}).play

)


Tdef(\addSinWaves).stop;