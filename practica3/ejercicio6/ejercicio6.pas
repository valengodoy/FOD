program ejercicio6;
const
	valorAlto = 9999;
type
	prenda = record
		cod: integer;
		desc: string;
		colores: string;
		tipo: string;
		stock: integer;
		precio: real;
	end;
	

	
	maestro = file of prenda;
	detalle = file of integer;
	
	
procedure crearMaestro(var mae: maestro);
var
	txt: Text;
	p: prenda;
begin
	assign(txt, 'maestro.txt');
	assign(mae, 'maestro.dat');
	reset(txt);
	rewrite(mae);
	while(not eof(txt))do begin
		readln(txt, p.cod, p.stock, p.precio, p.desc);
		readln(txt, p.colores);
		readln(txt, p.tipo);
		write(mae, p);
	end;
	writeln('--------------------------------------------------------');
	writeln('Archivo maestro cargado');
	writeln('--------------------------------------------------------');
	close(mae);	
end;	

procedure crearDetalle(var det: detalle);
var
	num: integer;
	txt: Text;
begin
	assign(txt, 'detalle.txt');
	assign(det, 'detalle.dat');
	reset(txt);
	rewrite(det);
	while(not eof(txt))do begin
		readln(txt, num);
		write(det, num);
	end;
	writeln('--------------------------------------------------------');
	writeln('Archivo detalle cargado');
	writeln('--------------------------------------------------------');	
	close(det);
end;
	
	
procedure leerMae(var arch:maestro; var reg: prenda);
begin
	if(not eof(arch))then
		read(arch, reg)
	else
		reg.cod:= valorAlto;
end;		
	
	
procedure compactar(var mae: maestro; var nuevo_mae: maestro);	
var
	p: prenda;
begin
	assign(nuevo_mae, 'nuevo_prendas.dat');
	rewrite(nuevo_mae);
	reset(mae);
	leerMae(mae, p);
	while(p.cod <> valorAlto) do begin
		if(p.stock > 0) then 
			write(nuevo_mae, p);
		leerMae(mae, p);
	end;
	close(mae);
	close(nuevo_mae);
end;
	
procedure leer(var det: detalle; var cod: integer);
begin
	if(not eof(det)) then	
		read(det, cod)
	else
		cod:= valorAlto;
end;

	
	
	
procedure actualizar(var mae: maestro; var det: detalle);	
var
	p: prenda;
	cod: integer;
	nuevo_mae: maestro;
begin
	reset(det);
	reset(mae);
	leer(det, cod);
	while(cod <> valorAlto) do begin
		leerMae(mae, p);
		while(p.cod <> cod)do 
			leerMae(mae, p);
		p.stock := p.stock * -1;
		seek(mae, filepos(mae)-1);
		write(mae, p);
		seek(mae, 0);
		leer(det, cod);
	end;
	close(mae);
	close(det);
	compactar(mae, nuevo_mae);
	Erase(mae);
	Rename(nuevo_mae, 'maestro.dat');
	
end;



	
var
	mae: maestro;
	det: detalle;
	
begin
	crearMaestro(mae);
	crearDetalle(det);
	actualizar(mae, det);
	
end.
