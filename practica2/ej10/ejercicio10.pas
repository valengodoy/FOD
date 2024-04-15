program ejercicio10;
const
	valorAlto = 999;
type 
	subrango = 1..15;
	empleado = record
		depto: integer;
		division: integer;
		numero: integer;
		categoria: integer;
		cantHoras: integer;
	end;
	
	
	maestro = file of empleado;
	categoria = array[subrango] of real;
	
	
procedure crearMaestro(var mae: maestro);
var
	txt: Text;
	nombre: string;
	e: empleado;
begin
	assign(txt, 'empleados.txt');
	writeln('Ingrese nombre del archivo maestro');
	readln(nombre);
	assign(mae, nombre);
	reset(txt);
	rewrite(mae);
	while(not eof(txt)) do begin
		readln(txt, e.depto, e.division, e.numero, e.categoria, e.cantHoras);
		write(mae, e);
	end;
	writeln('----------------------------------------------------------');
	writeln('Archivo maestro cargado');
	writeln('----------------------------------------------------------');
	close(txt);
	close(mae);
end;


procedure cargarVector(var v: categoria);
var
	categoria: subrango;
	txt:Text;
	monto:real;
begin
	assign(txt, 'precioCategorias.txt');
	reset(txt);
	while(not eof(txt))do begin
		readln(txt, categoria, monto);
		v[categoria] := monto;
	end;
	close(txt);	
end;

procedure leer(var mae: maestro; var e: empleado);
begin
	if(not eof(mae)) then
		read(mae, e)
	else 
		e.depto:= valorAlto;
end;



procedure reporte(var mae: maestro; v:categoria);
var
	e: empleado;
	horasDivision, horasDepto, horasEmp, actDepto, actDivision, actNumero, categoria: integer;
	montoDivision, montoDepto, montoEmp: real; 
begin
	reset(mae);
	leer(mae, e);
	while(e.depto <> valorAlto) do begin
		writeln('Departamento: ', e.depto);
		actDepto:= e.depto;
		horasDepto := 0;
		montoDepto:= 0;
		while(actDepto = e.depto) do begin
			writeln('Division: ', e.division);
			actDivision := e.division;
			horasDivision:= 0;
			montoDivision:= 0;
			writeln('Numero de Empleado      Total de Hs.      Importe a cobrar');
			while((actDepto = e.depto) and (actDivision = e.division)) do begin
					montoEmp:= 0;
					horasEmp:= 0;
					actNumero:= e.numero;
					categoria:= e.categoria;
					while((actDepto = e.depto) and (actDivision = e.division) and (actNumero = e.numero)) do begin
						horasEmp:= horasEmp + e.cantHoras;
						leer(mae, e);
					end;	
				montoEmp:= v[categoria] * horasEmp;
				writeln(actNumero,'                        ', horasEmp, '                ', montoEmp:0:2);
				montoDivision := montoDivision + montoEmp;
				horasDivision := horasDivision + horasEmp;
			end;
			writeln('Total de horas division: ', horasDivision);
			writeln('Monto total por division: ', montoDivision:0:2);
			montoDepto:= montoDepto + montoDivision;
			horasDepto:= horasDepto + horasDivision;	
		end;
		writeln('Total horas departamento: ', horasDepto); 
		writeln('Monto total departamento: ', montoDepto:0:2);
	end;
	close(mae);	
end;

var
	v: categoria;
	mae: maestro;
begin
	crearMaestro(mae);
	cargarVector(v);
	reporte(mae, v);
end.
