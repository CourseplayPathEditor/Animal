-- debugging our script -------------------
function gAm:debugging()
	if (gAm.deBug == true) then
		a = gAm;
		if (a == nil) then
		print ("gAm does not exist");
		else
		print ("gAm is ready");
			-- for k, v in pairs (gAm) do
			-- print("gAm: ",k, " = ", v);
			-- end;
			
			-- for k, v in pairs (gAm.animals) do
			-- print("gAm.animals: ",k, " = ", v);
			-- end;
			
			-- for k, v in pairs (gAm.animals.cowPool) do
				-- for kk, vv in pairs (v) do
					-- print("cowPool: ", kk, " = ", vv);
				-- end;
			
			-- end;
			print ("--------------pools-------------------");
			print ("cow: ", string.format(#gAm.animals.cowPool));
			print ("sheep: ", string.format(#gAm.animals.sheepPool));
			print ("chicken: ", string.format(#gAm.animals.chickenPool));
			print ("egg: ", string.format(#gAm.animals.eggPool));
			print ("breed: ", string.format(#gAm.animals.breedPool));
			print ("sick: ", string.format(#gAm.animals.sickPool));
			print ("---------------------------------");
			print ("--------------Local vars-------------------");
			print ("isCowBreed: ", isCowBreed);
			
		end;
	end;
	
end;
--------------------------------------------