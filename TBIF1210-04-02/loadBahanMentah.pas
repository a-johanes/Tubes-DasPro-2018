unit loadBahanMentah;

interface
	uses commonLib;

	procedure procBahanMentah(var arrBahanMentah : typeMentah);
	{Procedure yang mengolah inputan dari file external menjadi array pada data bahan mentah}

var
	fin	: TextFile;
	i,N	: integer;
	s : string;
	memory : array [1..Neff] of string;

implementation
uses olahStr;

	procedure procBahanMentah(var arrBahanMentah : typeMentah);
	begin
		assign(fin,'bahanMentah.dat');
		reset(fin);
		N := 0;
		while not eof(fin) do begin
			readln(fin,s);

			N := N+1;
			memory := split(s);

			arrBahanMentah.baris[N].bahan := memory[1];
			arrBahanMentah.baris[N].harga := strToInt(memory[2]);
			arrBahanMentah.baris[N].durasi := strToInt(memory[3]);
		end;

		if(N = 0) then begin
			writeln('Loaded Bahan Mentah - File kosong (1/4)');
		end
		else begin
			writeln('Loaded Bahan Mentah - File terisi (1/4)');
		end;

		arrBahanMentah.isiArray := N;
		close(fin);
		writeln();
	end;
end.
