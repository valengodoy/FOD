program ejercicio4y5;
type
	flor = record
	nombre: String[45];
	codigo:integer;
	end;
	
	archFlor = file of flor;
	
//procedimientos
	
procedure cargarArchivo(var a:archFlor);
var
	txt: Text;
	f: flor;
begin
	assign(txt, 'flores.txt');
	assign(a, 'flores.dat');
	reset(txt);
	rewrite(a);
	f.codigo := 0;
	write(a, f);
	while(not eof(txt)) do begin
		readln(txt, f.codigo, f.nombre);
		write(a, f);
	end;
	writeln('---------------------------------------------------------');
	writeln('Archivo maestro cargado');
	writeln('---------------------------------------------------------');
	close(txt);
	close(a);
end;



procedure eliminarFlores(var a: archFlor; reg: flor);
var
	f, libre: flor;
begin
	reset(a);
	read(a, f);
	libre.codigo:= f.codigo;
	while(not eof(a))and (f.codigo <> reg.codigo ) do begin
		read(a, f);
		if(f.codigo = reg.codigo) then begin
			f.codigo:= libre.codigo;
			seek(a, filepos(a)-1);
			libre.codigo:= (filepos(a)* -1);
			write(a, f);
			seek(a, 0);
			write(a, libre);
			writeln('---------------------------------------------------------');
			writeln('Flor eliminada correctamente');
			writeln('---------------------------------------------------------');
		end;
	end;
	close(a);	
end;
	
procedure agregarFlor (var a: archFlor; nombre: string; codigo:integer);
var
	f, libre: flor;
begin
	reset(a);
	read(a, f);
	if(f.codigo < 0) then begin
		seek(a, abs(f.codigo));
		read(a, libre);
		f.nombre:= nombre;
		f.codigo:= codigo;
		seek(a, filepos(a)-1);
		write(a, f);
		seek(a, 0);
		write(a, libre);
	end
	else begin
		f.nombre:= nombre;
		f.codigo:= codigo;
		seek(a, filesize(a));
		write(a, f);
		writeln('---------------------------------------------------------');
		writeln('Flor agregada correctamente');
		writeln('---------------------------------------------------------');
	end;
	close(a);
end;


procedure imprimir(var a: archFlor);
var
	f: flor;
begin
	reset(a);
	while(not eof(a)) do begin
		read(a, f);
		if(f.codigo > 0) then
			writeln('Codigo: ', f.codigo, '. Nombre: ', f.nombre);
	end;
	close(a);
end;



var
	a: archFlor;
	nombre: string;
	codigo: integer;
	reg: flor;
begin
	cargarArchivo(a);
	imprimir(a);
	writeln('ingrese codigo de la flor a eliminar');
	readln(reg.codigo);
	eliminarFlores(a, reg);
	imprimir(a);
	writeln('Ingrese nombre de la flor a agregar');
	readln(nombre);
	writeln('Ingrese codigo de la flor a agregar');
	readln(codigo);
	agregarFlor(a, nombre, codigo);
	imprimir(a);
end.
