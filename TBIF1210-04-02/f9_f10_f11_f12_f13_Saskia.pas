unit f9_f10_f11_f12_f13_Saskia;

interface
	uses commonLib;

	//bagian 1

	function findIndexMentah (arrBahanMentah: typeMentah; arrInvMentah: typeInvMentah; indexInv: integer): integer;
	{Fungsi mencari index bahan dari arrInvMentah di arrBahanMentah.}

	procedure tambahHari(var date:tanggal;lama:integer);
	{I.S. Nilai date adalah tanggal awal simulasi dimulai.}
	{F.S. Nilai keluaran pada date adalah date ditambah sebanyak lama hari.}

	procedure hapusKedaluwarsa (tanggalSekarang: tanggal; arrBahanMentah: typeMentah; var arrInvMentah: typeInvMentah; var arrInvOlahan: typeInvOlahan);
	{I.S. arrInvMentah berisi bahan yang kedaluwarsa maupun tidak.}
	{F.S. arrInvMentah berisi bahan yang tidak kedaluwarsa, difilter berdasarkan arrBahanMentah.}

	procedure makan (var arrSimulasi: simulasi; var makanCount: integer; var baruTidur : boolean);
	{I.S. arrSimulasi dan makanCount terisi.}
	{F.S. Jika makanCount masih di bawah batas maksimal, energi pada arrSimulasi ditambah 3.}

	procedure istirahat (var arrSimulasi: simulasi; var istCount: integer; var baruTidur : boolean);
	{I.S. arrSimulasi dan istCount terisi.}
	{F.S. Jika istCount masih di bawah batas maksimal, energi pada arrSimulasi ditambah 1.}

	procedure tidur (var arrSimulasi: simulasi; var tanggalSekarang: tanggal; arrBahanMentah: typeMentah; var arrInvMentah: typeInvMentah; var arrInvOlahan: typeInvOlahan; var makanCount, istCount: integer; var arrRestock : typeRestock; var baruTidur: boolean);
	{I.S. arrSimulasi, arrInvMentah, arrInvOlahan terisi. tanggalSekarang adalah tanggalSekarang.}
	{F.S. Terjadi beberapa hal:
		- energi pada arrSimulasi bertambah
		- tanggalSekarang adalah tanggalSekarang ditambah 1 hari
		- Nilai makanCount dan istCount menjadi 0
		- Nilai hariHidup pada arrSimulasi bertambah 1
		- Isi arrInvMentah dan arrInvOlahan yang sudah kedaluwarsa dihapus dari array}

	//bagian 2
	function indeksTerkecilMentah (arrBahanMentah: typeInvMentah): integer;
	{Fungsi mencari indeks nilai nama bahan terkecil di arrBahanMentah.}

	function indeksTerkecilOlahan (arrBahanOlahan: typeInvOlahan): integer;
	{Fungsi mencari indeks nilai nama bahan terkecil di arrBahanOlahan.}

	function sortInvMentah (arrBahanMentah: typeInvMentah): typeInvMentah;
	{Fungsi mengurutkan isi arrBahanMentah berdasarkan nama bahan.}

	function sortInvOlahan (arrBahanOlahan: typeInvOlahan): typeInvOlahan;
	{Fungsi mengurutkan isi arrBahanOlahan berdasarkan nama bahan.}

	procedure cetakStatistik (arrSimulasi: simulasi; arrDaftarMentah: typeMentah; arrDaftarOlahan: typeOlahan; arrRestock: typeRestock);
	{I.S. Data simulasi dalam array 'simulasi'.}
	{F.S. Data simulasi dalam array dicetak ke layar.}

	procedure cetakInventori (arrBahanMentah: typeInvMentah; arrBahanOlahan: typeInvOlahan);
	{I.S. Daftar inventori bahan mentah dan bahan olahan di array 'invMentah' dan 'invOlahan'.}
	{F.S. Daftar inventori bahan mentah dan bahan olahan dicetak ke layar.}


