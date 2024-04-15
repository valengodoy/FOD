program ejercicio11;
const
	valorAlto = 999;
type
	accesos = record
		anio: integer;
		mes: integer;
		dia: integer;
		id: integer;
		tiempo: integer;
	end;
	
	maestro = file of accesos;

procedure crearMaestro(var mae: maestro);
var
	txt: Text;
	a: accesos;
	nombre: string;
begin
	assign(txt, 'accesos.txt');
	writeln('Ingrese nombre para el archivo maestro');
	readln(nombre);
	assign(mae, nombre);
	reset(txt);
	rewrite(mae);
	while(not eof(txt)) do begin
		readln(txt, a.anio, a.mes, a.dia, a.id, a.tiempo);
		write(mae, a);
	end;
	writeln('---------------------------------------------------------');
	writeln('Archivo maestro creado');
	writeln('---------------------------------------------------------');
	close(txt);
	close(mae);
end;
	
procedure leer(var mae: maestro; a: accesos);
begin
	if(not eof(mae)) then
		read(mae, a)
	else
		a.anio := valoralto;
end;
		


procedure informe(var mae:maestro);
var
	a:accesos;
	anio, actMes, actDia, actId, tiempoDia, tiempoMes, tiempoAnio, tiempoUsuario: integer;
	
begin
	writeln('Ingrese el anio del cual se hara el informe');
	readln(anio);
	reset(mae);
	leer(mae, a);
	if(a.anio <> valorAlto) then begin
		while(a.anio <> valorAlto) and (a.anio < anio) do
			leer(mae, a);
		if(a.anio = anio) then begin
			tiempoAnio:= 0;
			writeln('Anio: ', a.anio);
			while(anio = a.anio) do begin
				actMes := a.mes;
				tiempoMes:= 0;
				writeln('Mes: ', a.mes);
				while((anio = a.anio) and (actMes = a.mes)) do begin
					actDia:= a.dia;
					tiempoDia:= 0;
					writeln('Dia: ', a.dia);
					while((anio = a.anio) and (actMes = a.mes) and (actDia = a.dia)) do begin
						actId:= a.id;
						tiempoUsuario := 0;
						while((anio = a.anio) and (actMes = a.mes) and (actDia = a.dia) and (actId = a.id)) do begin
							tiempoUsuario:= tiempoUsuario + a.tiempo;
							leer(mae, a);
						end;
						writeln('idUsuario ', actId, ' Tiempo total de acceso en el dia ', actDia, ' del mes ', actMes, ': ', tiempoUsuario);
						tiempoDia:= tiempoDia + tiempoUsuario;
					end;
					writeln('Total de tiempo de acceso en el dia ', actDia, ' del mes ', actMes, ': ', tiempoDia);
					tiempoMes := tiempoMes + tiempoDia;
				end;
				writeln('Total de tiempo de acceso en el mes ', actMes, ': ', tiempoMes);
				tiempoAnio:= tiempoAnio + tiempoMes;
			end;
			writeln('Total de tiempo de acceso en el anio: ', tiempoAnio);
		end
		else
			writeln('Anio no encontrado');
	end;
	close(mae);
end;
		
		
		
var
	mae: maestro;
begin
	crearMaestro(mae);
	informe(mae);
end.
