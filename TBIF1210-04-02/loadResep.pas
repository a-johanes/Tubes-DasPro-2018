unit loadResep;

interface
	uses commonLib;

	procedure procResep(var arrResep : typeResep);

var
	fin	: TextFile;
	i,N	: integer;
	s : string;
	memory : array [1..Neff] of string;

implementation
uses olahStr;

	procedure procResep(var arrResep : typeResep);
	begin
		assign(fin,'resep.dat');
		reset(fin);
		N := 0;

		while not eof (fin) do begin

			readln(fin,s);
			N := N + 1;

			memory := split(s);

			arrResep.baris[N].namaResep := memory[1];
			arrResep.baris[N].jual := strToInt(memory[2]);
			arrResep.baris[N].jumlah := strToInt(memory[3]);

			for i := 1 to arrResep.baris[N].jumlah do begin
				arrResep.baris[N].arrBahan[i] := memory[3+i];
			end;

		end;

		if(N = 0) then begin
			writeln('Loaded Resep - File kosong (3/4)');
		end
		else begin
			writeln('Loaded Resep - File terisi (3/4)');
		end;

		arrResep.isiArray := N;
		close(fin);
		writeln();
	end;
end.
