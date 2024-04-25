program ejercicio2;
const
	dimF = 3;
type
	asistentes = record
		num: integer;
		nomApe: string;
		email: string;
		telefono: integer;
		dni: integer;
	end;
	
	archivo = file of asistentes;
	
	
procedure leer(var a: asistentes);
begin
	writeln('Ingrese numero de asistente');
	readln(a.num);
	writeln('Ingrese nombre y apellido de asistente');
	readln(a.nomApe);
	writeln('Ingrese email de asistente');
	readln(a.email);
	writeln('Ingrese telefono de asistente');
	readln(a.telefono);
	writeln('Ingrese DNI de asistente');
	readln(a.dni);
end;	
		
	
procedure cargar(var a: archivo);
var
	asi: asistentes;
	i: integer;
	nombre:string;
begin
	writeln('Ingrese nombre del archivo');
	readln(nombre);
	assign(a, nombre);
	rewrite(a);
	for i:= 1 to dimF do begin
		leer(asi);
		write(a, asi);
	end;
	writeln('----------------------------------------------------------');
	writeln('Archivo cargado correctamente');
	writeln('----------------------------------------------------------');
	close(a);
end;


procedure eliminar(var a:archivo);
var
	reg: asistentes;
begin
	reset(a);
	while(not eof(a)) do begin
		read(a, reg);
		if(reg.num < 1000) then begin
			reg.nomApe := '@' + reg.nomApe;
			seek(a, filepos(a)-1);
			write(a, reg);
		end;
	end;
	close(a);
end;	


		
			
procedure reporte(var a: archivo);
var
  reg : asistentes;
begin
	reset(a);
	while(not eof(a)) do begin
		read(a, reg);
		writeln('Codigo: ', reg.num,'. Nombre y apellido:  ',reg.nomApe);
  end;
  close(a);
end;
	



var
	a:archivo;
begin
	cargar(a);
	reporte(a);
	eliminar(a);
	reporte(a);
end.
