program ejercicio3;
const 
	valorAlto = 9999;
type 

	cadena15 = string[15];
	producto = record
		codigo: integer;
		precio: real;
		stockActual: integer;
		stockMinimo: integer;
		nombre: cadena15;
	end;
	
	venta = record
		codigo: integer;
		cantidad: integer;
	end;
	
	
	maestro = file of producto;
	detalle = file of venta;

procedure crearMaestro(var mae: maestro; var a:Text);
var
	p: producto;
begin
	assign(a, 'maestro.txt');
	reset(a);
	assign(mae, 'maestro.dat');
	rewrite(mae);
	while(not eof(a)) do begin
		readln(a, p.codigo, p.precio, p.stockActual, p.stockMinimo, p.nombre);
		write(mae, p);
	end;
	writeln('----------------------------------------------');
	writeln('Archivo maestro cargado.');
	writeln('----------------------------------------------');
	close(a);
	close(mae);
	
end;

procedure crearDetalle(var det: detalle; var a: Text);
var
	v: venta;
begin
	assign(a, 'detalle.txt');
	reset(a);
	assign(det, 'detalle.dat');
	rewrite(det);
	while(not eof(a)) do begin
		readln(a, v.codigo, v.cantidad);
		write(det, v);
	end;
	writeln('----------------------------------------------');
	writeln('Archivo detalle cargado.');
	writeln('----------------------------------------------');
	close(a);
	close(det);
end;

procedure leer(var archivo: detalle; var regd: venta);
begin
	if(not eof(archivo)) then 
		read(archivo, regd)
	else
		regd.codigo := valorAlto;
end;



procedure actualizar(var mae: maestro; var det: detalle);
var
	regm: producto;
	regd: venta;
begin
	reset(mae);
	reset(det);
	leer(det, regd);
	while(regd.codigo <> valorAlto)do begin
		read(mae, regm);
		while(regd.codigo <> regm.codigo) do
			read(mae, regm);
		while(regd.codigo = regm.codigo) do begin
			regm.stockActual := regm.stockActual - regd.cantidad;
			leer(det, regd);
		end;
		seek(mae, filepos(mae)-1);
		write(mae, regm);
	end;
	close(mae);
	close(det);
end;
	
procedure mostrarProductos(var mae: maestro);
var
	p:producto;
	a: Text;
begin
	assign(a, 'stock_minimo.txt');
	reset(mae);
	rewrite(a);
	while(not eof(mae)) do begin
		read(mae, p);
		if(p.stockActual < p.stockMinimo) then begin
			writeln(a, ' ', p.codigo, ' ', p.precio, ' ', p.stockActual, ' ', p.stockMinimo, ' ', p.nombre);
		end;
	end;
	writeln('----------------------------------------------');
	writeln('Archivo de texto cargado.');
	writeln('----------------------------------------------');
	close(mae);
	close(a);
	
end;	
	
var
	mae: maestro;
	det: detalle;
	txtMae, txtDet: Text;
	opcion: char;
begin
	crearMaestro(mae, txtMae);
	crearDetalle(det, txtDet);
	repeat
		writeln('Menu:');
		writeln('a. Actualizar archivo de productos');
		writeln('b. Mostrar productos con menor stock que el minimo');
		writeln('c. Salir');
		writeln('Ingrese una opcion a elegir');
		readln(opcion);
		case opcion of 
			'a': actualizar(mae, det);
			'b': mostrarProductos(mae);
		end;
	until(opcion = 'c');
end.
