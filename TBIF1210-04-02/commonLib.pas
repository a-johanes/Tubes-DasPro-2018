unit commonLib;

interface
	const
		Neff = 100;
		hargaUpInv = 10000;
//tipe bentukan
	type
	tanggal = record
		d,m,y : integer;
	end;

	bahanMentah = record
		bahan : string;
		harga : longint;
		durasi: integer;// dalam satuan hari
	end;

	typeMentah = record
		baris : array [1..Neff] of bahanMentah;
		isiArray : integer;
	end;

	invMentah = record
		bahan : string;
		tanggalBeli : tanggal;
		jumlah : integer;
	end;

	typeInvMentah = record
		baris : array [1..Neff] of invMentah;
		isiArray : integer;
	end;

	bahanOlahan = record //kadarluarsa dalam 3 hari sejak dibuat
		olahan : string;
		jual : longint; //harganya >= total penjumlahan tiap bahan mentah penyusunnya
		jumlah : integer;
		arrBahan : array [1..10] of string; //bahan mentah yang dibutuhkan
	end;

	typeOlahan = record
		baris : array [1..Neff] of bahanOlahan;
		isiArray : integer;
	end;

	invOlahan = record
		bahan : string;
		tanggalOlah : tanggal;//tanggal membuat
		jumlah : integer;
	end;

	typeInvOlahan = record
		baris : array [1..Neff] of invOlahan;
		isiArray : integer;
	end;

	resep = record
		namaResep : string;
		jual : longint; //harga jual minimum = 12,5% lebih tinggi dari semua bahan penyusunnya
		jumlah : integer; //minimal 2 dan maks 20
		arrBahan : array [1..20] of string;//daftar bahan mentah dan olahan yang menyusunnya
	end;

	typeResep = record
		baris : array [1..Neff] of resep;
		isiArray : integer;
	end;

	simulasi = record
		no 	: integer; //nomor simulasi yang dijanlankan
		tanggalSimulasi : tanggal;//tanggal awal simyulasi dijalankan
		hariHidup{0<=10}, energi, kapMaksInv, sumMentahBeli, sumOlahBuat, sumOlahJual, sumResepJual : integer;
		income, outcome, saldo : longint;
	end;

	typeSimulasi = record
		baris : array [1..Neff] of simulasi;
		isiArray : integer;
	end;

	dataRestock = record
		idxBahan : integer;
		jumlah : integer;
		jedaBeli : integer;
		nextBeli : tanggal;
	end;

	typeRestock = record
		baris : array [1..Neff] of dataRestock;
		isiArray : integer;
	end;

implementation
end.
