unit olahStr;

interface
	const
		Neff = 100;
	
	type
		arr = array [1..Neff] of string;
		
	function split(s : string) : arr;
	
	function strToInt(s : string) : longint;
	
	function olahTanggal(s : string) : arr;
	
	function intToStr(i : integer) : string;

	
implementation
	function split(s : string) : arr;
	var
		i,ind : integer;
	begin
		ind := 1;
		
		//Initiation
		for i := 1 to Neff do begin
			split[i] := '';
		end;
		
		//Split
		for i := 1 to length(s) do begin
			if(s[i] = '|') then begin
				ind := ind + 1;
			end
			else begin
				split[ind] := split[ind] + s[i];
			end;
		end;
		
		//Delete
		for i := 1 to ind do begin
			if(i = 1) then begin
				delete(split[i],length(split[i]),1);
			end
			else begin
				if(i <> ind) then begin
					delete(split[i],length(split[i]),1);
					delete(split[i],1,1);
				end
				else begin
					delete(split[i],1,1);
					if ( split[i][length(split[i])] = ' ') then delete(split[i],length(split[i]),1);
				end;
			end;
		end;
	end;
	
	function strToInt(s : string) : longint;
	var
		bil : longint;
		
	begin
		bil := 0;
		val(s,bil);
		strToInt := bil;
	end;
	
	function olahTanggal(s : string) : arr;
	var
		i,x : integer;
	begin
		x := 1;
		
		for i := 1 to Neff do begin
			olahTanggal[i] := '';
		end;
		
		for i := 1 to length(s) do begin
			if(s[i] = '/') then begin
				x := x+1;
			end
			else begin
				olahTanggal[x] := olahTanggal[x] + s[i];
			end;
		end;
	end;
	
	function intToStr(i : integer) : string;
	var
		s : string;
	begin
		s := '';
		str(i,s);
		intToStr := s;
	end;
end.
