function func_dotencode(instr) {
	split(instr, dotdata, ".");
	retstr=dotdata[1];
	for (tmpkey = 2; tmpkey <= length(dotdata); tmpkey++) {
		retstr=retstr"_"dotdata[tmpkey];
	}
	return retstr;
}
BEGIN{
	#print "start"
	DEBUG=0;
	OUTPUTPREFIX="OUTPUT";
}
/^#/{ #print "comment=" $0 ;
	next; 
}
{ 
	if ($1 == "#") {
		print "skipping # line=" $0
		next;
	}
	if (DEBUG > 0) print "goodline:"  NF ":=" $0;
	split($1,shadata,"@");
	SHASTRING=shadata[2];
	split(shadata[1],mydata,"/");
	REPO=mydata[1]

	PROJ="UNKNOWN" #default
	if (REPO == "591444126380.dkr.ecr.us-east-1.amazonaws.com") { PROJ="ECR"; };
	if (REPO == "gcr.io") { PROJ="GCRIO"; };
	if (REPO == "index.docker.io") { PROJ="DCRHUB"; };

	if (length(mydata)==1) { print "skipping bad row=" $0 ; next; }
	if (length(mydata)>2) { PROJ=PROJ"__"func_dotencode(mydata[2]); }
	if (length(mydata)==3) { PROJ=PROJ"__"func_dotencode(mydata[3]); }
	if (length(mydata)>3) { PROJ=PROJ"__"func_dotencode(mydata[3])"-"func_dotencode(mydata[length(mydata)]); }

	OUTPUTFN=PROJ".tar.gz"
	if (DEBUG > 0) print "extracted repo=#" REPO "#, OUTPUTFN=#" OUTPUTFN "#, SHA=#" SHASTRING "#"
	system("echo docker pull \"" $0 "\"");
	system("docker pull \"" $0 "\"");
	system("echo docker save \"" $0 "\" -o \"" OUTPUTPREFIX "\"/\"" OUTPUTFN "\"");
	system("docker save \"" $0 "\" -o \"" OUTPUTPREFIX "\"/\"" OUTPUTFN "\"");
	#"echo docker save \"" $0 " -o \"" OUTPUTPREFIX"/\""OUTPUTFN;
}
END{
	#print "end"
}
