unit f3_startSimulasi;
{memulai suatu simulasi nomor tertentu dari daftar simulasi yang ada. Hari simulasi
dimulai pada tanggal yang bersangkutan. dan akan membuat simulasi baru jika belum ada}

interface
	uses sysutils, Dos , commonLib, johanes, f9_f10_f11_f12_f13_Saskia,f5_f6_f14_f15_f16_Ardi, loadExit, b4_restock;

	function whereIsSim(noDicari:integer;tabSimulasi:typeSimulasi) : integer;
	{fungsi untuk mengeluarkan indeks letak nomor simulasi yang dicari berada pada tab simulasi}

	function isCommandTambahan(command : string) :boolean ;
	{fungsi bernilai true jika command yang dimasukkan sesuai}

	procedure upInv(var data : simulasi);
	{prosedur menambah inventori}
	
	procedure cekStart (var command : string; var nomor : longint;var flag : boolean;load : boolean);
	{prosedur akan menerima string dan mengecek apakah itu fungsi biasa atau merupakan start yang tergantung dari apakah file telah diload}

	procedure help();
	{menampilkan semua nama fungsi yang dapat digunakan}

	procedure cetakSimulasi(arrSimulasi : simulasi);
	{hanya mencetak data simulasi yang berjalan}

	procedure startSimulasi(no : longint; tabMentah : typeMentah;var tabInvMentah : typeInvMentah; tabBahan:typeOlahan; var tabInvOlahan:typeInvOlahan;var tabResep : typeResep;var tabSimulasi : typeSimulasi);
	{prosedure memulai simulasi berdasarkan nomor yang dimasukan,
	* asumsi nomor yang dimasukan sudah benar}

