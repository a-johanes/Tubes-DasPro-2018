unit loadExit;

interface
uses loadBahanMentah, loadBahanOlahan, loadInvMentah, loadInvOlahan, loadResep, loadSimulasi, compExitProgram, exitInvMentah, exitInvOlahan, commonLib,olahStr;


	procedure loadProgram(var bahanMentah : typeMentah; var bahanOlahan : typeOlahan; var resep : typeResep; var simulasi : typeSimulasi);

	{I.S : user melakukan pemanggilan pada program untuk load file external
	F.S : 4 file external ter-load ke dalam 4 array tipe bentukan}
	
	procedure exitProgram(var bahanMentah : typeMentah; var bahanOlahan : typeOlahan;  var resep : typeResep; var simulasi : typeSimulasi);
	
	{I.S : user keluar dari program
	F.S : seluruh data hasil kerja user disimpan di file external}
	
	procedure loadSimulasi(var invMentah : typeInvMentah; var invOlahan : typeInvOlahan;var index : integer);
	{I.S : ketika user melakukan input simulasi ke - N
	F.S : array inventori ke - N}
	
	procedure exitSimulasi(var invMentah : typeInvMentah; var invOlahan : typeInvOlahan; var index : integer);
	
	{I.S : user keluar dari simulasi ke - n
	F.S : data inventori mentah dan olahan diubah dan langsung di save ke file external}

	procedure fileBaru(var invMentah : typeInvMentah; var invOlahan : typeInvOlahan; var index : integer);
	{I.S : user memulai simulasi dengan nomor baru}
	{F.S : terbentuk file inventori mentah dan inventori olahan baru sesuai index}


implementation

	procedure loadProgram(var bahanMentah : typeMentah; var bahanOlahan : typeOlahan; var resep : typeResep; var simulasi : typeSimulasi);
	begin
		procBahanMentah(bahanMentah);
		procBahanOlahan(bahanOlahan);
		procResep(resep);
		procSimulasi(simulasi);
	end;
	
	procedure exitProgram(var bahanMentah : typeMentah; var bahanOlahan : typeOlahan;  var resep : typeResep; var simulasi : typeSimulasi);
	begin
		tulisBahanMentah(bahanMentah);
		tulisBahanOlahan(bahanOlahan);
		tulisResep(resep);
		tulisSimulasi(simulasi);
	end;
	
	procedure loadSimulasi(var invMentah : typeInvMentah; var invOlahan : typeInvOlahan;var index : integer);
	begin
		procInvMentah(invMentah, index);
		procInvOlahan(invOlahan, index);
	end;
	
	procedure exitSimulasi(var invMentah : typeInvMentah; var invOlahan : typeInvOlahan; var index : integer);
	begin
		tulisInvMentah(invMentah,index);
		tulisInvOlahan(invOlahan,index);
	end;
	
	procedure fileBaru(var invMentah : typeInvMentah; var invOlahan : typeInvOlahan; var index : integer);
	var
		s  : string;
		fin : textFile;
	begin
		s := 'invMentah' + intToStr(index) + '.dat';
		assign(fin,s);
		rewrite(fin);
		close(fin);
		s := 'invOlahan' + intToStr(index) + '.dat';
		assign(fin,s);
		rewrite(fin);
		close(fin);
	end;
end.
