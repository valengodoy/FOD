program ejercicio5;
const
	dimF = 3;
	valorAlto = 999;
type 
	rango = 1..dimF;
	producto = record
		codigo: integer;
		nombre: string[15];
		descripcion: string[20];
		stockDisp: integer;
		stockMinimo: integer;
		precio: real;
	end;
	
	informacion = record
		codigo: integer;
		vendido: integer;
	end;
	
	maestro = file of producto;
	detalle = file of informacion;
	
	vDetalles = array [1..dimF] of detalle;
	vRegistro = array[1..dimF] of informacion;

procedure crearMaestro(var mae: maestro);
var
	txt: Text;
	p: producto;
	nombre: string;
begin
	assign(txt, 'maestro.txt');
	reset(txt);
	writeln('Ingrese un nombre para el archivo maestro');
	readln(nombre);
	assign(mae, nombre);
	rewrite(mae);
	while (not eof(txt)) do begin
		readln(txt, p.codigo, p.stockDisp, p.stockMinimo,p.nombre);
		readln(txt, p.descripcion);
		write(mae, p);
	end;
	writeln('-------------------------------------------------');
	writeln('Archivo maestro cargado');
	writeln('-------------------------------------------------');
	close(txt);
	close(mae);
end;


procedure crearDetalles(var v: vDetalles);
var
	i: rango;
	txt: Text;
	info: informacion;
	nombre: string;
	
begin 
	for i:= 1 to dimF do begin
		writeln('Ingrese nombre del archivo de texto');
		readln(nombre);
		assign(txt, nombre);
		reset(txt);
		writeln('Ingrese nombre del archivo detalle');
		assign(v[i], nombre);
		rewrite(v[i]);
		while(not eof(txt)) do begin
			readln(txt, info.codigo, info.vendido);
			write(v[i], info);
		
		end;
		writeln('-------------------------------------------------');
		writeln('Archivo detalle cargado');
		writeln('-------------------------------------------------');
		close(v[i]);
		close(txt);
	end;	
end;

procedure leer(var det: detalle; var regD: informacion);
begin
	if(not eof(det)) then 
		read(det, regD)
	else
		regD.codigo := valorAlto;
end;

procedure minimo(var v: vDetalles; var vReg: vRegistro; var min: informacion);
var
	i, pos: integer;
begin
	min.codigo:= valorAlto;
	for i:= 1 to dimF do begin
		if(vReg[i].codigo < min.codigo) then begin
			min:= vReg[i];
			pos:= i;
		end;
	end;
	if(min.codigo <> valorAlto) then
		leer(v[pos], vReg[pos]);
end;


procedure actualizar(var mae: maestro; var v: vDetalles);
var
	min: informacion;
	regM: producto;
	vReg: vRegistro;
	i: rango;

begin
	reset(mae);
	for i:= 1 to dimF do begin
		reset(v[i]);
		leer(v[i], vReg[i]);
	end;
	minimo(v, vReg, min);
	while(min.codigo <> valorAlto) do begin
		read(mae, regM);
		while(regM.codigo <> min.codigo) do
			read(mae, regM);
		while(regM.codigo = min.codigo) do begin
			regM.stockDisp := regM.stockDisp - min.vendido;
			minimo(v, vReg, min);
		end;
		seek(mae, filepos(mae)-1);
		write(mae, regM);
	end;
	close(mae);
	for i:= 1 to dimF do
			close(v[i]);
end;


procedure informarTxt(var mae: maestro);
var
	txt: Text;
	p: producto;
begin
	assign(txt, 'stock.txt');
	reset(mae);
	rewrite(txt);
	while(not eof(mae)) do begin
		read(mae, p);
		if(p.stockDisp < p.stockMinimo) then 
			write(txt, ' ', p.codigo, ' ', p.nombre, ' ', p.descripcion, ' ', p.stockDisp, ' ', p.stockMinimo, ' ', p.precio);
	
	end;
	close(txt);
	close(mae);
end;

	
var
	mae: maestro;
	vec: vDetalles;
begin 
	crearMaestro(mae);
	crearDetalles(vec);
	actualizar(mae, vec);
	informarTxt(mae);
end.
