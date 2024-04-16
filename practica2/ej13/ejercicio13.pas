program ejercicio13;
const
	valorAlto = 'ZZZ';
type
	vuelos = record
		destino: string;
		fecha: string;
		salida: string;
		cantDisp: integer;
	end;
	
	info = record
		destino: string;
		fecha: string;
		salida: string;
		cantComp: integer;
	end;
	
	maestro = file of vuelos;
	detalle = file of info;
	
procedure crearMaestro(var mae: maestro);
var
	txt: Text;
	v: vuelos;
	nombre: string;
begin
	assign(txt, 'maestro.txt');
	writeln('Ingrese nombre del archivo maestro');
	readln(nombre);
	assign(mae, nombre);
	reset(txt);
	rewrite(mae);
	while(not eof(txt)) do begin
		readln(txt, v.cantDisp, v.destino);
		readln(txt, v.fecha);
		readln(txt, v.salida);
		write(mae, v);
	end;
	writeln('----------------------------------------------------------');
	writeln('Archivo maestro cargado');
	writeln('----------------------------------------------------------');
	close(txt);
	close(mae);
end;
	
procedure crearDetalle(var det: detalle);
var
	txt: Text;
	i: info;
	nombre: string;
begin
	assign(txt, 'detalle.txt');
	writeln('Ingrese nombre del archivo detalle');
	readln(nombre);
	assign(det, nombre);
	reset(txt);
	rewrite(det);
	while(not eof(txt)) do begin
		readln(txt, i.cantComp, i.destino);
		readln(txt, i.fecha);
		readln(txt, i.salida);
		write(det, i);
	end;
	writeln('----------------------------------------------------------');
	writeln('Archivo detalle cargado');
	writeln('----------------------------------------------------------');
	close(txt);
	close(det);
end;

procedure leer(var det: detalle; var regd: info);
begin
	if(not eof(det)) then
		read(det, regd)
	else
	regd.destino := valorAlto;
end;

procedure minimo(var det1, det2: detalle; var regd1, regd2, min: info);
begin
	if(regd1.destino < regd2.destino) then begin
		min:= regd1;
		leer(det1, regd1)
	end
	else begin
		min:= regd2;
		leer(det2, regd2)
	end;
end;



procedure actualizar(var mae: maestro; var det1, det2: detalle);
var
	regd1, regd2, min: info;
	regm: vuelos;
	cant: integer;
	txt: Text;
begin
	writeln('Ingrese cantidad de asientos');
	readln(cant);
	assign(txt, 'lista.txt');
	rewrite(txt);
	reset(mae);
	reset(det1); reset(det2);
	leer(det1, regd1); 
	leer(det2, regd2);
	minimo(det1, det2, regd1, regd2, min);
	while(min.destino <> valorAlto) do begin
		read(mae, regm);
		while(min.destino <> regm.destino) do
			read(mae, regm);
		while(min.destino = regm.destino) do begin
			while(min.fecha <> regm.fecha) do 
				read(mae, regm);
			while(min.destino = min.destino) and (min.fecha = regm.fecha) do begin
				while(min.salida <> regm.salida) do
					read(mae, regm);
				while(min.destino = regm.destino) and (min.fecha = regm.fecha) and (min.salida = regm.salida) do begin
					regm.cantDisp:= regm.cantDisp - min.cantComp;
					minimo(det1, det2, regd1, regd2, min);
				end;
				if(regm.cantDisp < cant) then
					writeln(txt, ' ', regm.destino, ' ', regm.salida, ' ', regm.fecha);
				seek(mae, filepos(mae) -1);
				write(mae, regm);	
			end;
		end;
	end;
	close(mae);
	close(det1);
	close(det2);
	close(txt);
	
end;	


var	
	mae: maestro;
	det1, det2: detalle;
	
begin
	crearMaestro(mae);
	crearDetalle(det1);
	crearDetalle(det2);
	actualizar(mae, det1, det2);

end.
		
