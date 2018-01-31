(SynthDef(\sound2,{
	arg outBus=0, freq=770, dur=5,amp=0.1,gate=1;
	var env, env2, env3,out,a,b,c;
	// Env.perc args are (attackTime,releaseTime,level), so any level over 1 will create distortion -- and when you add more than one synths playing with envelopes, they all add together creating even more distortion -- I've modified the arguments below so they work without distorting
	env=EnvGen.kr(Env.asr(0.1,amp,0.1),gate,timeScale: dur,doneAction: 2);
// Env.perc args are (attackTime,releaseTime,level),
	env2=EnvGen.kr(Env.perc(1,2,100));
	env3=EnvGen.kr(Env.perc(3,4,200));
	a=SinOsc.ar(freq, 0,env);
	// adding the freq env instead of * because * makes the freq numbers HUGE!
	b=SinOsc.ar(freq+env2, 0,env);
	c=SinOsc.ar(freq+env3,0,env);
	out = a+b+c;
	Out.ar(outBus, out.dup);
}).add;
)
a = Synth(\sound2);
a.release;


(SynthDef(\a,{
	arg outBus=0, freq=441,dur=0.1,amp=1,gate=1;
	var env,env2,env3, out,a;



	env=EnvGen.kr(Env.asr(0.1,amp,0.1),gate,timeScale: dur,doneAction: 2);
	env2=EnvGen.kr(Env.perc(1,2,freq));
	env3=	Env.adsr(0.01,0.3,0.5,1);
	//a=PMOsc.ar(freq+Line.kr(2000,17000,15),Line.kr(4000,40000,4),Line.kr(300,30,3));
	a=SinOsc.ar(freq, 0,env3);
	//b=Pulse.ar(freq/2+env2,dur);
	out=a;
	Out.ar(outBus,out.dup);

}).add;
)
a=Synth(\a);






