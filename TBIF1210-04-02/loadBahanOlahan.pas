unit loadBahanOlahan;

interface
	uses commonLib;

	procedure procBahanOlahan(var arrBahanOlahan : typeOlahan);

var
	fin	: TextFile;
	i,j,N	: integer;
	s : string;
	memory : array [1..Neff] of string;


implementation
uses olahStr;

	procedure procBahanOlahan(var arrBahanOlahan : typeOlahan);
	begin
		assign(fin,'bahanOlahan.dat');
		reset(fin);
		N := 0;

		while not eof(fin) do begin
			readln(fin,s);
			N := N+1;

			memory := split(s);

			arrBahanOlahan.baris[N].olahan := memory[1];
			arrBahanOlahan.baris[N].jual := strToInt(memory[2]);
			arrBahanOlahan.baris[N].jumlah := strToInt(memory[3]);

			for i := 1 to arrBahanOlahan.baris[N].jumlah do begin
				arrBahanOlahan.baris[N].arrBahan[i] := memory[3+i];
			end;
		end;

		if(N = 0) then begin
			writeln('Loaded Bahan Olahan - File kosong (2/4)');
		end
		else begin
			writeln('Loaded Bahan Olahan - File terisi (2/4)');
		end;

		arrBahanOlahan.isiArray := N;
		close(fin);
		writeln();
	end;
end.
