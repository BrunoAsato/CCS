 module Main
    where
    
 main =
       do {
	   putStrLn "Digite um Car�cter: ";
	   x <- getChar;
	   salte_de_linha;
	   putChar x;
	   putStrLn "\n Fim de Programa \n";
	   }
						       
 salte_de_linha = putStrLn ""

