//2.4-triggers and sending values from the server back to the SuperCollider Lang.
(
SynthDef(\UGen_4a, {arg id, limit=1;
	var src, pitch, hasPitch,keynum,outOfTune;
	//read input
	src=SoundIn.ar(0);
	//anaylze the freq of the input
	#pitch, hasPitch =Pitch.kr(src);
	// convert to a midi keynum, but don't round! This value will be used later.
	pitch=pitch.cpsmidi;
	//if you are within an eighth tone of an equal tempered pitch, send a trigger
	outOfTune =(pitch-pitch.round).abs<0.25;
	//if outOfTune is true, send a trigger.Limit to 1 trigger every 'limit' seconds
	SendTrig.kr(Trig.kr(outOfTune, limit), id, pitch.round);
}).add;


SynthDef(\UGen_4b,{arg id1, id2, limit=1,thresh = 0.5;
	var src, amp, ampTrig, timer;
	src =SoundIn.ar(0);
	//anaylze the amplutude input, cause a trigger if the output is over the thresh
	amp=Amplitude.kr(src);
	ampTrig=Trig.kr(amp>thresh, limit);
	//use amptrig to see how long it is between triggers
	timer=Timer.kr(ampTrig);
	//send values back with two different ids
	SendTrig.kr(ampTrig, id1, amp);
	SendTrig.kr(ampTrig,id2, amp);
}).add;


//Plays a SinOsc of the pitch you were closest to
SynthDef(\UGen_4c,{arg freq;
	Out.ar(1, SinOsc.ar(freq, 0,XLine.kr(0.1,0.00001, 0.5, doneAction:2)))
}).add;


//modulated noise to respond to amp spikes

SynthDef(\UGen_4d, {arg freq;
	Out.ar(1, LFNoise1.ar(200)*SinOsc.ar(freq,0,XLine.kr(0.1, 0.00001, 0.5, doneAction:2)));

}).add;
//SynthDef

//allocate three unique ids for the trigger ids

a=UniqueID.next;
b=UniqueID.next;
c=UniqueID.next;


//an envelope to poll foe amp values later

e=Env([440,880], [1], \exp);

//add the responder


o=OSCresponderNode(s.addr,'/tr', {arg time,  responder, msg;
	msg.postln;
	//the id sent back from the SendTrig is msg[2] us it to decide what to do
	case
	//pitch trigger
	{msg[2] ==a}
	//msg[3] is the rounded keynum
	{Synth(\UGen_4c,[\freq,msg[3].midicps])}
	//amp trigger
	{msg[2] ==b}
	//play a noise burst, higher the amp value, higher the freq(polls the Env 'e')
	{Synth(\UGen_4d, [\freq, e[msg[3]]])}
	//use the Timer value to play a delayed noise burst at 2000Hz
	{msg[2]==c}
	{SystemClock.sched(msg[3],{
		Synth(\UGen_4d,[\freq,2000]);
	})}

}).add;



//schedule the start of our listening synths...then sing or tap away on the input

SystemClock.sched(1.0,{
	Synth(\UGen_4a,[\id, a, \limit, 1]);
	Synth(\UGen_4b,[\id1, b,\id2, c, \limit, 0.2,\thresh, 0.25]);

});

//add a command period func to stop the synths and remove the responder
CmdPeriod.doOnce({
	o.remove; "Removed the responder".postln;
})



)


//randomness Generators

(
SynthDef(\UGen_ex5,{arg gate =1, seed=0, id =1, amp=1;
	var src, pitchbase, freq, rq, filt, trigger, env;
	RandID.ir(id);
	RandSeed.ir(1,seed);
	env =EnvGen.kr(Env([0,1,0],[1,4],[4,-4],1), gate, doneAction:2);
	src= WhiteNoise.ar;
	trigger=Impulse.kr(Rand.new(2,5));
	pitchbase=IRand.new(4,9) * 12;
	freq=TIRand.kr(pitchbase, pitchbase+ 12, trigger).midicps;
	rq= LFDNoise3.kr(Rand.new(0.3,0.8)).range(0.01,0.005);
	filt=Resonz.ar(src, Lag2.kr(freq),rq);
	Out.ar(0, Pan2.ar(filt,LFNoise1.kr(0.1))*env*amp)

}).add;


)

a= Synth(\UGen_ex5,[[\seed,123],[\seed,123]]);

a.release;

//Using the same seed, we get the same gesture
b=Synth(\UGen_ex5,[\seed,123]);

b.release;

//passing in different seeds

(

r=Routine.run({
	thisThread.randSeed_(123);
	10.do({
		a=Synth(\UGen_ex5,[\seed, 10000.rand.postln,\amp, 3.dbamp]);
		1.wait;
		a.release;

	})
});
)

//GVerb

(
SynthDef(\UGen_ex6,{arg gate=1, roomsize=200, revtime =450;
	var src,env,gverb;
	env=EnvGen.kr(Env([0,1,0], [1,4], [4,-4],1), gate, doneAction:2);
	src= Resonz.ar(
		Array.fill(4,{Dust.ar(6)}),
		1760* [1,2.2,3.95,8.76] + Array.fill(4, {LFNoise2.kr(1,20)}),0.01).sum*30.dbamp;
	gverb=GVerb.ar(
		src,
		roomsize,revtime,
		//feedback loop damping
		0.99,
		//input bw of signal
		LFNoise2.kr(0.1).range(0.2,0.6),
		//almost no direct source
		-60.dbamp,
		//some eary reflection
		-18.dbamp,
		//lots of tail
		3.dbamp,
		roomsize);
	Out.ar(0,gverb*env)
}).add;

)

a= Synth(\UGen_ex6);

a.release;


//for more extensions---> <http://supercollider.sourceforge.net>






