program ejercicio8;
const
	valorAlto = 9999;
type
	cliente = record
		codigo: integer;
		nombre: string;
		apellido: string;
		anio: integer;
		mes: integer;
		dia: integer;
		monto: real;
	end;
	
	
	maestro = file of cliente;
	
	
procedure crearMaestro(var mae: maestro);
var
	txt: Text;
	c: cliente;
	nombre: string;
begin
	assign(txt, 'maestro.txt');
	writeln('Ingrese nombre para el archivo maestro');
	readln(nombre);
	assign(mae, nombre);
	reset(txt);
	rewrite(mae);
	while(not eof(txt)) do begin
		readln(txt, c.codigo, c.anio, c.mes, c.dia, c.monto, c.nombre);
		readln(txt, c.apellido);
		write(mae, c);
	end;
	writeln('--------------------------------------------------------');
	writeln('Archivo maestro cargado');
	writeln('--------------------------------------------------------');
	close(txt); 
	close(mae);	
end;
	
procedure leer(var mae: maestro; var c: cliente);
begin
	if(not eof(mae)) then
		read(mae, c)
	else
		c.codigo := valorAlto;
end;
	
	
	
	
	
procedure reporte(var mae: maestro);
var
	actMes, actAnio, actCliente: integer;
	totalEmpresa, totalMes, totalAnio: real;
	c: cliente;
begin
	reset(mae);
	leer(mae, c);
	totalEmpresa:= 0; 
	while(c.codigo <> valorAlto) do begin 
		writeln('Cliente= ', c.codigo, '. Nombre= ', c.nombre, '. Apellido= ', c.apellido);
		actCliente := c.codigo;
		actAnio:= c.anio;
		totalAnio:= 0;
		writeln('Anio= ', c.anio);
		while(actCliente = c.codigo) and (actAnio = c.anio)do begin
			actMes:= c.mes;
			totalMes:= 0;
			while(actCliente = c.codigo) and (actAnio = c.anio) and (actMes = c.mes) do begin
				totalMes:= totalMes + c.monto;
				leer(mae, c);
			end;
			if(totalMes <> 0) then begin
				writeln('Mes= ', actMes, '. Monto= ', totalMes);
			end;
		end;
		writeln('Monto del anio= ', actAnio,  '=', totalAnio);
		if(actCliente = c.codigo) then
			totalEmpresa := totalEmpresa + totalAnio;
	end;
	writeln('Monto total de la empresa= ', totalEmpresa);
	close(mae);
end;
		
	
	
var
	mae: maestro;
begin
	crearMaestro(mae);
	reporte(mae);
end.
