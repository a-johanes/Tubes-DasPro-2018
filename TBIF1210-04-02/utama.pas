program Utama;
{Program yang mengumpulkan seluruh modul}

{Kelas 04 : Kelompok 02
16517 046 : Stefanus Ardi Mulia
16517 053 : Aliffiqri Agwar
16517 060 : Saskia Imani
16517 067 : Fauzan Khusnarrofi
16517 074 : Johanes}

uses loadExit, commonLib, olahStr, f3_startSimulasi,f5_f6_f14_f15_f16_Ardi,f9_f10_f11_f12_f13_Saskia;
{Penggunaan unit di luar program utama}


{KAMUS}
var
	command : string;
	loaded,flag : boolean;
	bahanMentah : typeMentah;
	bahanOlahan : typeOlahan;
	invMentah	: typeInvMentah;
	invOlahan	: typeInvOlahan;
	resep		: typeResep;
	simulasi	: typeSimulasi;
	nomor : longint;
	idxSim : integer;

	procedure help();
	{menampilkan list command yang ada}
	begin
		writeln('========================== LIST COMMAND YANG TERSEDIA ========================');
		writeln('load : Memasukkan data dari file eksternal ke dalam struktur internal');
		writeln('exit : Keluar dari program');
		writeln('start "x" : Memulai simulasi dengan "x" adalah nomor simulasi');
		writeln('lihat inventori "x" : melihat isi inventori dari nomor simulasi bersangkutan');
		writeln('lihat resep : untuk melihat resep yang tersedia');
		writeln('cari resep : mencari resep berdasarkan nama resepnya');
		writeln('tambah resep : menambah resep baru');
		writeln('upgrade inventori "x" : memperbesar iventori dari nomor simulasi yang bersangkutan');
		writeln;
	end;

{ALGORITMA}
begin
	//Salam Pembuka
	writeln('|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||');
	writeln('||        ||  ||||  ||        ||        ||   ||        ||||   |||  ||        ||        ||        ||  ||||  ||        ||  ||||  ||');
	writeln('||        ||   |||  ||    ||| ||        ||   ||    ||||||||   ||  |||        ||        ||        ||  ||||  ||        ||   |||  ||');
	writeln('||    ||||||   |||  ||   |||||||||    ||||  |||    ||||||||   |  ||||||    |||| ||  || ||    ||||||  ||||  ||    ||||||   |||  ||');
	writeln('||        || |  ||  ||        ||||    |||| || |        ||||     |||||||    |||||||  |||||    ||||||        ||        || |  ||  ||');
	writeln('||        || ||  |  ||  ||||  ||||    ||||    |        ||||    ||||||||    |||||||  |||||    ||||||        ||        || ||  |  ||');
	writeln('||    |||||| |||    ||  ||||  ||||    |||||||||||||    ||||     |||||||    |||||||  |||||    ||||||  ||||  ||    |||||| |||    ||');
	writeln('||        || ||||   ||        ||        |||||||||||    ||||   |  ||||        |||||  |||||        ||  ||||  ||        || ||||   ||');
	writeln('||        || |||||  ||        ||        |||||||        ||||   ||  |||        ||||    ||||        ||  ||||  ||        || |||||  ||');
	writeln('|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||');
	writeln('                                                                                                   2018(c) Kitchen Simulator 0402');
	writeln();

	//Memasukkan pilihan user
	writeln('Selamat datang di Dapur milik Engi, silakan masukkan pilihan menu yang tersedia. (Contoh : load,help)');
	writeln();

	loaded := false;//keadaan file ekternal. true jika sudah diload

	//Memulai perintah
	repeat
		write('> ');
		readln(command); //input command
		cekStart(command, nomor,flag,loaded);
		if (flag) then  //flag true jika command yang dimasukkan tidak membawa embel2 dibelakangnya/ merupakan command yang benar
		begin
			if(command = 'exit') then //jika input yang diterima adalah 'exit'
			begin
				if (loaded) then exitProgram(bahanMentah, bahanOlahan, resep, simulasi);
				writeln('Data anda disimpan di file eksternal.');
				readln;
			end else if (command = 'help') then help() //jika input yang diterima adalah 'help'
			else if (loaded = false) then //jika loaded = false8
			begin
				if(command = 'load') then //jika command inputnya ='load'
				begin
					loadProgram(bahanMentah, bahanOlahan, resep, simulasi);
					loaded := true;
				end else if (command = 'start') or (isCommandTambahan(command)) then
				begin
					writeln('Data belum dimasukkan, gunakan fungsi load untuk memasukkan data.');//jika command inputnya dilakukan sebelum 'load'
					writeln;
				end;
			end else if (loaded = true) then//jika loaded = true
			begin
				if (command = 'load') then writeln('File telah diload.')
				else if (command = 'start') then //command yang diterima 'start'
				begin
					startSimulasi(nomor, bahanMentah,invMentah,bahanOlahan,invOlahan,resep,simulasi);
				end else if (command = 'lihat inventori') then
				begin
					if (nomor > 0) then
					begin
						idxSim := whereIsSim(nomor,simulasi);
						if (idxSim > 0 ) then
						begin
							loadSimulasi(invMentah, invOlahan, simulasi.baris[idxSim].no);
							cetakInventori(invMentah, invOlahan);
							exitSimulasi(invMentah, invOlahan, simulasi.baris[idxSim].no);
						end else writeln('Nomor simulasi tidak ditemukan.');
					end else writeln('Lihat inventori gagal, coba panggil command help.');
					writeln;
				end else if (command = 'lihat resep') then lihatResep(Resep)
				else if (command = 'cari resep') then cariResep(Resep)
				else if (command = 'tambah resep') then tambahResep(bahanMentah, bahanOlahan, Resep)
				else if (command = 'upgrade inventori') then
				begin
					if (nomor > 0) then
					begin
						idxSim := whereIsSim(nomor,simulasi);
						if (idxSim > 0 ) then
						begin
							upInv(simulasi.baris[idxSim]);
						end else writeln('Nomor simulasi tidak ditemukan.');
					end else writeln('Upgrade inventori gagal, coba panggil command help.');
					writeln;
				end;
			end;//akhir if load atau command exit
		end else begin
			writeln('Maaf command tidak dikenali, coba panggil command help.');//akhir if flag, tertulis dilayar jika inputnya merupakan command yang memiliki format yang salah
			writeln;
		end;
	until ((command = 'exit')and flag); //syarat berhenti hingga commandnya 'exit'
	//prosedure exit, menulis ke file
end.
