Server.default = s= Server.internal;

s.boot;

z=s.scope(4);
//a) mono output
(
SynthDef(\UGen_ex1a, {Out.ar(0, SinOsc.ar(440, 0,0.1))
}).add;
)
)
a=Synth(\UGen_ex1a);

a.free;

//b) freq input is an Array of 4 items-outputs to busses 0-3
(
SynthDef(\UGen_ex1b, {
	Out.ar(0, SinOsc.ar([440,446,448.5,882], 0,0.1))
}).add ;
)
)
a=Synth(\UGen_ex1b);

a.free;

(
SynthDef(\UGen_ex1c, {
	Out.ar(0, SinOsc.ar([440,446,448.5,882], 0,[0.1,0.2,0.3,0.4]))
}).add ;
)
)
a=Synth(\UGen_ex1c);

a.free;

(
SynthDef(\UGen_ex1d, {
	Out.ar(0, SinOsc.ar([440,446,448.5,882], 0,[0.1,0.2,0.3]).sum)
}).add
)
)
a=Synth(\UGen_ex1d);

a.free;

(
SynthDef(\UGen_ex1me, {
	Out.ar(0, SinOsc.ar([440,446,448.5],Crackle.ar(MouseX.kr(1,2), 0.99),[0.1,0.2,0.3]))
}).add;
)


a=Synth(\UGen_ex1me);

a.free;


{ Crackle.ar(MouseX.kr(1,2), 0.5) }.scope(1);