unit f5_f6_f14_f15_f16_Ardi;

interface
  uses commonLib, johanes;

  //fungsi dan prosedur
  procedure beliBahan(daftarMentah : typeMentah; var daftarInvMentah : typeInvMentah; daftarInvOlahan : typeInvOlahan; var dataSimulasi : simulasi; today : tanggal; var baruTidur : boolean);
    //F5-beliBahan
    //I.S : menerima input user berupa sebuah string (nama bahan yang ingin dibeli) dan sebuah integer (jumlah bahan yang ingin dibeli)
    //F.S : menambahkan bahan kedalam inventori, menggurangi uang serta energi jika bahan tersedia, uang mencukupi dan inventori cukup

  procedure olahBahan(var daftarInvMentah : typeInvMentah; var daftarInvOlahan : typeInvOlahan; daftarOlahan : typeOlahan; var dataSimulasi : simulasi; today : tanggal; var baruTidur : boolean);
    //F6-olahBahan
    //I.S : menerima input user berupa sebuah string (nama bahan yang ingin diolah)
    //F.S : menambahkan bahan olahan kedalam inventori, menggurangi energi, dan mengurangi bahan pembuat jika bahan tersedia dan inventori cukup

  procedure lihatResep(var daftarResep : typeResep);
    //F14-lihatResep
    //I.S : daftar resep dalam suatu array pada typeResep
    //F.S : mengurutkan lalu menampilkan daftar resep yang tersimpan

  procedure cariResep(daftarResep : typeResep);
    //F15-cariResep
    //I.S. : menerima tipe bentukan typeResep sebagai parameter dan menerima sebuah string dari user
    //F.S. : mencari string yang diberikan user pada typeResep dan mencataknya jika ditemukan,
    //       menulis pesan kesalahan jika tidak

  procedure tambahResep(daftarBahanMentah : typeMentah; daftarOlahan : typeOlahan; var daftarResep : typeResep);
    //F16-tambahResep
    //I.S : menerima input user berupa string (nama resep yang ingin ditambahkan serta bahan-bahan penyusunnya)
    //F.S : menambahkan resep baru kedalam typeResep

  procedure validateInputInteger(var output : longint);
    //I.S. : menerima input user dalam bentuk string
    //F.S. : mengecek apakah input user merupakan integer yang valid (positif) dan memberikan bilangannya ke variabel output

  function isTanggalSama(tanggal1, tanggal2 : tanggal):boolean;
    //mengecek apakah 2 buah tipe bentukan tanggal memiliki data yang sama

  function cariPosisiBahanMentah(namaCari : string; daftarMentah : typeMentah): integer;
    //menerima string dan typeMentah sebagai parameter dan mencari apakah string yang diberikan terdapat
    //pada variabel bahan pada typeMentah. Jika ditemukan mengembalikan posisinya dan jika tidak mengembalikan -1

  function jumlahIsiInventori(daftarInvMentah : typeInvMentah; daftarInvOlahan : typeInvOlahan): integer;
    //menghitung jumlah semua bahan mentah dan olahan yang ada di inventori

