unit loadSimulasi;

interface
	uses commonLib;

	procedure procSimulasi(var arrSimulasi : typeSimulasi);

var
	fin	: TextFile;
	i,N	: integer;
	s : string;
	memory, memoryDate : array [1..Neff] of string;

implementation
uses olahStr;

	procedure procSimulasi(var arrSimulasi : typeSimulasi);
	begin
		assign(fin,'simulasi.dat');
		reset(fin);
		N := 0;

		while not eof(fin) do begin
			readln(fin,s);
			N := N + 1;

			memory := split(s);
			memoryDate := olahTanggal(memory[2]);

			arrSimulasi.baris[N].no := strToInt(memory[1]);

			arrSimulasi.baris[N].tanggalSimulasi.d := strToInt(memoryDate[1]);
			arrSimulasi.baris[N].tanggalSimulasi.m := strToInt(memoryDate[2]);
			arrSimulasi.baris[N].tanggalSimulasi.y := strToInt(memoryDate[3]);

			arrSimulasi.baris[N].hariHidup := strToInt(memory[3]);
			arrSimulasi.baris[N].energi := strToInt(memory[4]);
			arrSimulasi.baris[N].kapMaksInv := strToInt(memory[5]);
			arrSimulasi.baris[N].sumMentahBeli := strToInt(memory[6]);
			arrSimulasi.baris[N].sumOlahBuat := strToInt(memory[7]);
			arrSimulasi.baris[N].sumOlahJual := strToInt(memory[8]);
			arrSimulasi.baris[N].sumResepJual := strToInt(memory[9]);
			arrSimulasi.baris[N].income := strToInt(memory[10]);
			arrSimulasi.baris[N].outcome := strToInt(memory[11]);
			arrSimulasi.baris[N].saldo := strToInt(memory[12]);

		end;

		if(N = 0) then begin
			writeln('Loaded Simulasi - File kosong (4/4)');
		end
		else begin
			writeln('Loaded Simulasi - File terisi (4/4)');
		end;

		arrSimulasi.isiArray := N;
		close(fin);
		writeln();
	end;
end.
