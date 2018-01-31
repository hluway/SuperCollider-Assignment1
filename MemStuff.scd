{SinOsc.ar(LFNoise0.kr(10).range(500,1500), mul:0.1)}.play;
{RLPF.ar(Dust.ar([8, 15]), LFNoise1.ar([0.55, -0.7]).range(100, 200), 0.02)}.play;//COOL

(
	"First Line".postln;
 "Second Line".postln;
 (2 + 2).postln;
 3 + 3;
"Finished".postln;

)

(
 // A little poem
 "Today is Sunday".postln;
 "Foot of pipe".postln;
 "The pipe is made of gold".postln;
 "It can beat the bull".postln;
 )
100.do({"Print this line over and over...".scramble.postln});
//record
// Start recording:
s.record;
// Make some cool sound
{Saw.ar(LFNoise0.kr([2, 3]).range(100, 2000), LFPulse.kr([4, 5]) * 0.1)}.play;
// Stop recording:
s.stopRecording;
// Optional: GUI with record button, volume control, mute button:
s.makeWindow;

x=12;
y=40;
x;
y;
x+y;

Pbind(\degree, Pseries(0, 1, 30), \dur, 0.05).play;

Pbind(\degree, 0,\dur, 1000).play;

Pbind(\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], 20), \dur, 0.1).play;

Pbind(\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], 5), \dur, Pseq([0.2, 0.1, 0.1, 0.2,0.2, 0.35], inf)).play;
"hello".dup(4);
3.1415.round(0.1);
100.rand;

100.0.rand.round(0.01).dup(4);
3.1415.round(0.1); // receiver notation
round(3.1415, 0.1); // functional notation
// Nesting and proper indentation
(
{
	CombN.ar(
		SinOsc.ar(
			midicps(
				LFNoise1.ar(3, 24,
					LFSaw.ar([5, 5.123], 0, 3, 80) )
			),
 0, 0.4
 ),
 1, 0.3, 2)
 }.play;
 )

 [1, 2, 3, 4].reverse + 10;

play(	{RLPF.ar(Dust.ar([100,100]),LFNoise1.ar(1/[1/10],150,160), 0.20)});

play({ 	var sines=5, speed =6;

	Mix.fill(sines,
		{arg x;
		Pan2.ar(
		SineOsc.ar(x+1*100, mul: max(0,LFNoise1.kr(speed) + Line.kr(1,-1,30)
		)
), rand2(1.0)


	)

	}
	)/sines

})

exprand(1,1000.0,5);
{exprand(1,1000.0,5)};

{LFNoise0.ar(10000)}.plot;
{LFNoise0.ar(10000)}.scope;
play({ SinOsc.ar(Line.kr(200,17000,10),0,0.1) });
//Phase modulation OSC
{PMOsc.ar(440,550,7)}.play;
play({Line.kr()});
{PMOsc.ar(140,MouseY.kr(1,550), MouseX.kr(1,15))}.play;
{PMOsc.ar(Line.kr(2000,17000,15),Line.kr(4000,40000,4),Line.kr(300,30,3))}.play;

//VCO,VCF,VCA
(
{
	Blip.ar(
		[TRand.kr( //frequency or VCO
			100,1000,//range
			Impulse.kr(Line.kr(1,20,60))), //trigger
		TRand.kr(//number of harmonics or VCF
			1,10,//range
			Impulse.kr(Line.kr(1,20,60))),//trigger
		Linen.kr( //mul, or amp, VCA
			Impulse.kr(Line.kr(1,20,60)),//trigger
			0,//attack
			0.5,//sustain
			1/Line.kr(1,20,60))//trigger
		,TRand.kr( //frequency or VCO
			100,1000,//range
			Impulse.kr(Line.kr(1,20,60))), //trigger
		TRand.kr(//number of harmonics or VCF
			1,10,//range
			Impulse.kr(Line.kr(1,20,60))),//trigger
		Linen.kr( //mul, or amp, VCA
			Impulse.kr(Line.kr(1,20,60)),//trigger
			0,//attack
			0.5,//sustain
			1/Line.kr(1,20,60))//trigger
		]

	)
}.play
)

//Cleaned up version

(
p={
r=Impulse.kr(Line.kr(1,20,60));//rate
	//r=LFTri.kr(1/10) *3+7;
t= Impulse.kr(r);//trigger
	//t=Dust.kr(r);
e=Linen.kr(t,0,0.5,1/r);// envelope uses r and t
f=TRand.kr(1,10,t); //triggered random also uses t
};//f=e+1*4;
	{Blip.ar(f*100,f,e)//f, and e used in Blip
}.play
)
p.free;

//1.6

(
{//carrier and modulator not linked
	var r= [Impulse.kr(10),Impulse.kr(10)];
	//r=LFTri.kr(1/10) *3+7;
	var c= TRand.kr([100,100],500,r);
	var m =TRand.kr([100,100],500, r);
var env =1/r
	PMOsc.ar([c,c+1],m,Line.kr(1,12,Line.kr(1,12,60)))
}.scope
)

//synthDefs
(
SynthDef("one_tone_only", {
	var out, freq=440;
	out=SinOsc.ar(freq);
	Out.ar(0,out)
}).add
)

Synth("one_tone_only");

(
SynthDef("diiferent_tones",{
	arg freq= 441;
	var out;
	out= SinOsc.ar(freq)*0.3;
	Out.ar(0,out)
}).add
}

Synth("diiferent_tones");

a=Synth("diiferent_tones", ["freq",64.midicps]);
b=Synth("diiferent_tones", ["freq",67.midicps]);
c=Synth("diiferent_tones", ["freq",72.midicps]);
a.set("freq", 65.midicps);
b.set("freq",71.midicps);
a.set("freq", 64.midicps); c.set("freq",72.midicps);
a.free;
b.free;
c.free;


(
SynthDef("PMCrotale", {
	arg midi=60, tone = 3, art =1, amp =0.8, pan = 0;
	var env, out, mod, freq;
	freq=midi.midicps;
	env = Env.perc(0,art);
	mod = 5 +(1/IRand(2,6));

	out= PMOsc.ar(freq,mod*freq,
		pmindex:EnvGen.kr(env, timeScale:art, levelScale: tone),
		mul: EnvGen.kr(env, timeScale: art, levelScale:0.3));

	out= Pan2.ar(out, pan);
	out=out *EnvGen.kr(env, timeScale:1.3*art, levelScale: Rand(0.1, 0.5), doneAction: 2);
	Out.ar(0,out);

}).add

)

Synth("PMCrotale", ["midi", rrand(48,72).round(1), "tone", rrand(1,6)])

[0, 2 , 4 , 5 , 7 , 9 , 11].do({arg each, count; ["count",count,"each",each].postln})






