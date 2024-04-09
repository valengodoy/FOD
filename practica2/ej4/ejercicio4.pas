program ejercicio4;
const
	valorAlto = 'ZZZ';
type
	datos = record
		alfab: integer;
		total: integer;
		provincia: string;
	end;

	censo = record
		codigo: integer;
		alfab: integer;
		total: integer;
		provincia: string;
	end;
	
	maestro = file of datos;
	detalle = file of censo;
	
procedure crearMaestro(var mae: maestro; var a: Text);
var
	d: datos;
begin
	assign(a, 'maestro.txt');
	assign(mae, 'maestro.dat');
	reset(a);
	rewrite(mae);
	while(not eof(a)) do begin
		readln(a, d.alfab, d.total, d.provincia);
		write(mae, d);
	end;
	writeln('----------------------------------------------');
	writeln('Archivo maestro cargado.');
	writeln('----------------------------------------------');
	close(a);
	close(mae);
end;

procedure crearDetalle(var det: detalle; var a:Text);
var
	c: censo;
	nombre: string;
begin
	reset(a);
	writeln('Ingrese nombre de dat detalle');
	readln(nombre);
	assign(det, nombre);
	rewrite(det);
	while(not eof(a)) do begin
		readln(a, c.codigo, c.alfab, c.total, c.provincia);
		write(det, c);
	end;
	writeln('----------------------------------------------');
	writeln('Archivo detalle cargado.');
	writeln('----------------------------------------------');
	close(a);
	close(det);
end;

procedure leer(var det:detalle; var regd: censo);
begin
	if(not eof(det)) then
		read(det, regd)
	else
		regd.provincia:= valorAlto;
end;

procedure minimo(var r1, r2: censo; var min: censo; var det1, det2: detalle);
begin
	if(r1.provincia <= r2.provincia) then begin
		min:= r1;
		leer(det1, r1);
		writeln(min.provincia);
	end
	else begin
		min:= r2;
		leer(det2, r2);
	end;
end;
	

procedure actualizar(var mae: maestro; var det1, det2: detalle);
var
	regm: datos;
	regd1, regd2, min: censo;
begin
	reset(mae);
	reset(det1);
	reset(det2);
	leer(det1, regd1);
	leer(det2, regd2);
	minimo(regd1, regd2, min, det1, det2);
	writeln(min.provincia);
	while(min.provincia <> valorAlto) do begin
		read(mae, regm);
		while(min.provincia <> regm.provincia) do
			read(mae, regm);
		while(min.provincia = regm.provincia) do begin
			regm.alfab:= regm.alfab + min.alfab;
			regm.total:= regm.total + min.total;
			minimo(regd1, regd2, min, det1, det2);
		end;
		seek(mae, filepos(mae)-1);
		write(mae, regm);
	end;
end;
		
var
	mae: maestro;
	txtMae, txtDet1, txtDet2:Text;
	det1, det2: detalle;
	
begin
	assign(txtDet1, 'detalle1.txt');
	assign(txtDet2, 'detalle2.txt');
	crearMaestro(mae, txtMae);
	crearDetalle(det1,txtDet1);
	crearDetalle(det2, txtDet2);
	actualizar(mae, det1, det2);	
end.