implementation
  uses math;

  //fungsi dan prosedur
  //cluster beliBahan start
  function jumlahIsiInventori(daftarInvMentah : typeInvMentah; daftarInvOlahan : typeInvOlahan): integer;
    //menghitung jumlah semua bahan mentah dan olahan yang ada di inventori
    var
      i : integer;
    begin
      jumlahIsiInventori := 0;
      for i:= 1 to daftarInvMentah.isiArray do
        jumlahIsiInventori := jumlahIsiInventori + daftarInvMentah.baris[i].jumlah;
      for i:= 1 to daftarInvOlahan.isiArray do
        jumlahIsiInventori := jumlahIsiInventori + daftarInvOlahan.baris[i].jumlah;
    end;

  procedure validateInputInteger(var output : longint);
    //I.S. : menerima input user dalam bentuk string
    //F.S. : mengecek apakah input user merupakan integer yang valid (positif) dan memberikan bilangannya ke variabel output
    var
      tempS : string;
      errorIdx, tempInt : integer;
    begin
      readln(tempS);
      val(tempS, tempInt, errorIdx);
      if((errorIdx <> 0) or (tempInt <= 0))then begin
        writeln('ERROR: Input harus berupa integer positif.');
        output := -1;
      end else
        output := tempInt;
    end;

  function isTanggalSama(tanggal1, tanggal2 : tanggal):boolean;
    //mengecek apakah 2 buah tipe bentukan tanggal memiliki data yang sama
    begin
      if( (tanggal1.d = tanggal2.d) and (tanggal1.m = tanggal2.m) and (tanggal1.y = tanggal2.y) )then
        isTanggalSama := true
      else
        isTanggalSama := false;
    end;

  function cariPosisiBahanMentah(namaCari : string; daftarMentah : typeMentah): integer;
    //menerima string dan typeMentah sebagai parameter dan mencari apakah string yang diberikan terdapat
    //pada variabel bahan pada typeMentah. Jika ditemukan mengembalikan posisinya dan jika tidak mengembalikan -1
    var
      flag : boolean;
      i : integer;
    begin
      flag := false;
      i := 1;
      while((flag = false) and (i <= daftarMentah.isiArray))do
      begin
        if (daftarMentah.baris[i].bahan = namaCari) then
          flag := true
        else
          i := i + 1;
      end;
      if(flag = true)then
        cariPosisiBahanMentah := i
      else
        cariPosisiBahanMentah := -1;
    end;

  function cariPosisiInvMentahSamaTanggal(namaCari : string; daftarInvMentah : typeInvMentah; today : tanggal): integer;
    //menerima string, typeInvMentah, dan tanggal sebagai parameter dan mencari apakah string yang diberikan terdapat
    //pada variabel bahan pada typeInvMentah dan tanggal yang diberikan sama dengan tanggalBeli.
    //Jika ditemukan mengembalikan posisinya dan jika tidak mengembalikan -1.
    var
      flag : boolean;
      i : integer;
    begin
      flag := false;
      i := 1;
      while((flag = false) and (i <= daftarInvMentah.isiArray))do
      begin
        if( (daftarInvMentah.baris[i].bahan = namaCari) and (isTanggalSama(today, daftarInvMentah.baris[i].tanggalBeli) = true) )then
          flag := true
        else
          i := i + 1;
      end;
      if(flag = true)then
        cariPosisiInvMentahSamaTanggal := i
      else
        cariPosisiInvMentahSamaTanggal := -1;
    end;

  procedure beliBahan(daftarMentah : typeMentah; var daftarInvMentah : typeInvMentah; daftarInvOlahan : typeInvOlahan; var dataSimulasi : simulasi; today : tanggal; var baruTidur : boolean);
    //I.S : menerima input user berupa sebuah string (nama bahan yang ingin dibeli) dan sebuah integer (jumlah bahan yang ingin dibeli)
    //F.S : menambahkan bahan kedalam inventori, menggurangi uang serta energi jika bahan tersedia, uang mencukupi dan inventori cukup
    var
      beliNamaBahanMentah : string;
      beliKuantitasBahanMentah, posisiBahanMentah, beliHargaTotal, posisiInvMentah : longint;

    begin
      write('Nama bahan  : ');
      readln(beliNamaBahanMentah); //input

      posisiBahanMentah := cariPosisiBahanMentah(beliNamaBahanMentah, daftarMentah);
      if(posisiBahanMentah = -1)then
        // input bahan mentah tidak tersedia
        writeln('ERROR: ', beliNamaBahanMentah, ' tidak tersedia di supermarket.')
      else if(dataSimulasi.energi < 1)then
        //energi tidak mencukupi
        writeln('ERROR: Energi tidak cukup')
      else begin
        write('Kuantitas : ');
        validateInputInteger(beliKuantitasBahanMentah); //cek input kuantitas integer

        if(beliKuantitasBahanMentah <> -1)then begin
    			beliHargaTotal := daftarMentah.baris[posisiBahanMentah].harga * beliKuantitasBahanMentah;
    			if((dataSimulasi.kapMaksInv - jumlahIsiInventori(daftarInvMentah, daftarInvOlahan)) < beliKuantitasBahanMentah)then
    				// besar inventori tidak mencukupi
    				writeln('ERROR: Inventori tidak cukup')
    			else if(dataSimulasi.saldo < beliHargaTotal)then
    				// uang tidak mencukupi
    				writeln('ERROR: Uang tidak cukup')
    			else begin
    				// beli berhasil
    				writeln('Harga Satuan: ', daftarMentah.baris[posisiBahanMentah].harga);
    				writeln('Total Harga : ', beliHargaTotal);
    				dataSimulasi.energi := dataSimulasi.energi - 1;
    				dataSimulasi.saldo := dataSimulasi.saldo - beliHargaTotal;
    				dataSimulasi.sumMentahBeli := dataSimulasi.sumMentahBeli + beliKuantitasBahanMentah;

    				posisiInvMentah := cariPosisiInvMentahSamaTanggal(daftarMentah.baris[posisiBahanMentah].bahan, daftarInvMentah,today);

    				if(posisiInvMentah = -1)then begin //tidak ada bahan dengan nama sama yang dibeli di hari yang sama
    					daftarInvMentah.isiArray := daftarInvMentah.isiArray + 1;
    					posisiInvMentah := daftarInvMentah.isiArray;

    					daftarInvMentah.baris[posisiInvMentah].bahan := daftarMentah.baris[posisiBahanMentah].bahan;
    					daftarInvMentah.baris[posisiInvMentah].tanggalBeli := today;
    					daftarInvMentah.baris[posisiInvMentah].jumlah := beliKuantitasBahanMentah;
    				end else //ada bahan dengan nama sama yang dibeli di hari yang sama
    					daftarInvMentah.baris[posisiInvMentah].jumlah := daftarInvMentah.baris[posisiInvMentah].jumlah + beliKuantitasBahanMentah;

    				writeln('Bahan mentah berhasil dibeli.');
    				baruTidur:= false;
    			end;
        end;
      end;
      writeln;
    end;
  //cluster beliBahan end

  //cluster olahBahan start
  function cariPosisiOlahan(namaCari : string; daftarOlahan : typeOlahan): integer;
    //menerima string dan typeMentah sebagai parameter dan mencari apakah string yang diberikan terdapat
    //pada variabel bahan pada typeMentah. Jika ditemukan mengembalikan posisinya dan jika tidak mengembalikan -1
    var
      flag : boolean;
      i : integer;
    begin
      flag := false;
      i := 1;
      while((flag = false) and (i <= daftarOlahan.isiArray))do
      begin
        if (daftarOlahan.baris[i].olahan = namaCari) then
          flag := true
        else
          i := i + 1;
      end;
      if(flag = true)then
        cariPosisiOlahan := i
      else
        cariPosisiOlahan := -1;
    end;

  function cariPosisiInvMentahPositif(namaCari : string; daftarInvMentah : typeInvMentah): integer;
    //menerima string dan typeInvMentah sebagai parameter dan mencari apakah string yang diberikan terdapat
    //pada variabel bahan pada typeInvMentah dan jumlah pada baris daftarInvMentah positif.
    //Jika ditemukan mengembalikan posisinya dan jika tidak mengembalikan -1.
    var
      flag : boolean;
      i : integer;
    begin
      flag := false;
      i := 1;
      while((flag = false) and (i <= daftarInvMentah.isiArray))do
      begin
        if ((daftarInvMentah.baris[i].bahan = namaCari) and (daftarInvMentah.baris[i].jumlah > 0) ) then
          flag := true
        else
          i := i + 1;
      end;
      if(flag = true)then
        cariPosisiInvMentahPositif := i
      else
        cariPosisiInvMentahPositif := -1;
    end;

  function cariPosisiInvOlahan(namaCari : string; daftarInvOlahan : typeInvOlahan; today : tanggal): integer;
    //menerima string, typeInvOlahan, dan tanggal sebagai parameter dan mencari apakah string yang diberikan terdapat
    //pada variabel bahan pada typeInvOlahan dan tanggal yang diberikan sama dengan tanggalOlah.
    //Jika ditemukan mengembalikan posisinya dan jika tidak mengembalikan -1.
    var
      flag : boolean;
      i : integer;
    begin
      flag := false;
      i := 1;
      while((flag = false) and (i <= daftarInvOlahan.isiArray))do
      begin
        if( (daftarInvOlahan.baris[i].bahan = namaCari) and (isTanggalSama(today, daftarInvOlahan.baris[i].tanggalOlah) = true) )then
          flag := true
        else
          i := i + 1;
      end;
      if(flag = true)then
        cariPosisiInvOlahan := i
      else
        cariPosisiInvOlahan := -1;
    end;

  procedure olahBahan(var daftarInvMentah : typeInvMentah; var daftarInvOlahan : typeInvOlahan; daftarOlahan : typeOlahan; var dataSimulasi : simulasi; today : tanggal; var baruTidur : boolean);
    //I.S : menerima input user berupa sebuah string (nama bahan yang ingin diolah)
    //F.S : menambahkan bahan olahan kedalam inventori, menggurangi energi, dan mengurangi bahan pembuat jika bahan tersedia dan inventori cukup
    var
      targetOlahan : string;
      flag : boolean;
      i, posisiOlahan, posisiInvOlahan : integer;
      posisiBahanMentah : array [1..10] of integer;
    begin
      write('Nama Olahan: ');
      readln(targetOlahan);

      posisiOlahan := cariPosisiOlahan(targetOlahan, daftarOlahan);
      if(posisiOlahan = -1)then // input bahan mentah tidak tersedia
        writeln('ERROR: ', targetOlahan, ' tidak ada di list bahan olahan.')
      else if(dataSimulasi.energi < 1)then
        //energi tidak mencukupi
        writeln('ERROR: Energi tidak cukup')
      else begin
        i := 1;
        flag := true;
        //mengecek ketersediaan bahan dan menguranginya
        while ((i <= daftarOlahan.baris[posisiOlahan].jumlah) and (flag = true)) do begin
          posisiBahanMentah[i] := cariPosisiInvMentahPositif(daftarOlahan.baris[posisiOlahan].arrBahan[i], daftarInvMentah);

          if(posisiBahanMentah[i] = -1)then
            flag := false
          else begin
            daftarInvMentah.baris[posisiBahanMentah[i]].jumlah := daftarInvMentah.baris[posisiBahanMentah[i]].jumlah - 1;
            i := i + 1;
          end;
        end;

        if(flag = false)then begin
          writeln('ERROR: Bahan yang dimiliki tidak mencukupi.');
          //membatalkan pengurangan bahan jika ada bahan yang tidak ditemukan di inventori
          for i:=(i - 1) downto 1 do begin
            daftarInvMentah.baris[posisiBahanMentah[i]].jumlah := daftarInvMentah.baris[posisiBahanMentah[i]].jumlah + 1;
          end;
        end
        else begin
          //olahBahan berhasil
          dataSimulasi.energi := dataSimulasi.energi - 1;
          dataSimulasi.sumOlahBuat := dataSimulasi.sumOlahBuat + 1;

          posisiInvOlahan := cariPosisiInvOlahan(daftarOlahan.baris[posisiOlahan].olahan, daftarInvOlahan,today);
          if(posisiInvOlahan = -1)then begin
            daftarInvOlahan.isiArray := daftarInvOlahan.isiArray + 1;
            posisiInvOlahan := daftarInvOlahan.isiArray;

            daftarInvOlahan.baris[posisiInvOlahan].bahan := daftarOlahan.baris[posisiOlahan].olahan;
            daftarInvOlahan.baris[posisiInvOlahan].tanggalOlah := today;
            daftarInvOlahan.baris[posisiInvOlahan].jumlah := 1;
          end else
            daftarInvOlahan.baris[posisiInvOlahan].jumlah := daftarInvOlahan.baris[posisiInvOlahan].jumlah + 1;

          writeln('Bahan berhasil diolah!');
          baruTidur := false;
        end;
      end;
      writeln;
    end;
  //cluster olahBahan end

  //cluster lihatResep, cariResep, dan tambahResep start
  function cariPosisiResep(namaCari : string; daftarResep : typeResep): integer;
    //menerima string dan typeResep sebagai parameter dan mencari apakah string yang diberikan terdapat
    //pada variabel bahan pada typeResep. Jika ditemukan mengembalikan posisinya dan jika tidak mengembalikan -1
    var
      flag : boolean;
      i : integer;
    begin
      flag := false;
      i := 1;
      while((flag = false) and (i <= daftarResep.isiArray))do begin
        if( daftarResep.baris[i].namaResep = namaCari )then
          flag := true
        else
          i := i + 1;
      end;
      if(flag = true)then
        cariPosisiResep := i
      else
        cariPosisiResep := -1;
    end;

  procedure cetakResep(targetResep : resep);
    //I.S. : menerima tipe bentukan resep sebagai parameter
    //F.S. : mencetak nama resep, bahan-bahan penyusunnya, serta harga jualnya
    var
      i : integer;
    begin
      writeln('Nama resep : ', targetResep.namaResep);
      write('Bahan      : ');
      for i:=1 to targetResep.jumlah do begin
        write(targetResep.arrBahan[i]);
        if(i <> targetResep.jumlah)then
          write(', ');
      end;
      writeln;
      writeln('Harga jual : ', targetResep.jual);
      writeln;
    end;

  procedure sortMergeResep (var inputArr : typeResep; startIndex, endIndex : integer);
    //I.S. : menerima tipe bentukan typeResep yang berisi array serta menerima
    //       indeks awal dan akhir array yang ingin diurutkan
    //F.S. : parameter typeResep terurut secara alfabetik
    var
      middleIndex, i, j, k : integer;
      tempArr : typeResep;
    begin
      if (endIndex > startIndex) then begin
        middleIndex := (startIndex + endIndex) Div 2;
        sortMergeResep (inputArr, startIndex, middleIndex);
        sortMergeResep (inputArr, middleIndex + 1, endIndex);

        for i:=middleIndex downto startIndex do
          tempArr.baris[i] := inputArr.baris[i];

        for j:=(middleIndex + 1) to endIndex do
          tempArr.baris[endIndex + middleIndex + 1 - j] := inputArr.baris[j];

        i := startIndex;
        j := endIndex;
        for k := startIndex to endIndex do begin
          if (tempArr.baris[i].namaResep < tempArr.baris[j].namaResep) then begin
            inputArr.baris[k] := tempArr.baris[i];
            i := i + 1;
          end
          else begin
            inputArr.baris[k] := tempArr.baris[j];
            j := j - 1;
          end;
        end;
      end;
    end;

  procedure lihatResep(var daftarResep : typeResep);
    //I.S : daftar resep dalam suatu array pada typeResep
    //F.S : mengurutkan lalu menampilkan daftar resep yang tersimpan
    var
      i : integer;
    begin
      sortMergeResep(daftarResep, 1, daftarResep.isiArray);
      for i:=1 to daftarResep.isiArray do begin
        writeln('Resep ', i);
        cetakResep(daftarResep.baris[i]);
      end;
    end;

  procedure cariResep(daftarResep : typeResep);
    //I.S. : menerima tipe bentukan typeResep sebagai parameter dan menerima sebuah string dari user
    //F.S. : mencari string yang diberikan user pada typeResep dan mencataknya jika ditemukan,
    //       menulis pesan kesalahan jika tidak
    var
      namaResepCari : string;
      posResep : integer;
    begin
      write('Nama resep yang ingin dicari: ');
      readln(namaResepCari);
      posResep := cariPosisiResep(namaResepCari,daftarResep);
      if(posResep = -1)then
        writeln('ERROR: ', namaResepCari, ' tidak ditemukan di daftar resep.')
      else
        cetakResep(daftarResep.baris[posResep]);
    end;

  procedure tambahResep(daftarBahanMentah : typeMentah; daftarOlahan : typeOlahan; var daftarResep : typeResep);
    //I.S : menerima input user berupa string (nama resep yang ingin ditambahkan serta bahan-bahan penyusunnya)
    //F.S : menambahkan resep baru kedalam typeResep
    var
      tempBahanResep,nama : string;
      hargaTotalBahan: longint;
      inputContinue : boolean;
      idxResep ,i , posBahanMentahResep, posBahanMentahOlahan : integer;
    begin
  		//Input nama resep
  		write('Nama resep baru: ');
  		readln(nama);
  		idxResep := cariPosisiResep(nama, daftarResep);
  		if (nama = '') then
        writeln('ERROR: Nama resep tidak boleh kosong.')

  		else if (idxResep <> -1) then //nama resep sudah ada di daftarResep
        writeln('ERROR: Sudah ada resep dengan nama yang sama.')

  		else begin //nama resep belum ada di daftarResep
        //inisialisasi entry resep baru
  			daftarResep.isiArray := daftarResep.isiArray + 1;
  			daftarResep.baris[daftarResep.isiArray].namaResep := nama;

  			//Input bahan-bahan resep
  			writeln('Bahan-bahan resep baru: (Harus >= 2 dan <= 20. Inputkan karakter "-" untuk menyelesaikan input atau "cancel" untuk membatalkan)');

  			i := 0; //counter jumlah bahan
  			hargaTotalBahan := 0;
  			inputContinue := true;

  			while((i <= 20) and (inputContinue = true))do begin
  				write('>>> ');
  				readln(tempBahanResep);

  				if(tempBahanResep = '-')then begin
  					if(i < 2)then //Bahan yang dimasukkan kurang dari 2
  						writeln('ERROR: Jumlah bahan kurang.')
  					else
  						inputContinue := false;

  				end else if (tempBahanResep = 'cancel') then
            inputContinue := false

  				else begin //input selain karakter '-'
  					posBahanMentahResep := cariPosisiBahanMentah(tempBahanResep, daftarBahanMentah);
  					posBahanMentahOlahan := cariPosisiOlahan(tempBahanResep, daftarOlahan);

  					if( (posBahanMentahResep = -1) and (posBahanMentahOlahan = -1) )then // bahan tidak ada di daftarBahanMentah
  						writeln('ERROR: Bahan tidak tersedia.')

  					else begin //bahan ditemukan di daftarBahanMentah atau daftarOlahan
  						i := i + 1;
  						//menambahkan input bahan ke dalam resep
  						daftarResep.baris[daftarResep.isiArray].arrBahan[i] := tempBahanResep;

  						if(posBahanMentahResep <> -1)then
  							hargaTotalBahan := hargaTotalBahan + daftarBahanMentah.baris[posBahanMentahResep].harga
  						else if(posBahanMentahOlahan <> -1)then
  							hargaTotalBahan := hargaTotalBahan + daftarOlahan.baris[posBahanMentahOlahan].jual;
  					end;

  				end; //end else
  			end; //end while

  			if (tempBahanResep = 'cancel') then //membatalkan pembuatan resep baru
  			begin
  				daftarResep.baris[daftarResep.isiArray].namaResep := '';
  				daftarResep.isiArray -= 1;
          writeln('Pembuatan resep dibatalkan.')
  			end else begin //input selesai tanpa cancel
          daftarResep.baris[daftarResep.isiArray].jumlah := i;
          daftarResep.baris[daftarResep.isiArray].jual := ceil( hargaTotalBahan * 1125/1000 );

          //memberi info summary ke user
          writeln('Ada ', i, ' bahan yang digunakan untuk membuat ', nama, '.');
          writeln('Harga jual ', nama ,': ', daftarResep.baris[daftarResep.isiArray].jual);
  			end;
      end; //end else (nama resep belum ada di daftarResep)

  		writeln;
    end;//akhir tambahResep
  //cluster lihatResep, cariResep, dan tambahResep end

end.