implementation

	function whereIsSim(noDicari:integer;tabSimulasi:typeSimulasi) : integer;
	var
		i : integer;
		found : boolean;
	begin
		i := 1;
		found := false;
		while ( (i<=tabSimulasi.isiArray) and (not(found)) ) do
		begin
			if (tabSimulasi.baris[i].no = noDicari) then found := true
			else i := i +1; //akhir if
		end;// akhir while
		if (found) then whereIsSim := i
		else whereIsSim := 0;
	end;// akhir fungsi cari

	function isCommandAvailable(command :string): boolean;
	begin
		isCommandAvailable := (command = 'stop') or (command = 'tidur') or
		(command = 'istirahat') or (command = 'makan') or (command = 'lihat inventori') or
		(command = 'lihat statistik') or (command = 'jual olahan') or (command = 'jual resep') or (command = 'help') or
		(command = 'beli bahan') or (command = 'olah bahan') or (command = 'lihat resep') or (command = 'cari resep') or (command = 'tambah resep') or
		(command = 'upgrade inventori') or (command = 'tambah restock') or (command = 'hapus restock');//list command
	end;//akhir fungsi isCommanAvailable

	function isCommandUtama(command : string) : boolean;
	begin
		isCommandUtama := (command = 'load') or (command = 'exit') or (command = 'help');
	end;

	function isCommandTambahan(command : string) :boolean ;
	begin
		isCommandTambahan := (command = 'lihat inventori') or (command = 'lihat resep') or
		(command = 'cari resep') or (command = 'tambah resep') or (command = 'upgrade inventori') ;
	end;

	procedure upInv(var data:simulasi);
	begin
		if (data.saldo >= hargaUpInv) then //cukup uangnya
		begin
			data.kapMaksInv += 25;
			writeln('Kapasitas inventori telah bertambah sebesar 25.');
			data.saldo-= hargaUpInv;
		end else writeln('Upgrade inventori gagal karena uang tidak cukup');
	end;
	
	procedure cekStart (var command : string; var nomor : longint;var flag : boolean;load : boolean);
	var
		tab : array [1..3] of string; //menentukan apakah itu command yang benar atau tidak
		i,idx : integer;
		input1 , input2, input3 : string;
	begin
		tab[1] := '';//inisiasi awalnya karakter kosong ''
		tab[2] := '';
		tab[3] := '';
		idx := 1;//inisiasi indeks awal
		for i := 1 to length(command) do
		begin//memilah isi dari input menjadi string dan angkanya
			if (command[i] <> ' ') then
			begin
				tab[idx] += command[i]; //kasus saat inputnya banyak spasi
			end else if (idx<3) then idx += 1;
		end;
		input1 := tab[1];
		input2 := tab[2];
		input3 := tab[3];
		command := input1 + ' ' + input2;
		if (input1 = 'start') then //jika command inputnya 'start' dan sudah terload
		begin
			flag := true;
			command := input1 ;
			if load then
			begin
				if (not(TryStrToInt(input2,nomor))) then //mengecek apakah angka yang dimasukkan adalah benar angka
				begin
					writeln('Input nomor simulasi salah.');
				end else if (nomor = 0) then writeln('Nomor simulasi harus angka > 0.')//jika input start dengan angka 0
			end;
		end else if (isCommandUtama(input1)) then//command input 'load' atau 'exit' atau 'help'
		begin
			command := input1;
			if (input2 = '')and (input3 = '') then flag := true //tidak ada embel2nya
			else flag := false;
		end else if (isCommandTambahan(command)) then
		begin
			flag := true;
			if ((command = 'lihat inventori')or (command = 'upgrade inventori'))and load then
			begin
				if (not(TryStrToInt(input3,nomor))) then //mengecek apakah angka yang dimasukkan adalah benar angka
				begin
					writeln('Input nomor simulasi salah.');
				end else if (nomor = 0) then writeln('Nomor simulasi harus angka > 0.')//jika input start dengan angka 0
			end;
		end else flag := false; //jika inputnya command yang tidak diketahui. akhir pengecekan input
	end;//akhir porsedur

	procedure help();
	begin
		writeln('========================== LIST COMMAND YANG TERSEDIA ========================');
		writeln('stop: mneghentikan simulasi');
		writeln('beli bahan: membeli bahan mentah dari supermarket');
		writeln('olah bahan: mengolah bahan mentah menjadi bahan olahan');
		writeln('jual olahan: menjual bahan olahan yang ada di inventori');
		writeln('jual resep: menjual makanan yang dibuat berdasarkan resep');
		writeln('makan: menambah 3 energi, sehari maks 3x');
		writeln('istirahat: menambah 1 energi, sehari maks 6x');
		writeln('tidur: mereset energi menjadi 10 dan mengganti hari');
		writeln('lihat statistik: menampilkan data statistik dari simulasi yang dijalankan');
		writeln('lihat inventori: menampilkan inventori bahan mentah dan baham olahan');
		writeln('lihat resep: melihat list resep yang ada');
		writeln('cari resep: mencari resep dalam list resep');
		writeln('tambah resep: menambah resep dalam list resep');
		writeln('upgrade inventori: menambah kapasitas maksimum inventori');
		writeln('tambah restock: menambah bahan pada daftar restock');
		writeln('hapus restock: mengurangi bahan pada daftar restock');
		writeln;
	end;//akhir dari help

	procedure cetakSimulasi(arrSimulasi : simulasi);
	begin
		writeln('============= STATISTIK =============');
		writeln('Nomor simulasi: ', arrSimulasi.no);
		writeln('Tanggal awal simulasi: ', arrSimulasi.tanggalSimulasi.d, '/', arrSimulasi.tanggalSimulasi.m, '/', arrSimulasi.tanggalSimulasi.y);
		writeln('Jumlah hari hidup: ', arrSimulasi.hariHidup);
		writeln('Jumlah energi: ', arrSimulasi.energi);
		writeln('Kapasitas maksimum inventori: ', arrSimulasi.kapMaksInv);
		writeln('Total bahan mentah dibeli: ', arrSimulasi.sumMentahBeli);
		writeln('Total bahan olahan dibuat: ', arrSimulasi.sumOlahBuat);
		writeln('Total bahan olahan dijual: ', arrSimulasi.sumOlahJual);
		writeln('Total resep dijual: ', arrSimulasi.sumResepJual);
		writeln('Total pemasukan: ', arrSimulasi.income);
		writeln('Total pengeluaran: ', arrSimulasi.outcome);
		writeln('Total uang: ', arrSimulasi.saldo);
		writeln;
	end; //akhir cetakSimulasi

	procedure startSimulasi(no : longint; tabMentah : typeMentah;var tabInvMentah : typeInvMentah; tabBahan:typeOlahan; var tabInvOlahan:typeInvOlahan;var tabResep : typeResep;var tabSimulasi : typeSimulasi);
	var
		data : simulasi;
		today : tanggal;
		input: string;
		makanCount, istCount,i,idxSim:integer;
		year,month,day,wday: word;
		baruTidur : boolean; //variabel penentu apakah baru tidur atau tidak
		arrRestock : typeRestock;
	begin
		if (no > 0) then
		begin //program hanya dijalankan jika nomor simulasi > 0
			idxSim := whereIsSim(no,tabSimulasi); //mencari idx untuk nomor simulasi
			if ( idxSim > 0) then //sudah ada data simulasi
			begin
				writeln('Mulai simulasi ', no,'.');
				data := tabSimulasi.baris[idxSim];//data yang digunakan
				today := data.tanggalSimulasi;
				i := 2 ;
				while (i <= data.hariHidup) do //membuat tanggal hari ini
				begin
					today := hariIni(today);
					i:= i +1;
				end;

			end else //tidak ada data simulasi
			begin
				writeln('Tidak ada data simulasi ',no,'.');
				writeln('Membuat data simulasi baru');
				GetDate(year,month,day,wday);//membuat data simulasi baru
				today.d := day;
				today.m := month;
				today.y := year;
				tabSimulasi.isiArray += 1;//menambah panjang data
				i := tabSimulasi.isiArray;
				tabSimulasi.baris[i].no := no;
				tabSimulasi.baris[i].tanggalSimulasi := today;
				tabSimulasi.baris[i].hariHidup := 0;
				tabSimulasi.baris[i].energi := 10;
				tabSimulasi.baris[i].kapMaksInv := 25;
				tabSimulasi.baris[i].sumMentahBeli := 0;
				tabSimulasi.baris[i].sumOlahBuat := 0;
				tabSimulasi.baris[i].sumOlahJual := 0;
				tabSimulasi.baris[i].sumResepJual := 0;
				tabSimulasi.baris[i].income := 0;
				tabSimulasi.baris[i].outcome := 0;
				tabSimulasi.baris[i].saldo := 0;

				data := tabSimulasi.baris[i];//data yang digunakan
				idxSim := i;//idx yang digunakan
				fileBaru(tabInvMentah, tabInvOlahan, data.no);//mebuat file baru

			end;//akhir dari cek data simulasi
			if (data.hariHidup < 10) then
			begin
				loadSimulasi(tabInvMentah, tabInvOlahan, data.no); // menyiapkan array sesuai nomor simulasi
				loadRestock(arrRestock, idxSim); //membuka file data restock
				write('Hari ini tanggal: ');
				writeln(today.d,'/',today.m,'/',today.y); //tanggal hari ini
				writeln;
				makanCount:= 0;//penghitung jumlah makan maks 3 perhari
				istCount:= 0;//penhitung jumlah istirahat maks 6 perhari
				baruTidur := false; //tidak baru tidur
				hapusKedaluwarsa(today, tabMentah, tabInvMentah, tabInvOlahan);
				repeat
					write('>> ');
					readln(input);//input command
					//if TryStrToInt(input,tmp) then writeln('Input harus berupa nama command.')//input berupa angka
					if (input = 'lihat statistik') then cetakStatistik(data,tabMentah,tabBahan,arrRestock)
					else if (input = 'lihat inventori') then
					begin
						cetakInventori(tabInvMentah, tabInvOlahan);
						writeln;
					end else if (input = 'lihat resep') then lihatResep(tabResep)
					else if (input = 'cari resep') then cariResep(tabResep)
					else if (input = 'tambah resep') then tambahResep(tabMentah, tabBahan, tabResep)
					else if (input = 'tambah restock') then tambahRestock(arrRestock, tabMentah,tabInvMentah, today)
					else if (input = 'hapus restock') then deleteRestock(arrRestock, tabMentah)
					else if (input = 'upgrade inventori') then 
					begin
						upInv(data);
						baruTidur := false;
						writeln;
					end else if (input = 'tidur') then tidur(data, today, tabMentah, tabInvMentah, tabInvOlahan, makanCount, istCount,arrRestock,baruTidur)
					else if (input = 'help') then help()
					else if (data.energi > 0) then //Chef masih punya energi
					begin
						if (input = 'jual olahan') then menjualOlahan(today, tabBahan, data, tabInvOlahan,baruTidur)
						else if (input = 'jual resep') then menjualResep(today, tabResep, tabMentah, tabInvOlahan, tabInvMentah,data,baruTidur)
						else if (input = 'makan') then makan(data, makanCount,baruTidur)
						else if (input = 'istirahat') then istirahat(data, istCount,baruTidur)
						else if (input = 'beli bahan') then beliBahan(tabMentah, tabInvMentah, tabInvOlahan, data,today,baruTidur)
						else if (input = 'olah bahan') then olahBahan(tabInvMentah, tabInvOlahan, tabBahan, data, today,baruTidur);
					end else if (data.energi = 0) then //energi=0 Chef tidak bisa melakukan aksi apapun yang berhubungan dengan energi namun bisa tidur
					begin
						if (isCommandAvailable(input)) then writeln('Energi Chef telah habis. Chef hanya bisa tidur.');
					end;
					if not(isCommandAvailable(input)) then
					begin
						writeln('Maaf command tidak dikenali, coba panggil command help.');
						writeln;
					end;
				until (input = 'stop') or (data.hariHidup = 10);//mengulang menjalankan input hingga inputnya stop
				if (input = 'stop') then writeln('Simulasi ',no,' dihentikan.') //pengecekkan alesan berhenti //karena command stop
				else writeln('Waktu simulasi ',no,' telah habis (hari hidup sudah 10 hari).');//karena hari habis
				writeln;
				tabSimulasi.baris[idxSim] := data;
				cetakSimulasi(data);
				cetakInventori(tabInvMentah, tabInvOlahan);
				exitSimulasi(tabInvMentah,tabInvOlahan,data.no);
				tulisRestock(arrRestock, idxSim);
			end else writeln('Simulasi gagal, waktu simulasi telah habis. Mohon coba simulasi lain.');
		end else writeln('Simulasi gagal, coba panggil command help.'); //akhir if > 0
		writeln;
	end;//akhir prosedure
end.
