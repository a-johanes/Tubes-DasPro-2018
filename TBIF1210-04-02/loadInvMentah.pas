unit loadInvMentah;
{Digunakan juga oleh unit LihatInventori.}

interface
	uses commonLib;

	procedure procInvMentah(var arrInvMentah : typeInvMentah; index : integer);

var
	fin	: TextFile;
	i,N	: integer;
	s,f : string;
	memory, memoryDate : array [1..Neff] of string;


implementation
uses olahStr, sysutils;

	procedure procInvMentah(var arrInvMentah : typeInvMentah; index : integer);
	begin
		f := 'invMentah' + intToStr(index) + '.dat';
		assign(fin,f);
		N := 0;

		if(not(FileExists(f)))then begin
			rewrite(fin);
			writeln('Created Inventori Bahan Mentah - File baru (1/3)');
		end else begin
			reset(fin);

			while not eof(fin) do begin
				readln(fin,s);
				N := N+1;

				memory := split(s);

				memoryDate := olahTanggal(memory[2]);

				arrInvMentah.baris[N].bahan := memory[1];

				arrInvMentah.baris[N].tanggalBeli.d := strToInt(memoryDate[1]);
				arrInvMentah.baris[N].tanggalBeli.m := strToInt(memoryDate[2]);
				arrInvMentah.baris[N].tanggalBeli.y := strToInt(memoryDate[3]);

				arrInvMentah.baris[N].jumlah := strToInt(memory[3]);


			end;

			if(N = 0) then begin
				writeln('Loaded Inventori Bahan Mentah - File kosong (1/3)');
			end
			else begin
				writeln('Loaded Inventori Bahan Mentah - File terisi (1/3)');
			end;
		end;

		arrInvMentah.isiArray := N;
		close(fin);
		writeln();
	end;
end.
