unit exitInvMentah;

interface
	uses commonlib, olahStr;

	procedure tulisInvMentah(var arrInvMentah : typeInvMentah; var index : integer);


var
	fin : textFile;
	s, isi, tanggal : string;
	i : integer;

implementation
	procedure tulisInvMentah(var arrInvMentah : typeInvMentah; var index : integer);
	begin
		s := 'invMentah' + intToStr(index) + '.dat';

		assign(fin,s);
		rewrite(fin);

		for i := 1 to arrInvMentah.isiArray do begin
			tanggal := intToStr(arrInvMentah.baris[i].tanggalBeli.d) + '/' + intToStr(arrInvMentah.baris[i].tanggalBeli.m) + '/' + intToStr(arrInvMentah.baris[i].tanggalBeli.y);

			isi := arrInvMentah.baris[i].bahan + ' | ' + tanggal + ' | ' + intToStr(arrInvMentah.baris[i].jumlah);

			writeln(fin,isi);
		end;

		close(fin);

	end;

end.
