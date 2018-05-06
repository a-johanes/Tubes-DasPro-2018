unit b4_restock;

interface
	uses commonlib;

  procedure loadRestock(var arrRestock : typeRestock; idxSim : integer);
		//I.S. : tidak ada file penyimpanan data restock atau ada file dengan atau tanpa data di dalamnya
		//F.S. : membuat file baru jika tidak ada file, membaca isi file jika ada dan menyimpannya di dalam arrRestock

	procedure tulisRestock(arrRestock : typeRestock; idxSim : integer);
		//I.S. : file penyimpanan data restock berisi data lama
		//F.S. : memperbaharui file penyimpanan data restock

	procedure tambahRestock(var arrRestock : typeRestock; arrBahanMentah : typeMentah;arrInvMentah : typeInvMentah; today : tanggal);
		//I.S. : daftar bahan mentah yang akan direstock
		//F.S. : menambah bahan mentah baru ke dalam daftar restock

  procedure deleteRestock(var arrRestock : typeRestock; arrBahanMentah : typeMentah);
		//I.S. : daftar restock berisi bahan mentah
		//F.S. : menghapus salah satu entri jika ditemukan di dalamnya

  procedure dailyRestock(var daftarInvMentah : typeInvMentah; daftarInvOlahan : typeInvOlahan; arrBahanMentah : typeMentah; var arrRestock : typeRestock; var dataSimulasi : simulasi; today : tanggal; baruTidur : boolean);
		//I.S. : daftar bahan mentah yang akan di restock
		//F.S. : merestock bahan mentah jika tanggal restock dijadwalkan hari ini

