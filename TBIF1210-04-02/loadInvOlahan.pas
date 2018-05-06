unit loadInvOlahan;
{Digunakan juga oleh unit LihatInventori.}

interface
	uses commonLib;

	procedure procInvOlahan(var arrInvOlahan : typeInvOlahan; index : integer);

var
	fin	: TextFile;
	i,N	: integer;
	s,f : string;
	memory, memoryDate : array [1..Neff] of string;


implementation
uses olahStr, sysutils;

	procedure procInvOlahan(var arrInvOlahan : typeInvOlahan; index : integer);
	begin
		f := 'invOlahan' + intToStr(index) + '.dat';
		assign(fin,f);
		N := 0;

		if(not(FileExists(f)))then begin
			rewrite(fin);
			writeln('Created Inventori Bahan Olahan - File baru (2/3)');
		end else begin
			reset(fin);
			while not eof(fin) do begin
				readln(fin,s);
				N := N + 1;

				memory := split(s);

				memoryDate := olahTanggal(memory[2]);

				arrInvOlahan.baris[N].bahan := memory[1];

				arrInvOlahan.baris[N].tanggalOlah.d := strToInt(memoryDate[1]);
				arrInvOlahan.baris[N].tanggalOlah.m := strToInt(memoryDate[2]);
				arrInvOlahan.baris[N].tanggalOlah.y := strToInt(memoryDate[3]);

				arrInvOlahan.baris[N].jumlah := strToInt(memory[3]);


			end;

			if(N = 0) then begin
				writeln('Loaded Inventori Bahan Olahan - File kosong (2/3)');
			end
			else begin
				writeln('Loaded Inventori Bahan Olahan - File terisi (2/3)');
			end;
		end;

		arrInvOlahan.isiArray := N;
		close(fin);
		writeln();
	end;
end.
