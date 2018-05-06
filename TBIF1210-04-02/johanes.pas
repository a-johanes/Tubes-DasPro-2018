unit  johanes;
{menjual bahan olahan. Hanya bahan olahan yang belum kadaluarsa yang dapat 
dijual. Kadaluarasa dihitung berdasarkan tanggal pada inventori dan tanggal simulasi. Setiap bahan 
olahan kadaluarsa 3 hari setelah dibuat. Penjualan bahan olahan mengurangi inventori, menambah 
pemasukan, dan mengurangi energi Chef sebanyak 1 buah. }
interface
	uses commonLib,sysutils;
	
	//f7_jualOlahan
	function isKabisat(tmpTahun:integer) : boolean;
	{fungsi bernilai True jika tanggal yang dimasukan merupakan tahun kabisat,
	bernilai False jika bukan}
	
	function hariIni(tanggal:tanggal) : tanggal;
	{fungsi yang menghasilkan tanggal hari ini dari input tanggal kemarin}
	
	function isKadarluarsa_Olahan(bahan:invOlahan;tanggal:tanggal) : boolean;
	{fungsi untuk mengecek apakah sudah kadarluarsa. Fungsi bernilai True
	jika sudah >= 3 hari sejak tanggal dibuat, bernilai False jika tidak.}
	
	function whereIsIO(dicari:string;tabInvOlahan:typeInvOlahan) : integer;
	{fungsi untuk mengeluarkan indeks letak bahan yang dicari berada untuk inventori olahan}
	
	function whereIsBO(dicari:string;tabBahan:typeOlahan) : integer;
	{fungsi untuk mengeluarkan indeks letak bahan yang dicari berada untuk list bahan olahan}

	procedure kurangiInvOlahan(nama : string;var tabInvOlahan:typeInvOlahan;jumlah :integer);
	{posedur untuk mengurangi jumlah bahan olahan dari inventori}
	
	procedure updateInvSimulasi_JualOlahan(harga:longint ;var data:simulasi;jumlah : integer);
	{prosedur yang mengupdate data pada simulasi: energi, total bahan olahan dijual, total pemasukan, total pendapatan}
	
	procedure menjualOlahan(today: tanggal; tabBahan:typeOlahan ;var data:simulasi; var tabInvOlahan:typeInvOlahan; var baruTidur : boolean);
	{prosedur lengkap dalam menjual bahan olahan}
	
	//f8_jualResep
	function isKadarluarsa_Mentah(mentah:invMentah;tanggal:tanggal;dataMentah:bahanMentah) : boolean;
	{fungsi untuk mengecek apakah sudah kadarluarsa. Fungsi bernilai True
	jika sudah => durasi kadarluarsa dari data bahan mentah, bernilai False jika tidak.}
	
	function whereIsIM(dicari:string;tabInvMentah:typeInvMentah) : integer;
	{fungsi untuk mengeluarkan indeks letak bahan mentah yang dicari yang berada di inventori mentah}

	function whereIsBM(dicari:string;tabBahanMentah:typeMentah) : integer;
	{fungsi untuk mengeluarkan indeks letak bahan mentah yang dicari berada di array bahan mentah}

	function whereIsResep(dicari:string;tabResep:typeResep) : integer;
	{fungsi untuk mengeluarkan indeks letak resep yang dicari}
	
	function adaBahanResep(tabInvOlahan:typeInvOlahan; tabInvMentah:typeInvMentah; tabBahanMentah: typeMentah;dataResep:resep;today:tanggal) : boolean ;
	{fungsi bernilai true jika semua bahan-bahan yang diperlukan untuk membuat resep ada}
	
	procedure kurangiInvMentah(indeks:integer;var tabInvMentah:typeInvMentah);
	{posedur untuk mengurangi jumlah bahan mentah dari inventori pada indeks tertentu}
	
	procedure updateInv_Resep(dataResep: resep; var tabInvOlahan : typeInvOlahan; var tabInvMentah:typeInvMentah);
	{prosedure yang mengupdate isi InvOlahan dan InvMentah berdasarkan data bahan dari dataResep}
	
	procedure updateInvSimulasi_JualResep(harga:longint ;var data:simulasi);
	{prosedur yang mengupdate data pada simulasi: energi, total bahan resep dijual, total pemasukan, total pendapatan}

	procedure menjualResep(today : tanggal; tabResep:typeResep; tabBahanMentah : typeMentah; var tabInvOlahan:typeInvOlahan; var tabInvMentah:typeInvMentah;var data:simulasi; var baruTidur : boolean);
	{prosedur lengkap dalam menjual resep}

