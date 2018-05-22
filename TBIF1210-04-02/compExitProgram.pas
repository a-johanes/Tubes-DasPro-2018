unit compExitProgram;

interface
	uses commonlib;
	
	procedure tulisBahanMentah(var arrBahanMentah : typeMentah);
	
	procedure tulisBahanOlahan(var arrBahanOlahan : typeOlahan);
	
	procedure tulisResep(var arrResep : typeResep);
	
	procedure tulisSimulasi(var arrSimulasi : typeSimulasi);
	
var
	fin : textFile;
	s, isi, tanggal : string;
	i,j : integer;
	
implementation
uses olahStr;

	procedure tulisBahanMentah(var arrBahanMentah : typeMentah);
	begin
		s := 'bahanMentah' + '.dat';
		
		writeln('File disimpan di ',s);
		assign(fin,s);
		rewrite(fin);
		if (arrBahanMentah.isiArray > 0 ) then 
		begin
			for i := 1 to arrBahanMentah.isiArray do begin
				isi := arrBahanMentah.baris[i].bahan + ' | ' + intToStr(arrBahanMentah.baris[i].harga) + ' | ' + intToStr(arrBahanMentah.baris[i].durasi);
		
				writeln(fin,isi);
			end;
		end;
		
		close(fin);
	end;
	
	procedure tulisBahanOlahan(var arrBahanOlahan : typeOlahan);
	begin
		s := 'bahanOlahan' + '.dat';
		
		writeln('File disimpan di ',s);
		assign(fin,s);
		rewrite(fin);
		if (arrBahanOlahan.isiArray > 0) then
		begin
			for i := 1 to arrBahanOlahan.isiArray do begin
				isi := arrBahanOlahan.baris[i].olahan + ' | ' + intToStr(arrBahanOlahan.baris[i].jual) + ' | ' + intToStr(arrBahanOlahan.baris[i].jumlah);
				
				for j := 1 to arrBahanOlahan.baris[i].jumlah do begin
					isi := isi + ' | ' + arrBahanOlahan.baris[i].arrBahan[j];
				end;
				
				writeln(fin,isi);
			end;
		end;
		
		close(fin);
	end;
	
	procedure tulisResep(var arrResep : typeResep);
	begin
		s := 'resep' + '.dat';
		
		writeln('File disimpan di ',s);
		assign(fin,s);
		rewrite(fin);
		if (arrResep.isiArray > 0  ) then
		begin
			for i := 1 to arrResep.isiArray do begin
				isi := arrResep.baris[i].namaResep + ' | ' + intToStr(arrResep.baris[i].jual) + ' | ' + intToStr(arrResep.baris[i].jumlah);
				
				for j := 1 to arrResep.baris[i].jumlah do begin
					isi := isi + ' | ' + arrResep.baris[i].arrBahan[j];
				end;
				
				writeln(fin,isi);
			end;
		end;
		
		close(fin);
	end;
	
	procedure tulisSimulasi(var arrSimulasi : typeSimulasi);
	begin
		s := 'simulasi' + '.dat';
		
		writeln('File disimpan di ',s);
		assign(fin,s);
		rewrite(fin);
		if (arrSimulasi.isiArray > 0 ) then
		begin
			for i := 1 to arrSimulasi.isiArray do begin
				tanggal := intToStr(arrSimulasi.baris[i].tanggalSimulasi.d) + '/' + intToStr(arrSimulasi.baris[i].tanggalSimulasi.m) + '/' + intToStr(arrSimulasi.baris[i].tanggalSimulasi.y);
				
				isi := intToStr(arrSimulasi.baris[i].no) + ' | ' + tanggal + ' | ' + intToStr(arrSimulasi.baris[i].hariHidup) + ' | ' + intToStr(arrSimulasi.baris[i].energi) + ' | ' + intToStr(arrSimulasi.baris[i].kapMaksInv) + ' | ' + intToStr(arrSimulasi.baris[i].sumMentahBeli) + ' | ' + intToStr(arrSimulasi.baris[i].sumOlahBuat) + ' | ' + intToStr(arrSimulasi.baris[i].sumOlahJual) + ' | ' + intToStr(arrSimulasi.baris[i].sumResepJual) + ' | ' + intToStr(arrSimulasi.baris[i].income) + ' | ' + intToStr(arrSimulasi.baris[i].outcome) + ' | ' + intToStr(arrSimulasi.baris[i].saldo);
							
				writeln(fin,isi);
			end;
		end;
		close(fin);
	end;
end.
