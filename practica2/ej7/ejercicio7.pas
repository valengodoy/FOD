program ejercicio7
const
	dimF= 10;
	valorAlto = 9999;
type
	subrango = 1..dimF;
	municipio = record
		codLocalidad: integer;
		codCepa: integer;
		casosActivos: integer;
		casosNuevos: integer;
		recuperados: integer;
		fallecidos: integer;
	end;
	
	ministerio = record
		codLocalidad: integer;
		nomLocalidad: string;
		codCepa: integer;
		nomCepa: string;
		casosActivos = integer;
		recuperados: integer;
		fallecidos: integer;
	end;
	
	maestro = file of ministerio;
	detalle = file of municipio;
	
	vDetalle = array [1..dimF] of detalle;
	vRegistro = array [1..dimF] of municipio;
	
procedure crearMaestro(var mae:maestro);	
var
	txt: Text;
	m: ministerio;
	nombre: string;
begin
	assign(txt, 'maestro.txt');
	writeln('Ingrese nombre para el archivo maestro');
	readln(nombre);
	assign(mae, nombre);
	reset(txt);
	rewrite(mae);
	while(not eof(mae)) do begin
		readln(txt, .codLocalidad, c.codCepa, c.casosActivos, c.recuperados, c.fallecidos, c.nomLocalidad);
		readln(txt, c.nomCepa);
		write(mae, c);
	end;
	writeln('----------------------------------------------------------');
	writeln('Archivo maestro cargado');
	writeln('----------------------------------------------------------');
	close(txt);
	close(mae);
end;

procedure crearDetalles(var v:vDetalle);
var
	i: subrango;
	txt: Text;
	m: municipio;
	nombre: string;
begin
	for i:= 1 to dimF do begin
		writeln('Ingrese nombre para arch de texto');
		readln(nombre);
		assign(txt, nombre);
		writeln('Ingrese nombre del archivo detalle');
		readln(nombre);
		assign(v[i], nombre);
		reset(txt);
		rewrite(v[i]);
		while(not eof(txt)) do begin
			readln(txt, m.codLocalidad, m.codCepa, m.casosActivos, m.casosNuevos, m.recuperadosfallecidos);
			write(v[i], m);
		end;
		close(v[i]);
	end;
	close(txt);
end;
	
	
procedure leer(var det: detalle; var regd: municipio);
begin
	if(not eof(det)) then
		read(det, regD)
	else
		regD.cod := valorAlto;		
end;
	
	
	
procedure actualizar(var mae:maestro; var v: vDetalle);
var
	i: subrango;
	minimo, regd: municipio;
	regm: ministerio;
	vr: vRegistro;
	casosLocalidad, cant: integer;
begin
	cant:= 0;
	for i:= 1 to dimF do begin
		reset(v[i]);
		leer(v[i], vR[i]);
	end;
	reset(mae);
	minimo(v, vR, min);
	while(min.codLocalidad <> valorAlto) do begin
		casosLocalidad:= 0;
		read(mae, regm);
		while(regm.codLocalidad <>  mincodLocalidad) do 
			read(mae, regm);
		while(regm.codLocalidad = min.codLocalidad) do
		begin
			while(regm.codCepa <> min.codcepa) do
				read(mae, regm);
			while(regm.codLocalidad = min.codLocalidad) and (regm.codcepa = min.codcepa) do begin
				regm.fallecidos := regm.fallecidos + min.fallecidos;
				regm.recuperados := regm.recuperados + min.recuperados;
				casosLocalidad := casosLocalidad + min.casosActivos;
				regm.casosActivos:= min.casosActivos;
				regm.casosNuevos :+ min.casosNuevos;
				minimo(v, vR, min);
			end;
			seek(mae, filepos(mae)-1);
			write(mae, regm);
		end;
		writeln('Cantidad de casos en la localidad: ', casosLocalidad);
		if(casosLocalidad > 50) then 
			cant:= cant +1;
	end;
	close(mae);
	for i:= 1 to dimF do 
		close(v[i]);
	writeln('La cantidad de localidades con mas de 50 casos activos: ', cant);
	
end;	
		
var
	mae: maestro;
	v: vDetalle;
begin
	crearMaestro(mae);
	crearDetalle(v);
	actualizar(mae, v):
	imprimir(mae);
end.
