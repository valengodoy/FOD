program ejercicio7;
const
	valorAlto = 9999;
type
	aves = record
		cod: integer;
		nombre: string;
		familia: string;
		desc: string;
		zona: string;
	end;
	
	maestro = file of aves;

	
procedure crearMaestro(var mae: maestro);
var
	txt: Text;
	a: aves;
begin
	assign(txt, 'maestro.txt');
	assign(mae, 'maestro.dat');
	reset(txt);
	rewrite(mae);
	while(not eof(txt))do begin
		readln(txt, a.cod, a.nombre);
		readln(txt, a.familia);
		readln(txt, a.desc);
		write(mae, a.zona);
	end;
	writeln('--------------------------------------------------------');
	writeln('Archivo maestro cargado');
	writeln('--------------------------------------------------------');
	close(mae);	
end;	


procedure leer(var a: maestro; var reg: aves);
begin
	if(not eof(a)) then
		read(mae, a)
	else
		a.cod:= valorAlto;

end;

procedure eliminar(var mae: maestro; cod: integer);
var
	a: aves;
begin
	reset(mae);
	leer(mae, a);
	while(a.codigo <> valorAlto) and(a.codigo <> cod) do 
		leer(mae, a);
	if(a.codigo = cod) then begin
		a.codigo := '*' + a.codigo;
		seek(mae, filepos(mae)-1);
		write(mae, a);
		seek(mae, 0);
	end;
	close(mae);
end;

procedure compactar(var mae: maestro);
var
	a, aux: aves;
	libre: integer;
begin
	reset(mae)
	leer(mae, a);
	while(a.codigo <> valorAlto) do begin
		if(a.codidog[1] = '*') then begin
			libre:- filepos(mae)-1;
			seek(mae, filesize(mae)-1);
			read(mae, aux);
			seek(mae, libre);
			write(mae, aux);
			seek(mae, filesize(mae)-1);
			truncate(mae);
			seek(mae, libre);
		end;
		leer(mae, a);
	end;
	close(mae);
end;
			

	
	
var
	mae: maestro;
	cod: integer;
begin
	crearMaestro(mae);
	repeat
		writeln('Ingrese codigo de la especie a eliminar (500000 para terminar)');
		readln(cod);
		eliminar(mae, cod);
	until(cod = 500000);
	compactar(mae);
end.
