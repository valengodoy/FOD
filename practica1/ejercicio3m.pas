program ejercicio3m;
type
	empleado = record
		num: integer;
		apellido: string[15];
		nombre: string[15];
		edad: integer;
		DNI: integer;
	end;
	
	archivo = file of empleado;

//procedimientos
procedure leerEmple(var e: empleado);
begin
	writeln('Ingrese apellido ');
	readln(e.apellido);
	if(e.apellido <> 'fin') then begin
		writeln('Ingrese nombre ');
		readln(e.nombre);
		writeln('Ingrese edad ');
		readln(e.edad);
		writeln('Ingrese numero ');
		readln(e.num);
		writeln('Ingrese DNI ');
		readln(e.DNI);
	end;
end;

procedure cargar(var arch: archivo);
var
	e: empleado;
begin
	rewrite(arch);
	leerEmple(e);
	while(e.apellido <> 'fin') do begin
		write(arch, e);
		leerEmple(e);
	end;
	close(arch);
end;


procedure imprimirEmple(e: empleado);
begin
	writeln('Nombre: ', e.nombre, 
		'Apellido: ', e.apellido,
		'Edad: ', e.edad,
		'Numero:', e.num,
		'DNI: ', e.num);
	
end;
	

procedure buscar(var arch: archivo);
var
	nom, ape: string[15];
	e: empleado;
begin
	reset(arch);
	writeln('Ingrese nombre');
	readln(nom);
	writeln('Ingrese apellido');
	readln(ape);
	while not eof(arch) do begin
		read(arch, e);
		if(nom = e.nombre) and (ape = e.apellido) then 
			imprimirEmple(e);			
	end;
end;


procedure mostrarTodos(var arch: archivo);
var 
	e: empleado;
begin
	reset(arch);
	writeln('Los empleados registrados son: ');
	while not eof(arch) do begin
		read(arch, e);
		imprimirEmple(e)
	end;
end;

procedure jubilados(var arch: archivo);
var
	e: empleado;
begin
	reset(arch);
	writeln('Los empleados mayores de 70 anios registrados son: ');
	while not eof(arch) do begin
		read(arch, e);
		if(e.edad > 70) then 
			imprimirEmple(e);
	end;
end;



procedure menu (var arch: archivo);
var
	opcion: char;
begin
	repeat 
		writeln('Menú:');
		writeln('a. Buscar empleado');
		writeln('b. Mostrar todos los empleados registrados');
		writeln('c. Mostrar empleados próximos a jubilarse');
		writeln('d. Salir');
		writeln('Ingrese una opcion a elegir'); 
		readln(opcion);
		case opcion of 
			'a': buscar(arch);
			'b': mostrarTodos(arch);
			'c': jubilados(arch);
		end;
	until(opcion = 'd');
end;


var
	arch: archivo;
	nombre: string;

begin
	writeln('Ingrese nombre del archivo');
	readln(nombre);
	assign(arch, nombre);
	cargar(arch);
	menu(arch);
end.