implementation
	uses f5_f6_f14_f15_f16_Ardi;
	//f7_jualOlahan
	function isKabisat(tmpTahun:integer) : boolean;
	begin
		if (((tmpTahun mod 4 = 0) and (tmpTahun mod 100 <> 0)) or (tmpTahun mod 400 = 0)) then isKabisat := True
		else isKabisat := False;
	end;
	
	function hariIni(tanggal:tanggal) : tanggal;
	var
		ini : tanggal;
		day,month,year:integer;
	begin
		day := tanggal.d;
		month := tanggal.m;
		year := tanggal.y;
		if ((month = 1) or ( month = 3) or (month = 5) or ( month =7) or (month = 8) or ( month = 10) or (month=12)) then //bulan dengan jumlah hari 31
		begin
			if (day = 31) then //kemarin tanggal 31
			begin
				if (month=12) then //kemarin bulan desember
				begin
					ini.d := 1;
					ini.m := 1;
					ini.y := year+1;
				end else//kemarin bukan bulan desember
				begin
					ini.d := 1;
					ini.m := month + 1;
					ini.y := year;
				end; //akhir dari pengecekan desember
			end else //kemarin bukan tanggal 31
			begin
				ini.d := day +1;
				ini.m := month;
				ini.y := year;
			end; //akhir dari pengecekan tanggal 31
		end else if ((month=4) or (month=6) or (month=9) or (month=11)) then //bulan dengan jumlah hari 30
		begin
			if (day =30) then //kemari tanggal 30
			begin
				ini.d := 1;
				ini.m := month + 1;
				ini.y := year;
			end else //kemarin bukan tanggal 30
			begin
				ini.d := day +1;
				ini.m := month;
				ini.y := year;
			end; //akhir dari pengecekan tanggal 30
		end else if (month = 2) then // bulan februari
		begin
			if (day = 28) then //kemarin tanggal 28
			begin
				if (isKabisat(year)) then //jika tanggal 28 pada tahun kabisat
				begin
					ini.d := day +1;
					ini.m := month;
					ini.y := year;
				end else //jika 28 di tahun bukan kabisat
				begin
					ini.d := 1;
					ini.m := month + 1;
					ini.y := year;
				end; // akhir dari isKabisat
			end else if (day = 29) then // jika kemarin tanggal 29
			begin
				ini.d := 1;
				ini.m := month + 1;
				ini.y := year;
			end else //kemarin bukan tanggal 29 ataupun 28
			begin
				ini.d := day +1;
				ini.m := month;
				ini.y := year;
			end; //akhir dari cek tanggal bulan februari	
		end; // akhir cek bulan
		hariIni := ini;
	end;//akhir fungsi hariIni

	function isKadarluarsa_Olahan(bahan:invOlahan;tanggal:tanggal): boolean;
	var
		day,month,year :integer;
	begin
		day := tanggal.d;
		month := tanggal.m;
		year := tanggal.y;
		if ((bahan.tanggalOlah.y <> year)and (bahan.tanggalOlah.m <> 12)) then isKadarluarsa_Olahan := True //jika beda tahun
		else //jika tahun pembuatan sama
		begin
			if (bahan.tanggalOlah.m = month) then //jika pada bulan yang sama
			begin
				if(bahan.tanggalOlah.d + 3 <= day) then isKadarluarsa_Olahan := True //hari ini sudah lewat atau tepat 3 hari setelah tanggal pembuatan bahan olahan
				else isKadarluarsa_Olahan := False; // hari ini belum lewat tanggal kadarluarsa
			end else // jika pada bulan yang berbeda
			begin
				if ((month = 1) or (month = 2) or (month=4) or (month=6) or (month = 8) or (month=9) or (month=11)) then //bulan yang bulan sebelumnya jumlah harinya 31
				begin
					if (day >= 3) then isKadarluarsa_Olahan := True //jika beda bulan dan hari bulan itu lebih dari 3 maka sudah pasti kadarluarsa
					else if (((day+31) - bahan.tanggalOlah.d) >=3) then isKadarluarsa_Olahan := True // jika selisihnya lebih besar atau sama dengan 3 maka kadarluarsa
					else isKadarluarsa_Olahan := False; //jika selisihnya kurang dari 3
				end else if ((month = 5) or ( month =7) or ( month = 10) or (month=12)) then // bulan yang bulan sebelumnya jumlah harinya 30
				begin
					if (day >= 3) then isKadarluarsa_Olahan := True //jika beda bulan dan hari bulan itu lebih dari 3 maka sudah pasti kadarluarsa
					else if (((day+30) - bahan.tanggalOlah.d) >=3) then isKadarluarsa_Olahan := True // jika selisihnya lebih besar atau sama dengan 3 maka kadarluarsa
					else isKadarluarsa_Olahan := False; //jika selisihnya kurang dari 3
				end else if (month = 3) then // bulan yang bulan sebelumnya harinya antara 29 atau 28
				begin
					if (isKabisat(year)) then
					begin// tahun kabisat
						if (day >= 3) then isKadarluarsa_Olahan := True //jika beda bulan dan hari bulan itu lebih dari 3 maka sudah pasti kadarluarsa
						else if (((day+29) - bahan.tanggalOlah.d) >=3) then isKadarluarsa_Olahan := True // jika selisihnya lebih besar atau sama dengan 3 maka kadarluarsa
						else isKadarluarsa_Olahan := False; //jika selisihnya kurang dari 3	
					end else //bukan kabisat
					begin	
						if (day >= 3) then isKadarluarsa_Olahan := True //jika beda bulan dan hari bulan itu lebih dari 3 maka sudah pasti kadarluarsa
						else if (((day+28) - bahan.tanggalOlah.d) >=3) then isKadarluarsa_Olahan := True // jika selisihnya lebih besar atau sama dengan 3 maka kadarluarsa
						else isKadarluarsa_Olahan := False; //jika selisihnya kurang dari 3
					end; // akhir dari isKabisat
				end; //akhir dari fungsi bulan
			end;//akhir perbandingan tanggal dengan memperhatikan bulan
		end;//akhir perbandingan tanggal dengan memperhatikan tahun
	end;//akhir fungsi isKadarluarsa_Olahan
		
	function whereIsIO(dicari:string;tabInvOlahan:typeInvOlahan) : integer;
	var
		i : integer;
		found : boolean;
	begin
		i := 1;
		found := false;
		while ( (i<=tabInvOlahan.isiArray) and (not(found)) ) do
		begin
			if (tabInvOlahan.baris[i].bahan = dicari) then found := true
			else i := i +1; //akhir if
		end;// akhir while
		if (found) then whereIsIO := i
		else whereIsIO := 0;
	end;// akhir fungsi cari
	
	function whereIsBO(dicari:string;tabBahan:typeOlahan) : integer;
	var
		i : integer;
		found : boolean;
	begin
		i := 1;
		found := false;
		while ( (i<=tabBahan.isiArray) and (not(found)) ) do
		begin
			if (tabBahan.baris[i].olahan = dicari) then found := true
			else i := i +1; //akhir if
		end;// akhir while
		if (found) then whereIsBO := i
		else whereIsBO := 0;
	end;// akhir fungsi cari
	
	procedure kurangiInvOlahan(nama : string;var tabInvOlahan:typeInvOlahan;jumlah :integer);
	var
		i,j : integer;
	begin
		i := 1;
		repeat
			if (tabInvOlahan.baris[i].bahan = nama) then
			begin//jika namanya sama
				if (tabInvOlahan.baris[i].jumlah <= jumlah) then //jika jumlah itemnya jadi 0 maka hilangkan
				begin//jika jumlahnya pas atau kurang
					jumlah -= tabInvOlahan.baris[i].jumlah;
					for j := i to tabInvOlahan.isiArray do //menggeser semua data dari i+1 ke idx ke i
					begin
						tabInvOlahan.baris[j] := tabInvOlahan.baris[j+1];
					end;//akhir for
					tabInvOlahan.isiArray := tabInvOlahan.isiArray-1; //mengurangi jumlah data pada array
					i -=1;
				end else //jumlahnya lebih banyak dari yang akan dikurangi
				begin
					tabInvOlahan.baris[i].jumlah -= jumlah;
					jumlah := 0;
				end;
			end;//akhir if namanya sama
			i += 1;
		until (jumlah = 0);
	end;// akhir prosedur kurangiInvOlahan
	
	procedure updateInvSimulasi_JualOlahan(harga:longint ;var data:simulasi;jumlah : integer);
	begin
		data.energi := data.energi -1 ; //mengurangi energi
		data.sumOlahJual := data.sumOlahJual + jumlah; //menambah jumlah barang terjual
		data.income := data.income + harga; //menambah pendapatan sesuai harga
		data.saldo := data.saldo + harga; //menambah saldo sesuai harga
	end;//akhir prosedur updateInvSim
	
	procedure jumlahOlahan (namanya : string ; tabInvOlahan : typeInvOlahan ; var jumlah : integer);
	var
		i : integer;
	begin
		jumlah := 0;
		for i := 1 to tabInvOlahan.isiArray do
		begin
			if (tabInvOlahan.baris[i].bahan = namanya) then jumlah += tabInvOlahan.baris[i].jumlah;
		end;
	end;
	
	procedure menjualOlahan(today: tanggal; tabBahan:typeOlahan ; var data: simulasi; var tabInvOlahan:typeInvOlahan; var baruTidur : boolean);
	var
		idxJual, idxHarga,jumlahDiInv: integer;
		jumlah,harga,tmp:longint;
		bahan,input :string;
	begin
		if (data.energi = 0) then writeln('Penjualan gagal karena energi tidak mencukupi. Total energi saat ini: ',data.energi,'.') // energi =0
		else//energi > 0
		begin
			write('Masukan nama bahan olahan yang akan dijual: ');
			readln(input); //meminta masukkan
			if TryStrToInt(input,tmp) then
			begin //masukkan berupa angka
				writeln('Input harus berupa nama bahan olahan!');
			end else// masukkan berupa suatu string
			begin
				bahan := input; //mengassign variabel bahan dengan string dari input
				idxJual := whereIsIO(bahan,tabInvOlahan); //mencari indeks letak nama bahan di dalam inventori
				if (idxJual = 0) then writeln('Penjualan gagal karena tidak ada ',bahan,' dalam inventori.') //tidak ada bahannya
				else //idxJual>0 (ada bahannya)
				begin
					if (isKadarluarsa_Olahan(tabInvOlahan.baris[idxJual],today)) then writeln('Penjualan gagal karena ', bahan,' telah kadarluarsa.') //bahan telah kadarluarsa
					else 
					begin// bahan tidak kadarluarsa
						write('Jumlah bahan olahan yang akan dijual: ');
						validateInputInteger(jumlah);//cek apakah input merupakan integer positif
						if(jumlah <> -1)then begin
							jumlahOlahan(bahan, tabInvOlahan,jumlahDiInv);
							if (jumlah > jumlahDiInv) then writeln('Jumlah ', bahan,' di inventori hanya ',jumlahDiInv,'.')
							else //jumlahnya cukup
							begin
								idxHarga := whereIsBO(bahan,tabBahan); //mencari indeks letak nama bahan di dalam array bahan untuk dicari harganya
								harga := tabBahan.baris[idxHarga].jual* jumlah; //menentukan harga jualnya
								writeln('Penjualan ',bahan,' telah berhasil!');
								writeln('Energi telah berkurang 1.');
								writeln('Jumlah bahan olahan di inventori telah berkurang.');
								writeln('Total pemasukan telah bertambah sebesar Rp',harga,'.');
								kurangiInvOlahan(bahan,tabInvOlahan,jumlah);
								updateInvSimulasi_JualOlahan(harga,data,jumlah);
								baruTidur := false;
							end;  // akhir dari cek jumlah
						end; //akhir validasi positif
					end;//akhir if kadarluarsa
				end;// akhir if idx 0
			end;//akhir cek masukkan harus string
		end;//akhir cek energi
		writeln;
	end;//akhir prosedure
	
	//f8_jualResep
	function isKadarluarsa_Mentah(mentah:invMentah;tanggal:tanggal;dataMentah:bahanMentah) : boolean;
	var
		day,month,year,durasi :integer;
	begin
		day := tanggal.d;
		month := tanggal.m;
		year := tanggal.y;
		durasi := dataMentah.durasi;
		if ((mentah.tanggalBeli.y <> year) and (mentah.tanggalBeli.m <> 12)) then isKadarluarsa_Mentah := True //jika beda tahun
		else //jika tahun pembelian sama
		begin
			if (mentah.tanggalBeli.m = month) then //jika pada bulan yang sama
			begin
				if(mentah.tanggalBeli.d + durasi <= day) then isKadarluarsa_Mentah := True //hari ini sudah lewat atau tepat tanggal kadarluarsa setelah tanggal pembelian
				else isKadarluarsa_Mentah := False; // hari ini belum lewat tanggal kadarluarsa
			end else // jika pada bulan yang berbeda
			begin
				if ((month = 1) or (month = 2) or (month=4) or (month=6) or (month = 8) or (month=9) or (month=11)) then //bulan yang bulan sebelumnya jumlah harinya 31
				begin
					if (day >= durasi) then isKadarluarsa_Mentah := True //jika beda bulan dan hari bulan itu lebih dari durasi kadarluarsa lama maka sudah pasti kadarluarsa
					else if (((day+31) - mentah.tanggalBeli.d) >=durasi) then isKadarluarsa_Mentah := True // jika selisihnya lebih besar atau sama dengan durasi waktunya maka kadarluarsa
					else isKadarluarsa_Mentah := False; //jika selisihnya kurang dari durasi waktunya
				end else if ((month = 5) or ( month =7) or ( month = 10) or (month=12)) then // bulan yang bulan sebelumnya jumlah harinya 30
				begin
					if (day >= durasi) then isKadarluarsa_Mentah := True //jika beda bulan dan hari bulan itu lebih dari durasi kadarluarsanya maka sudah pasti kadarluarsa
					else if (((day+30) - mentah.tanggalBeli.d) >=durasi) then isKadarluarsa_Mentah := True // jika selisihnya lebih besar atau sama dengan durasi kadarluarsanya maka kadarluarsa
					else isKadarluarsa_Mentah := False; //jika selisihnya kurang dari durasi kadarluarsanya
				end else if (month = 3) then // bulan yang bulan sebelumnya harinya antara 29 atau 28
				begin
					if (isKabisat(year)) then
					begin//untuk tahun kabisat
						if (day >= durasi) then isKadarluarsa_Mentah := True //jika beda bulan dan hari bulan itu lebih dari durasi kadarluarsanya maka sudah pasti kadarluarsa
						else if (((day+29) - mentah.tanggalBeli.d) >=durasi) then isKadarluarsa_Mentah := True // jika selisihnya lebih besar atau sama dengan durasinya maka kadarluarsa
						else isKadarluarsa_Mentah := False; //jika selisihnya kurang dari durasinya
					end else //bukan kabisat
					begin	
						if (day >= durasi) then isKadarluarsa_Mentah := True //jika beda bulan dan hari bulan itu lebih dari durasinya maka sudah pasti kadarluarsa
						else if (((day+28) - mentah.tanggalBeli.d) >=durasi) then isKadarluarsa_Mentah := True // jika selisihnya lebih besar atau sama dengan durasi maka kadarluarsa
						else isKadarluarsa_Mentah := False; //jika selisihnya kurang dari durasi
					end; // akhir dari isKabisat
				end; //akhir dari fungsi bulan
			end;//akhir perbandingan tanggal dengan memperhatikan bulan
		end;//akhir perbandingan tanggal dengan memperhatikan tahun
	end;//akhir fungsi isKadarluarsa_Mentah

	function whereIsIM(dicari:string;tabInvMentah:typeInvMentah) : integer;
	var
		i : integer;
		found : boolean;
	begin
		i := 1;
		found := false;
		while ( (i<=tabInvMentah.isiArray) and (not(found)) ) do
		begin
			if (tabInvMentah.baris[i].bahan = dicari) then found := true
			else i := i +1; //akhir if
		end;// akhir while
		if (found) then whereIsIM := i
		else whereIsIM := 0;
	end;// akhir fungsi cari IM
	
	function whereIsBM(dicari:string;tabBahanMentah:typeMentah) : integer;
	var
		i : integer;
		found : boolean;
	begin
		i := 1;
		found := false;
		while ( (i<=tabBahanMentah.isiArray) and (not(found)) ) do
		begin
			if (tabBahanMentah.baris[i].bahan = dicari) then found := true
			else i := i +1; //akhir if
		end;// akhir while
		if (found) then whereIsBM := i
		else whereIsBM := 0;
	end;// akhir fungsi cari BM
	
	function whereIsResep(dicari:string;tabResep:typeResep) : integer;
	var
		i : integer;
		found : boolean;
	begin
		i := 1;
		found := false;
		while ( (i<=tabResep.isiArray) and (not(found)) ) do
		begin
			if (tabResep.baris[i].namaResep = dicari) then found := true
			else i := i +1; //akhir if
		end;// akhir while
		if (found) then whereIsResep := i
		else whereIsResep := 0;
	end;// akhir fungsi cari Resep
	
	function adaBahanResep(tabInvOlahan:typeInvOlahan; tabInvMentah:typeInvMentah; tabBahanMentah: typeMentah; dataResep:resep; today:tanggal) : boolean ;
	var
		i,idxOlahan,idxMentah,idxB_Mentah : integer;
		adaOlahan,adaMentah: boolean;
	begin
		i := 1;
		adaOlahan := true;
		adaMentah := true;
		while ((i<=dataResep.jumlah)and(adaOlahan or adaMentah)) do
		begin
			idxOlahan := whereIsIO(dataResep.arrBahan[i],tabInvOlahan);
			if (idxOlahan = 0) then adaOlahan := false// tidak ada indexnya			
			else //ada idxnya
			begin
				if (isKadarluarsa_Olahan(tabInvOlahan.baris[idxOlahan],today)) then adaOlahan := false//ad idx tapi kadarluarsa
				else if (tabInvOlahan.baris[idxOlahan].jumlah = 0) then adaOlahan := false //ada idx, tidak kadarluarsa namun jumlahnya 0
				else adaOlahan := true;//ada idx, tidak kadarluarsa dan jumlahnya tidak 0				
			end;

			idxMentah := whereIsIM(dataResep.arrBahan[i],tabInvMentah);
			idxB_Mentah := whereIsBM(dataResep.arrBahan[i],tabBahanMentah);
			if(idxMentah = 0) then adaMentah := false //tidak ada indexnya
			else//ada idxnya 
			begin
				if (isKadarluarsa_Mentah(tabInvMentah.baris[idxMentah],today,tabBahanMentah.baris[idxB_Mentah])) then adaMentah := false //ada namun sudah kadarluarsa
				else if (tabInvMentah.baris[idxMentah].jumlah = 0) then adaMentah := false //ada idx, tidak kadarluarsa namun jumlahnya 0
				else adaMentah := true;//ada idx,tidak kadarluarsa dan jumlahnya tidak 0
			end;
			i := i +1;
		end;//akhir while
		adaBahanResep := adaOlahan or adaMentah;
	end;//akhir fungsi adaBahanResep
	
	procedure kurangiInvMentah(indeks:integer;var tabInvMentah:typeInvMentah);
	var
		i : integer;
	begin
		if (tabInvMentah.baris[indeks].jumlah =1) then //jika jumlah itemnya jadi 0 maka hilangkan
		begin
			for i := indeks to tabInvMentah.isiArray do //menggeser semua data dari i+1 ke idx ke i
			begin
				tabInvMentah.baris[i] := tabInvMentah.baris[i+1];
			end;
			tabInvMentah.isiArray := tabInvMentah.isiArray-1; //mengurangi jumlah data pada array
		end else //jika tidak habis, kurangi nilai jumlahnya
		begin
			tabInvMentah.baris[indeks].jumlah := tabInvMentah.baris[indeks].jumlah -1;
		end; //akhir if 
	end;// akhir prosedur kurangiInvMentah
	
	procedure updateInv_Resep(dataResep: resep; var tabInvOlahan : typeInvOlahan; var tabInvMentah:typeInvMentah);
	var
		i,idxOlahan,idxMentah : integer;
		nama : string;
	begin
		for i := 1 to dataResep.jumlah do
		begin
			idxOlahan := whereIsIO(dataResep.arrBahan[i],tabInvOlahan);
			nama := tabInvOlahan.baris[idxOlahan].bahan;
			if (idxOlahan > 0) then kurangiInvOlahan(nama,tabInvOlahan,1);//jika ada datanya maka kurangi
			
			idxMentah := whereIsIM(dataResep.arrBahan[i],tabInvMentah);
			if(idxMentah > 0) then kurangiInvMentah(idxMentah,tabInvMentah); //jika ada datanya maka kurangi
		end;//akhir for
	end;//akhir prosedur updateInv_Resep
	
	procedure updateInvSimulasi_JualResep(harga:longint ;var data:simulasi);
	begin
		data.energi := data.energi -1 ; //mengurangi energi
		data.sumResepJual := data.sumResepJual +1; //menambah jumlah barang terjual
		data.income := data.income + harga; //menambah pendapatan sesuai harga
		data.saldo := data.saldo + harga; //menambah saldo sesuai harga
	end;//akhir prosedur updateInvSim
	
	procedure menjualResep(today : tanggal; tabResep:typeResep; tabBahanMentah : typeMentah; var tabInvOlahan:typeInvOlahan; var tabInvMentah:typeInvMentah;var data:simulasi; var baruTidur : boolean);
	var
		idxResep, harga: integer;
		tmp : longint;
		resep,input:string;
	begin
		if (data.energi = 0) then writeln('Penjualan gagal karena energi tidak mencukupi. Total energi saat ini: ',data.energi,'.') //energi = 0
		else
		begin //energi > 0
			write('Masukan nama resep yang akan dijual: ');
			readln(input);
			if TryStrToInt(input,tmp) then
			begin //masukkan berupa angka
				writeln('Input harus berupa nama resep!');
			end else// masukkan berupa suatu string
			begin
				resep := input;
				idxResep := whereIsResep(resep,tabResep);
				if (idxResep = 0) then writeln('Penjualan gagal karena tidak ada terdapat resep membuat ',resep,' dalam inventori.') //tidak ada resepnya
				else//ada resepnya
				begin
					if(adaBahanResep(tabInvOlahan,tabInvMentah,tabBahanMentah,tabResep.baris[idxResep],today)) then
					begin//ada bahan semuanya
						harga := tabResep.baris[idxResep].jual;
						writeln('Penjualan resep telah berhasil!');
						writeln('Energi telah berkurang 1.');
						writeln('Jumlah bahan-bahan di inventori telah berkurang.');
						writeln('Total pemasukan telah bertambah sebesar Rp',harga,'.');
						updateInv_Resep(tabResep.baris[idxResep],tabInvOlahan,tabInvMentah);
						updateInvSimulasi_JualResep(harga,data);
						baruTidur := false;
					end else 
					begin//ada bahan yang tidak ada
						writeln('Pembuatan resep ',resep,' gagal karena ada bahan Olahan atau bahan Mentah yang kurang.');
					end;//akhir if adaBahanResep
				end;// akhir if idxResep = 0
			end; //akhir cek masukkan harus berupa string
		end;//akhir cek energi
		writeln;
	end;//akhir prosedure menjualResep
end.
