program ejercicio6;
const
	valorAlto = 999;
	dimF = 3;
type
	sesion = record
		codigo: integer;
		fecha:integer;
		tiempo: integer;
	end;
	
	detalle = file of sesion; 
	maestro = file of sesion;
	
	vDetalle = array [1..dimF] of detalle;
	vRegistro = array[1..dimF] of sesion;


procedure crearDetalles(var v: vDetalle);
var
	txt: Text;
	i: integer;
	s: sesion;
	nombre: string;
begin
	for i:= 1 to dimF do begin
		writeln('Ingrese nombre de texto');
		readln(nombre);
		assign(txt, nombre);
		writeln('Ingrese nombre del archivo detalle');
		readln(nombre);
		assign(v[i], nombre);
		reset(txt);
		rewrite(v[i]);
		while(not eof(txt)) do begin
			read(txt, s.codigo, s.tiempo, s.fecha);
			write(v[i], s);
		end;
		writeln('----------------------------------------------------');
		writeln('Archivo detalle cargado');
		writeln('----------------------------------------------------');
		close(v[i]);
		close(txt);
		
	end;
end;

procedure leer(var det: detalle; var regD: sesion);
begin
	if(not eof(det)) then
		read(det, regD)
	else
		regD.codigo := valorAlto;
end;


procedure minimo(var v: vDetalle; var vR: vRegistro; var min: sesion);
var
	i, pos: integer;
begin
	min.codigo:= valorAlto;
	min.fecha:= valorAlto;
	for i:= 1 to dimF do begin
		if(vR[i].codigo < min.codigo) or ((vR[i].codigo = min.codigo) and (vR[i].fecha < min.fecha)) then begin
			min := vR[i];
			pos:= i;
		end;
	end;
	if(min.codigo <> valorAlto) then
		leer(v[pos], vR[pos]);					
end;

procedure crearMaestro(var mae:maestro; var v: vDetalle);
var
	i: integer;
	vReg: vRegistro;
	min, regM: sesion;
begin
	assign(mae, 'maestro.dat');
	rewrite(mae);
	for i:= 1 to dimF do begin
		reset(v[i]);
		leer(v[i], vReg[i]);
	end;
	writeln('abri y lei detalles');
	minimo(v, vReg, min);
	writeln('calcule minimo');
	while(min.codigo <> valorAlto) do begin
		regM.codigo:= min.codigo;
		regM.fecha := min.fecha;
		regM.tiempo:= 0;
		writeln('inicializo datos del maestro');
		while(regM.codigo = min.codigo) and(regM.fecha = min.fecha) do begin
			regM.tiempo := regM.tiempo + min.tiempo;
			writeln('los actualizo');
			minimo(v, vReg, min);
			writeln('calculo minimo otra vez');
		end;
		write(mae, regM);
		writeln('escribi en mae');
	end;
	close(mae);
	for i:= 1 to dimF do
		close(v[i]);
end;


var
	v: vDetalle;
	mae: maestro;
begin
	crearDetalles(v);
	writeln('termino de crear detalles');
	crearMaestro(mae, v);
end.
