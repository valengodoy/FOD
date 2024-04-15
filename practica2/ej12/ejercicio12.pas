program ejercicio12;
const 
	valorAlto = 9999;
type
	logs = record
		numero: integer;
		usuario: string;
		nombre: string;
		apellido: string;
		cant: integer;
	end;
	
	correo = record
		numero: integer;
		destino: string;
		mensaje: string;
	end;
	
	maestro = file of logs;
	detalle = file of correo;
	

procedure crearMaestro(var mae: maestro);
var
	txt: Text;
	nombre: string;
	l: logs;
begin
	assign(txt, 'maestro.txt');
	writeln('Ingrese nombre del archivo maestro');
	readln(nombre);
	assign(mae, nombre);
	reset(txt);
	rewrite(mae);
	while(not eof(txt)) do begin
		readln(txt, l.numero, l.cant);
		readln(txt, l.usuario);
		readln(txt, l.nombre);
		readln(txt, l.apellido);
		write(mae, l);
	end;
	writeln('----------------------------------------------------------');
	writeln('Archivo maestro cargado');
	writeln('----------------------------------------------------------');
	close(txt);
	close(mae);
end;
	
procedure crearDetalle(var det: detalle);
var
	txt: Text;
	nombre: string;
	c: correo;
begin
	assign(txt, 'detalle.txt');
	reset(txt);
	writeln('Ingrese nombre del archivo detalle');
	readln(nombre);
	assign(det, nombre);
	rewrite(det);
	while(not eof(txt)) do begin
		readln(txt, c.numero, c.destino);
		readln(txt, c.mensaje);
		write(det, c);
	end;
	writeln('----------------------------------------------------------');
	writeln('Archivo detalle cargado');
	writeln('----------------------------------------------------------');
	close(txt);
	close(det);
end;	
	
	
procedure leer(var det: detalle; var c:correo);
begin
	if(not eof(det)) then
		read(det, c)
	else
		c.numero := valorAlto;
end;

procedure actualizarMaestro(var mae: maestro; var det: detalle);
var
	c: correo;
	l: logs;
begin
	reset(mae);
	reset(det);
	leer(det, c);
	while(c.numero <> valorAlto) do begin
		read(mae, l);
		while(c.numero <> l.numero) do
			read(mae, l);
		while(c.numero = l.numero) do begin
			l.cant := l.cant + 1;
			leer(det, c)
		end;
		seek(mae, filepos(mae)-1);
		write(mae, l);
	end;
	close(mae);
	close(det);
end;
	
	
procedure exportarTxt(var mae: maestro);
var
	txt: Text;
	l: logs;
begin
	assign(txt, 'usuarios.txt');
	reset(mae);
	rewrite(txt);
	while(not eof(mae)) do begin
		read(mae, l);
		write(txt, ' ', l.numero, ' ', l.cant);
	end;
	writeln('Se exportaron usuarios a archivo de texto');
	close(mae);
	close(txt);
end;
	
	
var
	mae: maestro;
	det: detalle;
begin
	crearMaestro(mae);
	crearDetalle(det);
	actualizarMaestro(mae, det);
	exportarTxt(mae);
end.
	
