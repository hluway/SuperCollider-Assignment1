


//Synth Defs

//Synth made up of three sinOsc and an envelope
(
SynthDef(\toisSin, { arg freq=0, gate=1,amp=0.5;
	var sinOne=SinOsc.ar(freq)+SinOsc.ar(freq*2)+SinOsc.ar(freq/2);
	var env=EnvGen.kr(blend(Env.sine,Env.perc,0),gate, doneAction:2);


	Out.ar(0, sinOne*env*amp.dup);
}).add;

)

q= Synth(\toisSin);


//Synth made with a saw osc and perc envelope
(
SynthDef(\seeSaw, { arg freq=441, gate=1,amp=0.5;
	var saw =  Saw.ar(freq);
	var env = EnvGen.kr(Env.perc,gate, doneAction:2);
	Out.ar(0,saw*env*amp.dup);

}).add;
)

r= Synth(\seeSaw);

//Synth made with a pulse wave. Intended to be able to modify the width in a Pdef.
(
SynthDef(\pulseBeat, { arg freq=40,width=0.85, amp=1;
	var pulseWave= LPF.ar(Pulse.ar(freq, width));
	var env= EnvGen.kr(Env.perc,doneAction:2);

	Out.ar(0,pulseWave*env*amp.dup);

}
).add;//SynthDef
)


t= Synth(\pulseBeat);




//Voice 1
(
Pdef(\l,
	Pbind(\instrument, \toisSin,
		\freq, Pseq([[111,441,331],[551,111.441],[331,111,551]],inf),
		\amp,0.1
	)//Pbind
);//Pdef
)
Pdef(\l).play;
Pdef(\l).stop;


//Voice 2

(

~freqColl = [441,331,221,111];
Pdef(\random,
	Pbind(\instrument, \seeSaw,
		\freq, Prand(~freqColl,inf),
		\dur, 0.25,
		\legato, Pseq([0.4,0.7],inf),
		\amp, 0.1

	)
);
)

Pdef(\random).play;
Pdef(\random).stop;


//Voice 3


(
Pdef(\beat,
	Pbind(\instrument, \pulseBeat,
		\freq, Pseq([40,45,45,Rest(0.5)],inf),
		\width, Pseq([0.85,0.75,0.5,Rest(0.5)],inf),
		\dur, 0.25,
		\amp,0.5

	)
);//Pdef
)

Pdef(\beat).play;
Pdef(\beat).stop;



(
Pdef(\beat2,
	Pbind(\instrument, \pulseBeat,
		\freq, Pseq([50,55,55,Rest(0.5)],inf),
		\width, Pseq([0.85,0.75,0.5,Rest(0.5)],inf),
		\dur, 0.50,
		\amp, 1

	)
);//Pdef
)

Pdef(\beat2).play;
Pdef(\beat2).stop;


(
Pdef(\glitter,
Pbind(\instrument, \toisSin,
		\freq, Pn(Pseries(441, 221,10),1),
	\dur, 1/6, \legato, 0.1
)
);
)


Pdef(\glitter).play;
Pdef(\glitter).stop;


Pdef.clear;













