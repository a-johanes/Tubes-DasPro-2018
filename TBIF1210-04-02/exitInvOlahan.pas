unit exitInvOlahan;

interface
	uses commonlib, olahStr;

	procedure tulisInvOlahan(var arrInvOlahan : typeInvOlahan; var index : integer);


var
	fin : textFile;
	s, isi, tanggal : string;
	i : integer;

implementation
	procedure tulisInvOlahan(var arrInvOlahan : typeInvOlahan; var index : integer);
	begin
		s := 'invOlahan' + intToStr(index) + '.dat';

		assign(fin,s);
		rewrite(fin);

		for i := 1 to arrInvOlahan.isiArray do begin
			tanggal := intToStr(arrInvOlahan.baris[i].tanggalOlah.d) + '/' + intToStr(arrInvOlahan.baris[i].tanggalOlah.m) + '/' + intToStr(arrInvOlahan.baris[i].tanggalOlah.y);

			isi := arrInvOlahan.baris[i].bahan + ' | ' + tanggal + ' | ' + intToStr(arrInvOlahan.baris[i].jumlah);

			writeln(fin,isi);
		end;

		close(fin);
	end;

end.
