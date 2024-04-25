program ejercicio3;
type
	novela = record
		cod: integer;
		genero: string;
		nombre: string;
		duracion: real;
		director: string;
		precio: real;
	end;
	
	maestro = file of novela;
	
	
	
procedure leerNovelas(var n:novela);
begin
	writeln('Ingrese codigo de novela');
	readln(n.cod);
	if(n.cod <> -1) then begin
		writeln('Ingrese genero de novela');
		readln(n.genero);
		writeln('Ingrese nombre de novela');
		readln(n.nombre);
		writeln('Ingrese duracion de la novela');
		readln(n.duracion);
		writeln('Ingrese director de la novela');
		readln(n.director);
		writeln('Ingrese precio de la novela');
		readln(n.precio);
	end;
end;
	
	

procedure cargarArchivo(var mae: maestro);
var
	n: novela;
	nombre: string;
begin
	writeln('Ingrese nombre del archivo');
	readln(nombre);
	assign(mae, nombre);
	rewrite(mae);
	n.cod:= 0;
	write(mae, n);
	leerNovelas(n);
	while(n.cod <> -1) do begin
		write(mae, n);
		leerNovelas(n);
	end;
	writeln('----------------------------------------------------------');
	writeln('Archivo creado correctamente');
	writeln('----------------------------------------------------------');
	close(mae);	
end;

procedure darAlta(var mae: maestro);
var
	n: novela;
	libre: integer;
begin
	reset(mae);
	seek(mae, 0);
	read(mae, n);
	libre := n.cod;
	if(libre > 0) then begin
		writeln('Ingrese codigo de novela (ingrese -1 para terminar)');
		readln(n.cod);
		if(n.cod <> -1) then begin
			writeln('Ingrese genero de novela');
			readln(n.genero);
			writeln('Ingrese nombre de novela');
			readln(n.nombre);
			writeln('Ingrese duracion de la novela');
			readln(n.duracion);
			writeln('Ingrese director de la novela');
			readln(n.director);
			writeln('Ingrese precio de la novela');
			readln(n.precio);
			seek(mae, libre);
			write(mae, n);
			seek(mae, 0);
			n.cod := libre;
			write(mae, n);
			writeln('----------------------------------------------------------');
            writeln('Novela agregada correctamente');
			writeln('----------------------------------------------------------');
		end;
	end
	else 
		writeln('No hay espacio para agregar novelas');
	close(mae);
end;


	
procedure leerDatos(var n:novela);
begin
	writeln('Ingrese genero de novela');
	readln(n.genero);
	writeln('Ingrese nombre de novela');
	readln(n.nombre);
	writeln('Ingrese duracion de la novela');
	readln(n.duracion);
	writeln('Ingrese director de la novela');
	readln(n.director);
	writeln('Ingrese precio de la novela');
	readln(n.precio);
end;
	



procedure modificar(var mae: maestro);
var
	codigo: integer;
	n: novela;
	encontre: boolean;
begin
	writeln('Ingrese el codigo de la novela que va a modificar');
	readln(codigo);
	reset(mae);
	encontre:= false;
	while(not eof(mae)) and (not encontre) do begin 
		read(mae, n);
		if(n.cod = codigo) then
			encontre:= true;
	end;
	if(encontre = true) then begin
		leerDatos(n);
		seek(mae, filepos(mae)-1);
		write(mae, n);
		writeln('----------------------------------------------------------');
		writeln('Novela modificada correctamente');
		writeln('----------------------------------------------------------');
	end
	else
		writeln('No se encontro el codigo ingresado');
	close(mae);
end;






procedure eliminar(var mae: maestro);
var
	n, cabecera:novela;
	codigo, libre: integer;
	encontre: boolean;
begin
	reset(mae);
	writeln('Ingrese codigo de la novela a eliminar');
	readln(codigo);
	encontre:= false;
	libre:= -1;
	while (not eof(mae)) and (not encontre) do begin
		read(mae, n);
		if(n.cod = codigo) then begin
			encontre:= true;
			seek(mae, 0);
			read(mae, cabecera);
			libre := filepos(mae);
			n.cod := -cabecera.cod;
			seek(mae, libre);
			write(mae, n);
			
			cabecera.cod := libre;
			seek(mae, 0);
			write(mae, cabecera);
			writeln('----------------------------------------------------------');
            writeln('Novela eliminada correctamente');
            writeln('----------------------------------------------------------');
		end;
	end;
	if(not encontre) then
		writeln('No se encontro una novela con el codigo ingresado');
	close(mae);
end;



procedure reporte(var mae:maestro);
var
	n: novela;
	txt: Text;
begin
	assign(txt, 'novelas.txt');
	rewrite(txt);
	reset(mae);
	while(not eof(mae)) do begin
		read(mae, n);
		writeln(txt, ' ', n.cod, ' ', n.duracion, ' ', n.precio, ' ', n.genero);
		writeln(txt, ' ', n.nombre);
		writeln(txt, ' ', n.director);
	end;
	writeln('----------------------------------------------------------');
	writeln('Archivo de texto cargado correctamente');
	writeln('----------------------------------------------------------');

end;
	


var
	mae: maestro;
	opcion: char;
begin
	cargarArchivo(mae);
	
	repeat 
		writeln('Ingrese una opcion a elegir');
		writeln('a. Dar de alta');
		writeln('b. Modificar datos');
		writeln('c. Eliminar novela');
		writeln('d. Listar novelas en archivo de texto');
		writeln('e. Salir');
		readln(opcion);
		case opcion of
			'a': darAlta(mae);
			'b': modificar(mae);
			'c': eliminar(mae);
			'd': reporte(mae);
		end;
	until(opcion = 'e');
end.
