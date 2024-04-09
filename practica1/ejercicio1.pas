program generar_Archivo;
type 
	archivo = file of integer;
	
	
//procedimientos
procedure recorrer(var nomLog: archivo; var cant: real; var total: real);
var
	nro: integer;
begin
	reset(nomLog);
	while not eof (nomLog) do begin
		read(nomLog, nro);
		total:= total+1;
		if(nro < 1500) then
			cant:= cant+1;
		write('El numero es: ', nro);
	end;
	close(nomLog);
	
end;
	
var
	nomLog: archivo;
	num:integer;
	cant, total: real;
	nomFis: string[15];
	
begin
	cant:= 0;
	total:= 0;
	writeln('Ingrese nombre del archivo');
	readln(nomFis);
	assign(nomLog, nomFis);
	rewrite(nomLog);
	read(num);
	while(num <> 3000) do begin
		write(nomLog, num);
		read(num);
	end;
	close(nomLog);
	recorrer(nomLog, cant, total);
	writeln('cant ', cant); writeln('total', total);
	writeln('Se encontraron', cant, ' numeros menores a 1500.');
	writeln('El promedio de este fue de: ', cant/total);
end.
	
