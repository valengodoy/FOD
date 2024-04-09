program ejercicio2;
const 
	valorAlto = 9999;
type
	cadena15 = string[15];
	alumno = record
		cod: integer;
		cantCurs: integer;
		cantFinal: integer;
		apenomb: string;
	end;
	
	info = record
		cod: integer;
		materia: integer; //1 = final ---- 0 = cursada 
	end;
	
	maestro = file of alumno;
	detalle = file of info;
	
//modulos

procedure cargarMaestro(var mae: maestro; var a: Text);
var
	alu: alumno;
begin
	assign(a, 'alumnos.txt');
	reset(a);
	assign(mae, 'maestro.dat');
	rewrite(mae);
	while not eof (a) do begin
		readln(a, alu.cod, alu.cantCurs, alu.cantFinal, alu.apenomb);
		writeln(alu.cod);
		writeln(alu.apenomb);
		write(mae, alu);
	end;
	writeln('----------------------------------------------');
	writeln('Archivo cargado.');
	writeln('----------------------------------------------');
	close(a);
	close(mae);
end;
	
procedure cargarDetalle(var det: detalle; var a:Text);
var
	i: info;
begin
	assign(a, 'detalle.txt');
	reset(a);
	assign(det, 'detalle.dat');
	rewrite(det);
	while not eof (a) do begin
		read(a, i.cod, i.materia);
		writeln(i.cod);
		write(det, i);
	end;
	writeln('----------------------------------------------');
	writeln('Archivo cargado.');
	writeln('----------------------------------------------');
	close(a);
	close(det);
end;
	
 
procedure leer(var archivo: detalle; var dato: info);
begin
	if(not eof(archivo)) then
		read(archivo, dato)
	else
		dato.cod := valorAlto;
end;	
	

procedure actualizar(var mae: maestro; var det: detalle);
var
	regd: info;
	regm: alumno;
begin
	reset(mae);
	reset(det);

	leer(det, regd);
	while(regd.cod <> valorAlto) do begin
		read(mae, regm);
		writeln(regm.cod);
		writeln(regd.cod);
		while(regm.cod <> regd.cod) do 
			read(mae, regm);
		while(regd.cod <> valorAlto) and(regm.cod = regd.cod)do begin
			if(regd.materia = 1) then  begin
				regm.cantFinal := regm.cantFinal + 1;
				regm.cantCurs := regm.cantCurs -1;
			end
			else if(regd.materia = 0) then
				regm.cantCurs := regm.cantCurs +1;
			leer(det, regd);
		end;
		seek(mae, filepos(mae)-1);
		write(mae, regm);
	end;
	close(mae);
	close(det);
end;	
	
	
procedure alumnosCursada(var mae: maestro);
var
	a:Text;
	alu: alumno;
begin
	reset(mae);
	assign(a, 'alumnosCursada.txt');
	rewrite(a);
	while (not eof(mae))do begin
		read(mae, alu);
		if(alu.cantCurs > 4) then begin
			writeln(a, 'Codigo: ', alu.cod);
			writeln(a, 'Apellido y nombre: ', alu.apenomb);
			writeln(a, 'Cantidad de materias cursadas: ', alu.cantCurs);
			writeln(a, 'Cantidad de materias con final aprobado: ', alu.cantFinal);
			writeln(a, '----------------------------------------------');
		end;
	end;
    close(mae);
    close(a);
end;
		 
var
	archAlu: Text;
	archInfo: Text;
	mae: maestro;
	det: detalle;
	opcion: char;
begin
	cargarMaestro(mae, archAlu);
	cargarDetalle(det, archInfo);
	repeat 
		writeln('Menu: ');
		writeln('a. Actualizar archivo maestro');
		writeln('b. Listar alumnos con mas de 4 cursadas aprobadas');
		writeln('c. Salir');
		writeln('Ingrese una opcion');
		readln(opcion);
		case opcion of
			'a': actualizar(mae, det);
			'b': alumnosCursada(mae);
		end;
	until(opcion = 'c');	
end.
