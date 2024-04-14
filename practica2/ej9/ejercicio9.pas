program ejercicio9;
const
	valorAlto = 9999;
type
	mesa = record
		codProv: integer;
		codLocalidad: integer;
		numeroMesa: integer;
		cantVotos: integer;
	end;
	
	maestro = file of mesa;


	
procedure crearMaestro(var mae: maestro);
var
	txt: Text;
	m: mesa;
	nombre: string;
begin
	assign(txt, 'maestro.txt');
	writeln('Ingrese nombre para el archivo maestro');
	readln(nombre);
	assign(mae, nombre);
	reset(txt);
	rewrite(mae);
	while(not eof(txt)) do begin
		readln(txt, m.codProv, m.codLocalidad, m.numeroMesa , m.cantVotos);
		write(mae, m);
	end;
	writeln('--------------------------------------------------------');
	writeln('Archivo maestro cargado');
	writeln('--------------------------------------------------------');
	close(txt); 
	close(mae);	
end;

procedure leer(var mae: maestro; var m: mesa);
begin
	if(not eof(mae)) then
		read(mae, m)
	else
		m.codProv := valorAlto;
end;




procedure reporte(var mae: maestro);
var
	m: mesa;
	actProv, actLocal, totalProv, totalLocal, total: integer;
begin
	reset(mae);
	leer(mae, m);
	total:= 0;
	while(m.codProv <> valorAlto) do begin
		writeln('Codigo provincia: ', m.codProv);
		totalProv:= 0;
		actProv := m.codProv;
		while(m.codProv = actProv) do begin
			writeln('Codigo localidad            Total de votos');
			actLocal:= m.codLocalidad;
			totalLocal:= 0;
			while((actProv = m.codProv) and (actLocal = m.codLocalidad)) do begin
				totalLocal:= totalLocal + m.cantVotos;
				leer(mae, m);
			end;
			writeln(actLocal, '                             ', totalLocal);
			totalProv:= totalProv + totalLocal;
		end;
		writeln('Total de votos provincia: ', totalProv);
		total:= total + totalProv;
	end;
	writeln();
	writeln('Total general de votos:', total);
	close(mae);
end;






var
	mae: maestro;
begin
	crearMaestro(mae);
	reporte(mae);
end.