implementation
  uses f5_f6_f14_f15_f16_Ardi, olahStr, johanes, sysutils;

	procedure loadRestock(var arrRestock : typeRestock; idxSim : integer);
		//I.S. : tidak ada file penyimpanan data restock atau ada file dengan atau tanpa data di dalamnya
		//F.S. : membuat file baru jika tidak ada file, membaca isi file jika ada dan menyimpannya di dalam arrRestock
    var
      fin : textFile;
      s, path : string;
      i : integer;
    	memory, memoryDate : array [1..Neff] of string;
    begin
      path := 'dataRestock' + intToStr(idxSim) + '.dat';
      assign(fin, path);
      i := 0;

      if(not(FileExists(path)))then begin
				//file tidak ditemukan
        rewrite(fin);
  			writeln('Created Restock - File kosong (3/3)');
      end else begin //file ditemukan, mulai membaca
    		reset(fin);

        while not eof(fin) do begin
    			readln(fin,s);
          i := i + 1;

          memory := split(s);
          arrRestock.baris[i].idxBahan := strToInt(memory[1]);
          arrRestock.baris[i].jumlah := strToInt(memory[2]);
          arrRestock.baris[i].jedaBeli := strToInt(memory[3]);

    			memoryDate := olahTanggal(memory[4]);
          arrRestock.baris[i].nextBeli.d := strToInt(memoryDate[1]);
          arrRestock.baris[i].nextBeli.m := strToInt(memoryDate[2]);
          arrRestock.baris[i].nextBeli.y := strToInt(memoryDate[3]);

        end;

        if(i = 0) then begin
    			writeln('Loaded Restock - File kosong (3/3)');
    		end else begin
    			writeln('Loaded Restock - File terisi (3/3)');
    		end;

      end;

      arrRestock.isiArray := i;
      close(fin);
      writeln();
    end;

	procedure tulisRestock(arrRestock : typeRestock; idxSim : integer);
		//I.S. : file penyimpanan data restock berisi data lama
		//F.S. : memperbaharui file penyimpanan data restock
    var
    	fout : textFile;
    	s, isi, tanggal : string;
    	i : integer;
  	begin
  		s := 'dataRestock' + intToStr(idxSim) + '.dat';

  		assign(fout, s);
  		rewrite(fout);

  		for i := 1 to arrRestock.isiArray do begin
  			tanggal := intToStr(arrRestock.baris[i].nextBeli.d) + '/' + intToStr(arrRestock.baris[i].nextBeli.m) + '/' + intToStr(arrRestock.baris[i].nextBeli.y);

  			isi := intToStr(arrRestock.baris[i].idxBahan) + ' | ' + intToStr(arrRestock.baris[i].jumlah) + ' | ' + intToStr(arrRestock.baris[i].jedaBeli) + ' | ' + tanggal;

  			writeln(fout, isi);
  		end;

  		close(fout);
  	end;

	function restockFound(arrRestock : typeRestock; indeks : integer):integer;
		//mencari apakah integer indeks terdapat pada typeRestock
    var
      flag : boolean;
      i : integer;
    begin
      flag := false;
      i := 1;
      while(not(flag) and (i <= arrRestock.isiArray))do begin
        if(arrRestock.baris[i].idxBahan = indeks)then
          flag := true;
        i := i + 1;
      end;
      if(flag)then
        restockFound := i - 1
      else
        restockFound := -1;
    end;

	procedure tambahRestock(var arrRestock : typeRestock; arrBahanMentah : typeMentah;arrInvMentah : typeInvMentah; today : tanggal);
		//I.S. : daftar bahan mentah yang akan direstock
		//F.S. : menambah bahan mentah baru ke dalam daftar restock
    var
		namaBahan : string;
		kuantitas,jeda: longint;
		idxinvMentah,idxBahanMentah  : integer;
    begin
		write('Nama bahan  : ');
		readln(namaBahan); //input

		idxBahanMentah := cariPosisiBahanMentah(namaBahan, arrBahanMentah);
		idxInvMentah := whereIsIM(namaBahan,arrInvMentah);

		if(idxBahanMentah = -1)then
			// input bahan mentah tidak tersedia
			writeln('ERROR: ', namaBahan, ' tidak tersedia di supermarket.')
		else if(restockFound(arrRestock, idxBahanMentah) <> -1)then
			// bahan sudah ada di daftar restock
			writeln('ERROR: ', namaBahan, ' sudah ada di daftar restock.')
		else // nama bahan mentah baru
		begin
			if (idxInvMentah = 0) then writeln('ERROR: ', namaBahan, ' tidak tersedia di inventori.')
			else //ada di inventori sekarang
			begin
				write('Kuantitas : ');
				validateInputInteger(kuantitas); //cek apakah input integer positif

				if(kuantitas <> -1)then 
				begin
					write('Jeda beli (dalam hari) : ');
					validateInputInteger(jeda); //cek apakah input integer positif
					if((jeda <> -1) and (jeda <= 1))then
						writeln('ERROR: Jeda harus lebih dari 1 hari.')
					else if ( (jeda <> -1 ) and (jeda > 1) ) then //jeda > 1
					begin
						//tambah list bahan yang akan direstock
						arrRestock.isiArray := arrRestock.isiArray + 1;

						arrRestock.baris[arrRestock.isiArray].idxBahan := idxBahanMentah;
						arrRestock.baris[arrRestock.isiArray].jumlah := kuantitas;
						arrRestock.baris[arrRestock.isiArray].jedaBeli := jeda;

						arrRestock.baris[arrRestock.isiArray].nextBeli := hariIni(today);

						writeln('Daftar restock berhasil diubah!');
						writeln('Restock bahan ini akan dimulai besok.');
					end;//akhir cek jeda
				end;//akhir cek kuantitas
			end;//akhir cek ketersediaan di inventori
		end;//akhir cek dari list bahan mentah
	writeln;
    end; // akhir procedure tambahRestock

	procedure deleteRestock(var arrRestock : typeRestock; arrBahanMentah : typeMentah);
		//I.S. : daftar restock berisi bahan mentah
		//F.S. : menghapus salah satu entri jika ditemukan di dalamnya
    var
		namaBahan : string;
		idxBahanMentah, idxRestock, i : integer;
    begin
		write('Nama bahan  : ');
		readln(namaBahan); //input

		idxBahanMentah := cariPosisiBahanMentah(namaBahan, arrBahanMentah);
		idxRestock := restockFound(arrRestock, idxBahanMentah);

		if(idxBahanMentah = -1)then
			// input bahan mentah tidak tersedia
			writeln('ERROR: ', namaBahan, ' tidak tersedia di supermarket.')
		else if(idxRestock = -1)then
			//idxRestock tidak ditemkan di typeRestock
			writeln('ERROR: ', namaBahan, ' tidak ada di daftar restock.')
		else 
		begin
			//menggeser semua entri setelah item yang dihapus
			i := idxRestock ;
			while(i <= arrRestock.isiArray-1) do 
			begin
				arrRestock.baris[i] := arrRestock.baris[i+1];
				i += 1;
			end;
			arrRestock.isiArray -= 1;
			writeln(namaBahan, ' berhasil dihapus dari daftar restock.')
		end;
	writeln;
    end;

	procedure dailyRestock(var daftarInvMentah : typeInvMentah; daftarInvOlahan : typeInvOlahan; arrBahanMentah : typeMentah; var arrRestock : typeRestock; var dataSimulasi : simulasi; today : tanggal; baruTidur : boolean);
		//I.S. : daftar bahan mentah yang akan di restock
		//F.S. : merestock bahan mentah jika tanggal restock dijadwalkan hari ini
    var
		i, j,idxInvMentah : integer;
		adaRestock: boolean;
		hargaTotal : longint;
    begin
		adaRestock := false;
		for i:=1 to arrRestock.isiArray do
		begin
			if(isTanggalSama(arrRestock.baris[i].nextBeli, today))then 
			begin
				hargaTotal := arrBahanMentah.baris[arrRestock.baris[i].idxBahan].harga * arrRestock.baris[i].jumlah;

				writeln('Mencoba restock ', arrBahanMentah.baris[arrRestock.baris[i].idxBahan].bahan, ' sejumlah ', arrRestock.baris[i].jumlah);
				writeln('Harga Satuan: ', arrBahanMentah.baris[arrRestock.baris[i].idxBahan].harga);
				writeln('Total Harga : ', hargaTotal);
				
				idxInvMentah := whereIsIM(arrBahanMentah.baris[arrRestock.baris[i].idxBahan].bahan,daftarInvMentah);
				
				if (idxInvMentah = 0) then writeln('ERROR: Bahan yang akan direstock tidak ada di inventori.') //tidak ada bahan mentahnya di inventori 
				else if((dataSimulasi.kapMaksInv - jumlahIsiInventori(daftarInvMentah, daftarInvOlahan)) < arrRestock.baris[i].jumlah)then 
				begin
					// besar inventori tidak mencukupi
					writeln('ERROR: Inventori tidak cukup untuk restock.');
					writeln('Mencoba restock besok.');
					arrRestock.baris[i].nextBeli := hariIni(arrRestock.baris[i].nextBeli);
				end else if(dataSimulasi.saldo < hargaTotal)then 
				begin // uang tidak mencukupi
					writeln('ERROR: Uang tidak cukup untuk restock.');
					writeln('Mencoba restock besok.');
					arrRestock.baris[i].nextBeli := hariIni(arrRestock.baris[i].nextBeli);
				end else 
				begin // beli berhasil
					adaRestock := true;
					dataSimulasi.saldo := dataSimulasi.saldo - hargaTotal;
					dataSimulasi.sumMentahBeli := dataSimulasi.sumMentahBeli + arrRestock.baris[i].jumlah;

					daftarInvMentah.isiArray := daftarInvMentah.isiArray + 1;

					daftarInvMentah.baris[daftarInvMentah.isiArray].bahan := arrBahanMentah.baris[arrRestock.baris[i].idxBahan].bahan;
					daftarInvMentah.baris[daftarInvMentah.isiArray].tanggalBeli := today;
					daftarInvMentah.baris[daftarInvMentah.isiArray].jumlah := arrRestock.baris[i].jumlah;
					//menambah hari nextBeli sebanyak jeda hari
					for j:=1 to arrRestock.baris[i].jedaBeli do 
					begin
						arrRestock.baris[i].nextBeli := hariIni(arrRestock.baris[i].nextBeli);
					end;

				writeln('Restock berhasil.');
				end;//akhir cek kepenuhan inventori
				writeln;
			end;//akhir cek tanggal
		end;//akhir for
		if(adaRestock)then 
		begin
			dataSimulasi.energi := dataSimulasi.energi - 1;
			writeln('Energi berkurang sebanyak 1');
			writeln('Energi sekarang: ', dataSimulasi.energi);
		end;
	writeln;
    end;

end.
