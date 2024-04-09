program ejercicio1;
type 
	cadena15 = string[15];
	comision = record;
		cod: integer;
		nom: cadena15;
		monto: real;
	end;
	
	archivo = file of comision;
	
	totalcomi = record;
		cod: integer;
		nom: cadena15;
		total: real;
	end;
	
	archivoTotal = file of totalcomi;
	
//modulos

procedure cargar(var a: archivoTotal; arch: archivo);	
var
	c: comision;
	actual: integer;
	tc: totalcomi;
	monto: integer;
begin
	rewrite(a);
	reset(arch);
	read(c, arch);
	while not eof (arch) do begin
		actual := c.cod;
		monto := 0;
		tc.nom := c.nom;
		while(actual = c.cod) do begin
			monto := monto + c.monto;
			read(c, arch);
		end;
		tc.monto = monto;
		tc.cod = actual;
		write(tc, a);
	end;
	close(a);
	close(arch);
end;
	
	
var
	arch: archivo; //se dispone
	aT: archivoTotal;
begin
	assign(aT, 'comisiones_Totales');
	procesar(aT, arch);
	
	
