program ejercicio8;
const
	valorAlto = 'ZZZ';
type
	distribucion = record
		nombre: string;
		anio: integer;
		kernel: real;
		cant: integer;
		desc: string;
	end;
	
	maestro = file of distribucion ;
	
procedure leer(var mae:maestro; var reg: distribucion);
begin
	if(not eof(mae)) then
		read(mae, reg)
	else
		reg.nombre := valorAlto;
end;
	
	
procedure leerDatos(var d: distribucion);
begin
	write('Ingrese nombre ');
	readln(d.nombre);
	if(d.nombre <> 'f') then begin
		write('Ingrese anio de salida ');
		readln(d.anio);
		write('Ingrese kernel ');
		readln(d.kernel);
		write('Ingrese cantidad de desarrolladores ');
		readln(d.cant);
		write('Ingrese descripcion ');
		readln(d.desc);
	end;
end;


	
procedure crearMaestro(var mae: maestro);
var
	txt: Text;
	d:distribucion;
begin
	assign(txt, 'maestro.txt');
	assign(mae, 'maestro.dat');
	reset(txt);
	rewrite(mae);
	while(not eof(txt))do begin
		readln(txt, d.anio, d.kernel, d.cant, d.nombre);
		readln(txt, d.desc);
		write(mae, d);
	end;
	writeln('--------------------------------------------------------');
	writeln('Archivo maestro cargado');
	writeln('--------------------------------------------------------');
	close(mae);	
end;	

function existeDistribucion(var mae: maestro; nombre: string): boolean;
var
	d: distribucion;
begin
	reset(mae);
	leer(mae, d);
	while(d.nombre <> valorAlto) and (d.nombre <> nombre) do
		leer(mae, d);
	if(d.nombre = nombre) then
		existeDistribucion:= true
	else
		existeDistribucion:= false;
	close(mae);
end;

procedure altaDistribucion(var mae: maestro);
var
	d, libre: distribucion;
begin
	leerDatos(d);
	if(not existeDistribucion(mae, d.nombre)) then begin
		reset(mae);
		leer(mae, d);
		if(d.cant < 0) then begin
			seek(mae, abs(d.cant));
			read(mae, libre);
			seek(mae, filepos(mae)-1);
			write(mae, d);
			seek(mae, 0);
			write(mae, libre);
		end
		else
			writeln('No hay espacio libre');
	end
	else
		writeln('Ya existe la distribucion');
	close(mae);
end;

procedure bajaDistribucion(var mae: maestro);
var
	d, libre: distribucion;
	nom:string;
begin
	writeln('Ingrese nombre de la distribucion a eliminar');
	readln(nom);
	if(existeDistribucion(mae, nom)) then begin
		reset(mae); 
		leer(mae, libre);
		leer(mae, d);
		while(d.nombre <> valorAlto) and (d.nombre <> nom) do
			leer(mae, d);
		if(d.nombre = nom) then begin
			d.cant := libre.cant;
			seek(mae, filepos(mae)-1);
			libre.cant := filepos(mae)*-1;
			write(mae, d);
			seek(mae, 0);
			write(mae, libre);
			writeln('Distribucion eliminada');
		end;
		close(mae);
	end
	else
		writeln('Distribucion no existente');
end;
	




	

var
	mae: maestro;
begin
	crearMaestro(mae);
	bajaDistribucion(mae);
	altaDistribucion(mae);	
end.
