(* ::Package:: *)

(* ::Input::Initialization:: *)
BeginPackage["LeCroyParser`"];
ImportLecroyBinary::usage="ImportLecroyBinary[\"filename\"] returns data in the form {{t1,V1},{t2,V2,...}}.";
ImportLecroyBinary::argnumfew="ImportLecroyBinary was called with `1` arguments. At least 1 expected.";
ImportLecroyBinary::argnummany="ImportLecroyBinary was called with `1` arguments. At most 2 expected.";
Begin["`Private`"];
ImportLecroyBinary[filename_,verbose_:False]:=Block[{data,xdata,ydata,buffer,file,posWavedesc,header,waveDesc,template,commType,commOrder,byteOrdering,waveDescriptor,userText,trigTimeArray,waveArray1,instrumentName,instrumentNumber,traceLabel,waveArrayCount,verticalGain,verticalOffset,nominalBits,horizontalInterval,horizontalOffset,verticalUnits,horizontalUnits,triggerTime,recordType,processingDone,timeBase,verticalCoupling,probeAttenuation,fixedVerticalGain,bandwidthLimit,verticalVernier,acqVerticalOffset,channel,verticalScale,timeScale,sampleRate,wave},
(* Identify the header block *)
file=OpenRead[filename,BinaryFormat->True];
If[file==$Failed,Return[Null]];
posWavedesc=StringPosition[StringJoin@BinaryReadList[file,"Character8",50],"WAVEDESC",1][[1,1]];
(* Parse header block *)
file=OpenRead[filename,BinaryFormat->True];
header=StringJoin@BinaryReadList[file,"Character8",posWavedesc-1]; (* identifier *)
waveDesc=StringJoin@BinaryReadList[file,"Character8",16]; (* wave descriptor *)
template=StringJoin@BinaryReadList[file,"Character8",16]; (* template *)
commType=First@BinaryReadList[file,"Integer16",1]; (* comm type {0\[Rule]Integer8, 1\[Rule]Integer16} *)
commOrder=First@BinaryReadList[file,"Integer16",1]; (* byte ordering: {0\[Rule]"HIFIRST", 1\[Rule]"LOFIRST"} *)
byteOrdering=Switch[commOrder,0,+1,1,-1,_,$ByteOrdering];
waveDescriptor=StringJoin@BinaryReadList[file,"Character8",4,ByteOrdering->byteOrdering ]; (* wave descriptor *)
userText=StringJoin@BinaryReadList[file,"Character8",8,ByteOrdering->byteOrdering]; (* user text *)
trigTimeArray=StringJoin@BinaryReadList[file,"Character8",12,ByteOrdering->byteOrdering]; (* trigger time array *)
waveArray1=First@BinaryReadList[file,"Integer32",1,ByteOrdering->byteOrdering]; (* wave array 1 (number of samples, vertical) *)
buffer=BinaryReadList[file,"Byte",12]; (* unknown *)
instrumentName=StringJoin@BinaryReadList[file,"Character8",16,ByteOrdering->byteOrdering]; (* instrument name *)
instrumentNumber=First@BinaryReadList[file,"Integer32",1,ByteOrdering->byteOrdering]; (* instrument number *)
traceLabel=StringJoin@BinaryReadList[file,"Character8",16,ByteOrdering->byteOrdering]; (* trace label *)
buffer=BinaryReadList[file,"Byte",4]; (* unknown *)
waveArrayCount=First@BinaryReadList[file,"Integer32",1,ByteOrdering->byteOrdering]; (* wave array count (number of samples, horizontal *)
buffer=BinaryReadList[file,"Byte",36]; (* unknown *)
verticalGain=First@BinaryReadList[file,"Real32",1,ByteOrdering->byteOrdering]; (* vertical gain *)
verticalOffset=First@BinaryReadList[file,"Real32",1,ByteOrdering->byteOrdering]; (* vertical offset *)
buffer=BinaryReadList[file,"Byte",8]; (* unknown *)
nominalBits=First@BinaryReadList[file,"Integer16",1,ByteOrdering->byteOrdering]; (* nominal bits *)
buffer=BinaryReadList[file,"Byte",2]; (* unknown *)
horizontalInterval=First@BinaryReadList[file,"Real32",1,ByteOrdering->byteOrdering]; (* horizontal interval *)
horizontalOffset=First@BinaryReadList[file,"Real64",1,ByteOrdering->byteOrdering]; (* horizontal offset *)
buffer=BinaryReadList[file,"Byte",8]; (* unknown *)
verticalUnits=StringJoin@BinaryReadList[file,"Character8",48,ByteOrdering->byteOrdering]; (* vertical units *)
horizontalUnits=StringJoin@BinaryReadList[file,"Character8",48,ByteOrdering->byteOrdering]; (* horizontal units *)
buffer=BinaryReadList[file,"Byte",4]; (* unknown *)
triggerTime=First@BinaryReadList[file,{"Real64","Integer8","Integer8","Integer8","Integer8","Integer16"},1,ByteOrdering->byteOrdering]; (* trigger time {s,m,h,D,M,Y} *)
buffer=BinaryReadList[file,"Byte",6]; (* unknown *)
recordType={"single sweep","interleaved","histogram","histogram","graph","filter coefficient","complex","extrema","sequence obsolete","centered RIS","peak detect"}[[1+First@BinaryReadList[file,"Integer16",1,ByteOrdering->byteOrdering]]]; (* record type *)
processingDone={"no processing","fir filter","interpolated","sparsed","autoscaled","no result","rolling","cumulative"}[[1+First@BinaryReadList[file,"Integer16",1,ByteOrdering->byteOrdering]]]; (* processing type *)
buffer=BinaryReadList[file,"Byte",4]; (* unknown *)
timeBase=({1.,2.,5.}[[1+Mod[#,3]]]10^(Floor[#/3]-12))&@(First@BinaryReadList[file,"Integer16",1,ByteOrdering->byteOrdering]); (* timebase *)
verticalCoupling={"DC50\[CapitalOmega]","ground","DC1M\[CapitalOmega]","ground","AC1M\[CapitalOmega]"}[[1+First@BinaryReadList[file,"Integer16",1,ByteOrdering->byteOrdering]]]; (* coupling type *)
probeAttenuation=First@BinaryReadList[file,"Real32",1,ByteOrdering->byteOrdering]; (* probe attenuation *)
fixedVerticalGain=({1.,2.,5.}[[1+Mod[#,3]]]10^(Floor[#/3]-6))&@(First@BinaryReadList[file,"Integer16",1,ByteOrdering->byteOrdering]); (* fixed vertical gain *)
bandwidthLimit=BinaryReadList[file,"Integer16",1,ByteOrdering->byteOrdering]; (* bandwidth limit: {0\[Rule]"OFF",1\[Rule]"ON"} *)
verticalVernier=BinaryReadList[file,"Real32",1,ByteOrdering->byteOrdering]; (* vertical vernier *)
acqVerticalOffset=BinaryReadList[file,"Real32",1,ByteOrdering->byteOrdering]; (* acquisition vertical offset *)
channel=1+First@BinaryReadList[file,"Integer16",1,ByteOrdering->byteOrdering]; (* channel on the oscilloscope *)
verticalScale=ToString[TraditionalForm[EngineeringForm[fixedVerticalGain probeAttenuation]]]<>" V/div";
timeScale=ToString[TraditionalForm[EngineeringForm[timeBase]]]<>" s/div";
sampleRate=ToString[TraditionalForm[EngineeringForm[1/horizontalInterval]]]<>" Samples/s";
If[verbose,Print["Vertical scale: "<>verticalScale,"Horizontal scale: "<>timeScale,"Sampling rate: "<>sampleRate]];
(* Parse data *)
wave=BinaryReadList[file,Switch[commType,0,"Integer8",1,"Integer16",_,"Integer8"],waveArray1]; (* wave data *)
ydata=wave verticalGain-verticalOffset;
xdata=Range[waveArrayCount]horizontalInterval+horizontalOffset;
Return[{xdata,ydata}\[Transpose]]
]
ImportLecroyBinary[args___]:=(If[Length[{args}]<1,Message[ImportLecroyBinary::argnumfew,Length[{args}]],Message[ImportLecroyBinary::argnummany,Length[{args}]]];$Failed)
End[];
EndPackage[];