implementation
	uses b4_restock, johanes;
	//bagian 1
	function findIndexMentah (arrBahanMentah: typeMentah; arrInvMentah: typeInvMentah; indexInv: integer): integer;
	var i: integer;
	begin
		i:= 0;
		repeat
		  i:= i + 1;
		until (arrBahanMentah.baris[i].bahan = arrInvMentah.baris[indexInv].bahan); //mencari hingga ditemukan nama bahan mentah yang sama
		findIndexMentah:= i;
	end;//akhir fungsi find

	procedure tambahHari(var date:tanggal;lama:integer);
	begin
		while (lama>0) do
		begin
			date := hariIni(date);
			lama := lama -1;
		end;
	end;//akhir procedure tambahHari

	procedure hapusKedaluwarsa (tanggalSekarang: tanggal; arrBahanMentah: typeMentah; var arrInvMentah: typeInvMentah; var arrInvOlahan: typeInvOlahan);
	var i, j,k : integer;
		//kedaluwarsa: integer;
		//tanggalAwal: tanggal;
	begin
		i:= 1;
		while (i <= arrInvMentah.isiArray) do
		begin
			j:= findIndexMentah(arrBahanMentah, arrInvMentah, i);
			//kedaluwarsa:= arrBahanMentah.baris[j].durasi;
			//tanggalAwal:= arrInvMentah.baris[i].tanggalBeli;

			if (isKadarluarsa_Mentah(arrInvMentah.baris[i],tanggalSekarang,arrBahanMentah.baris[j])) then
			begin
				for k := i to arrInvMentah.isiArray -1 do
				begin
					arrInvMentah.baris[k].bahan:= arrInvMentah.baris[k+1].bahan;
					arrInvMentah.baris[k].tanggalBeli:= arrInvMentah.baris[k+1].tanggalBeli;
					arrInvMentah.baris[k].jumlah:= arrInvMentah.baris[k+1].jumlah;
				end;
				arrInvMentah.isiArray:= arrInvMentah.isiArray - 1;
			end else
			  i:= i + 1;
		end;

		i:= 1;
		while (i <= arrInvOlahan.isiArray) do
		begin
			//kedaluwarsa:= 3;
			//tanggalAwal:= arrInvOlahan.baris[i].tanggalOlah;

			if (isKadarluarsa_Olahan(arrInvOlahan.baris[i],tanggalSekarang)) then
			begin
				for k := i to arrInvOlahan.isiArray -1 do
				begin
					arrInvOlahan.baris[k].bahan:= arrInvOlahan.baris[k+1].bahan;
					arrInvOlahan.baris[k].tanggalOlah:= arrInvOlahan.baris[k+1].tanggalOlah;
					arrInvOlahan.baris[k].jumlah:= arrInvOlahan.baris[k+1].jumlah;
				end;
				arrInvOlahan.isiArray:= arrInvOlahan.isiArray - 1;
			end else
				i:= i + 1;
		end;
	end;//akhir prosedure hapusKedaluwarsa

	procedure makan (var arrSimulasi: simulasi; var makanCount: integer; var baruTidur : boolean);
	var
		selisih :integer;
	begin
		if (arrSimulasi.energi < 10) then
		begin
			if (makanCount < 3) then
			begin
				selisih := 10 - arrSimulasi.energi;
				if (selisih <= 3) then
				begin
					arrSimulasi.energi:= arrSimulasi.energi + selisih;
					writeln('Chef makan dan mendapatkan tambahan ',selisih,' energi.');
				end else
				begin
					arrSimulasi.energi:= arrSimulasi.energi + 3;
					writeln('Chef makan dan mendapatkan tambahan 3 energi.');
				end;
				makanCount:= makanCount + 1;
				baruTidur:= false;
			end
			else writeln('Chef sudah makan 3 kali hari ini.');
		end else writeln('Energi Chef sudah penuh tidak dapat ditambah lagi.');
		writeln('Energi Chef sekarang: ',arrSimulasi.energi);
		writeln;
	end;//akhir prosedure makan

	procedure istirahat (var arrSimulasi: simulasi; var istCount: integer; var baruTidur : boolean);
	begin
		if (arrSimulasi.energi < 10) then
		begin
			if (istCount < 6) then
			begin
				arrSimulasi.energi:= arrSimulasi.energi + 1;
				istCount:= istCount + 1;
				writeln('Chef istirahat dan mendapatkan tambahan 1 energi.');
				baruTidur := false;
			end
			else writeln('Chef hanya boleh mengisi energinya sampai 10 buah energi per harinya.');
		end else writeln('Energi Chef sudah penuh tidak dapat ditambah lagi.');
		writeln('Energi Chef sekarang: ',arrSimulasi.energi);
		writeln;
	end;//akhir prosedure istirahat

	procedure tidur (var arrSimulasi: simulasi; var tanggalSekarang: tanggal; arrBahanMentah: typeMentah; var arrInvMentah: typeInvMentah; var arrInvOlahan: typeInvOlahan; var makanCount, istCount: integer; var arrRestock : typeRestock; var baruTidur: boolean);
	begin
		if baruTidur then writeln('Chef baru saja tidur, tidak dapat langsung tidur lagi')
		else
		begin
			if (arrSimulasi.energi < 10) then
			begin
				arrSimulasi.energi:= 10;
				writeln('Chef tidur dan energinya telah pulih kembali.');
			end else writeln('Chef tertidur dan hari pun berganti'); //akhir if energi < 10
			tanggalSekarang := hariIni(tanggalSekarang);
			makanCount:= 0;
			istCount:= 0;
			hapusKedaluwarsa(tanggalSekarang, arrBahanMentah, arrInvMentah, arrInvOlahan);
			write('Hari ini tanggal: ');
			writeln(tanggalSekarang.d,'/',tanggalSekarang.m,'/',tanggalSekarang.y);
			if (arrSimulasi.hariHidup < 10) then
			begin
				arrSimulasi.hariHidup:= arrSimulasi.hariHidup + 1;
				dailyRestock(arrInvMentah, arrInvOlahan, arrBahanMentah, arrRestock, arrSimulasi, tanggalSekarang, baruTidur);
			end;
			baruTidur := true;
		end;
		writeln;
	end;//akhir prosedure tidur

	//bagian 2
	function indeksTerkecilMentah (arrBahanMentah: typeInvMentah): integer;
	var i: integer;
	begin
		indeksTerkecilMentah:= 1;
		for i:=2 to arrBahanMentah.isiArray do
		begin
			if (arrBahanMentah.baris[i].bahan < arrBahanMentah.baris[indeksTerkecilMentah].bahan) then
				indeksTerkecilMentah:= i;
		end;
	end;//akhir fungsi indeksTerekcilMentah

	function indeksTerkecilOlahan (arrBahanOlahan: typeInvOlahan): integer;
	var i: integer;
	begin
		indeksTerkecilOlahan:= 1;
		for i:=2 to arrBahanOlahan.isiArray do
		begin
			if (arrBahanOlahan.baris[i].bahan < arrBahanOlahan.baris[indeksTerkecilOlahan].bahan) then
				indeksTerkecilOlahan:= i;
		end;
	end;//akhir fungsi indeksTerkecilOlahan

	function sortInvMentah (arrBahanMentah: typeInvMentah): typeInvMentah;
	var i, j,k: integer;
	begin
		sortInvMentah.isiArray:= 0;
		for j:= 1 to arrBahanMentah.isiArray do
		begin
			i:= indeksTerkecilMentah(arrBahanMentah);
			sortInvMentah.baris[j].bahan:= arrBahanMentah.baris[i].bahan;
			sortInvMentah.baris[j].tanggalBeli:= arrBahanMentah.baris[i].tanggalBeli;
			sortInvMentah.baris[j].jumlah:= arrBahanMentah.baris[i].jumlah;
			sortInvMentah.isiArray:= sortInvMentah.isiArray + 1;
			for k := i to arrBahanMentah.isiArray -1  do
			begin
				arrBahanMentah.baris[k].bahan:= arrBahanMentah.baris[k+1].bahan;
				arrBahanMentah.baris[k].tanggalBeli:= arrBahanMentah.baris[k+1].tanggalBeli;
				arrBahanMentah.baris[k].jumlah:= arrBahanMentah.baris[k+1].jumlah;
			end;
			arrBahanMentah.isiArray:= arrBahanMentah.isiArray - 1;
		end;
	end;//akhir fungsi sortInvMentah

	function sortInvOlahan (arrBahanOlahan: typeInvOlahan): typeInvOlahan;
	var i, j,k: integer;
	begin
		sortInvOlahan.isiArray:= 0;
		for j:= 1 to arrBahanOlahan.isiArray do
		begin
			i:= indeksTerkecilOlahan(arrBahanOlahan);
			sortInvOlahan.baris[j].bahan:= arrBahanOlahan.baris[i].bahan;
			sortInvOlahan.baris[j].tanggalOlah:= arrBahanOlahan.baris[i].tanggalOlah;
			sortInvOlahan.baris[j].jumlah:= arrBahanOlahan.baris[i].jumlah;
			sortInvOlahan.isiArray:= sortInvOlahan.isiArray + 1;
			for k := i to arrBahanOlahan.isiArray -1  do
			begin
				arrBahanOlahan.baris[k].bahan:= arrBahanOlahan.baris[k+1].bahan;
				arrBahanOlahan.baris[k].tanggalOlah:= arrBahanOlahan.baris[k+1].tanggalOlah;
				arrBahanOlahan.baris[k].jumlah:= arrBahanOlahan.baris[k+1].jumlah;
			end;
			arrBahanOlahan.isiArray:= arrBahanOlahan.isiArray - 1;
		end;
	end;//akhir fungsi sortInvOlahan

	procedure cetakStatistik (arrSimulasi: simulasi; arrDaftarMentah: typeMentah; arrDaftarOlahan: typeOlahan; arrRestock: typeRestock);
	var
		pilihan: string;
		i, j: integer;
	begin


		write('Masukan data yang ingin dilihat (ex: help): ');
		readln(pilihan);

		if (pilihan = 'help') then
		begin
			writeln('========================== LIST COMMAND YANG TERSEDIA ========================');
			writeln('bahan mentah: Menampilkan daftar bahan mentah yang dapat dibeli dari supermarket.');
			writeln('bahan olahan: Menampilkan daftar bahan olahan yang dapat dibuat.');
			writeln('simulasi: Menampilkan statistik simulasi.');
			writeln('restock: Menampilkan daftar bahan yang direstock secara otomatis dari supermarket.');
			writeln;
		end else if (pilihan = 'bahan mentah') then
			begin
				writeln('============================= DAFTAR BAHAN MENTAH ============================');
				for i:= 1 to arrDaftarMentah.isiArray do
					begin
						writeln(arrDaftarMentah.baris[i].bahan, ' | ', arrDaftarMentah.baris[i].harga, ' | ', arrDaftarMentah.baris[i].durasi);
					end;
				writeln;
			end
		else if (pilihan = 'bahan olahan') then
			begin
				writeln('============================= DAFTAR BAHAN OLAHAN ============================');
				for i:= 1 to arrDaftarOlahan.isiArray do
				begin
					writeln('Olahan ', i);
					writeln('Nama olahan : ', arrDaftarOlahan.baris[i].olahan);
					writeln('Harga jual  : ', arrDaftarOlahan.baris[i].jual);
					write('Bahan       : ', arrDaftarOlahan.baris[i].arrBahan[1]);
					j:= 2;
					while (arrDaftarOlahan.baris[i].arrBahan[j] <> '') do
					begin
						write(', ',arrDaftarOlahan.baris[i].arrBahan[j]);
						j:= j + 1;
					end;
					writeln;
					writeln;
				end;
			end
		else if (pilihan = 'simulasi') then
			begin
				writeln('================================= STATISTIK ==================================');
				writeln('Nomor simulasi               : ', arrSimulasi.no);
				writeln('Tanggal awal simulasi        : ', arrSimulasi.tanggalSimulasi.d, '/', arrSimulasi.tanggalSimulasi.m, '/', arrSimulasi.tanggalSimulasi.y);
				writeln('Jumlah hari hidup            : ', arrSimulasi.hariHidup);
				writeln('Jumlah energi                : ', arrSimulasi.energi);
				writeln('Kapasitas maksimum inventori : ', arrSimulasi.kapMaksInv);
				writeln('Total bahan mentah dibeli    : ', arrSimulasi.sumMentahBeli);
				writeln('Total bahan olahan dibuat    : ', arrSimulasi.sumOlahBuat);
				writeln('Total bahan olahan dijual    : ', arrSimulasi.sumOlahJual);
				writeln('Total resep dijual           : ', arrSimulasi.sumResepJual);
				writeln('Total pemasukan              : ', arrSimulasi.income);
				writeln('Total pengeluaran            : ', arrSimulasi.outcome);
				writeln('Total uang                   : ', arrSimulasi.saldo);
				writeln;
			end
		else if (pilihan = 'restock') then
		begin
			writeln('============================= DAFTAR BAHAN RESTOCK ============================');
			for i:= 1 to arrRestock.isiArray do
			begin
				writeln('Nama bahan: ',arrDaftarMentah.baris[arrRestock.baris[i].idxBahan].bahan);
				writeln('Jumlah: ',arrRestock.baris[i].jumlah);
				writeln('Jeda restock: ',arrRestock.baris[i].jedaBeli);
				writeln('Tanggal restock selanjutnya: ',arrRestock.baris[i].nextBeli.d,'/',arrRestock.baris[i].nextBeli.m,'/',arrRestock.baris[i].nextBeli.y);
				writeln;
			end;
			writeln;
		end else
		begin
			writeln('Maaf command tidak dikenali. Coba panggil command help.');
			writeln;
		end;
	end;//akhir procedure setakStatistik

	procedure cetakInventori (arrBahanMentah: typeInvMentah; arrBahanOlahan: typeInvOlahan);
	var i: integer;
	begin
		arrBahanMentah:= sortInvMentah(arrBahanMentah);
		writeln('======= INVENTORI BAHAN MENTAH =======');
		for i:= 1 to arrBahanMentah.isiArray do
		begin
			writeln(arrBahanMentah.baris[i].bahan, ' | ', arrBahanMentah.baris[i].tanggalBeli.d, '/', arrBahanMentah.baris[i].tanggalBeli.m, '/', arrBahanMentah.baris[i].tanggalBeli.y, ' | ', arrBahanMentah.baris[i].jumlah);
		end;
		writeln;
		arrBahanOlahan:= sortInvOlahan(arrBahanOlahan);
		writeln('======= INVENTORI BAHAN OLAHAN =======');
		for i:= 1 to arrBahanOlahan.isiArray do
		begin
			writeln(arrBahanOlahan.baris[i].bahan, ' | ', arrBahanOlahan.baris[i].tanggalOlah.d, '/', arrBahanOlahan.baris[i].tanggalOlah.m, '/', arrBahanOlahan.baris[i].tanggalOlah.y, ' | ', arrBahanOlahan.baris[i].jumlah);
		end;
	end;//akhir procedure cetakInventori
end.
