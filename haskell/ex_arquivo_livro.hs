module Cadastro where
import IO
import System
import Numeric
import Char (toUpper)
import Hugs.Prelude

-- Defini��es

type Cadastro  = (String,Int,Float,Char)
type Cadastros = [Cadastro]

nome   :: Cadastro -> String
idade  :: Cadastro -> Int
altura :: Cadastro -> Float
sexo   :: Cadastro -> Char

nome   (a,_,_,_) = a
idade  (a,b,c,d) = b
altura (a,b,c,d) = c
sexo   (a,b,c,d) = d


-- Fun��o Principal --
{-- Antes do menu de op��es ser exibido, deve ser realizada uma checagem 
a fim de verificar se o arquivo � vazio ou n�o. Se o arquivo est� vazio 
� necess�rio que a inclus�o de uma lista vazia ([]) seja realizada para 
que as demais opera��es possam ser realizadas com sucesso.
--}

-- 

-- Menu de Op��es --
menu::IO()
menu = 
	do
		putStrLn " "
		putStrLn " ___________________________________________"
		putStrLn "|                                           |"
		putStrLn "|           CADASTRO DE PESSOAS             |" 
		putStrLn "|                                           |"
		putStrLn "|   a -  Insere cadastro                    |"
		putStrLn "|   b -  Imprime cadastro                   |"
		putStrLn "|   c -  Busca por nomes                    |"
		putStrLn "|   d -  Soma das idades                    |"
		putStrLn "|   e -  M�dia das alturas                  |"
		putStrLn "|   f -  Busca por sexo                     |"
		putStrLn "|   g -  Excluir um cadastro                |"
		putStrLn "|   h -  Excluir todos cadastros            |"
		putStrLn "|   i -  Sair do Sistema                    |"
		putStrLn "|___________________________________________|"                  
		putStr "Digite uma das op��es:"
		le_opcao

le_opcao :: IO ()
le_opcao=
	   do 	{  
			-- op��o do bloco do.... s� aceita tipos
			-- mon�dicos .... onde I/O � uma sub-classe
			opcao <- getChar;
			putStr "\n";
			f_menu (toUpper opcao); -- veja o tipo de f_menu
		}
f_menu :: Char -> IO()
f_menu i =
	  do
		case i of
			'A' -> insereCadastro
			'B' -> imprimeCadastros
			'C' -> buscaNomes
			'D' -> somaIdades
			'E' -> alturaMedia
			'F' -> buscaSexo
			'G' -> excluirCadastro
			'H' -> excluirTodos
			otherwise -> sair i
		putStrLn "Operacao Concluida"
		if not(i=='I') then menu else putStr ""


--insereCadastro :: IO ()
insereCadastro=
		do 
		        pt_arq <- abreArquivo "dados.txt" WriteMode
		       	putStrLn "Nome: "
			nome <- getLine
			putStrLn "Idade: "
			idade <- getLine
			putStrLn "Altura: " 
			altura <- getLine
			putStrLn "M -Masculino |F -Feminino"
			putStrLn "Sexo: "
			sexo <- getChar
-- Marcio: o erro � sempre  aqui....

-- procedimento:
{- 1. abrir arquivo... se n�o existe ... crie... devolvendo o ponteiro./..
   2. ler conteudo no modo Append ou no modo que interessa....
   3. retornar e manipular (atualizar,inserir,ordenar, excluir,...) a lista lida do arquivo faz tudo o que se deseja com lista...
   4. salvar a lista  nova  no arquivo
   5. fechar arquivo
Isto tem que fazer para cada uma das opcoes acima... haja visto que a lista n�o estah 
sendo passada como argumento nas opcoes...
-}
			-- cadastros <- readFile "dados.txt"
			 
			-- putStrLn (show cadastro)
		         -- escreveCadastros (cadastro:(read cadastros))
			hPutStr pt_arq (meu_converte nome idade altura [(toUpper sexo)])
			putStrLn "\nAtualizando cadastros...."
			pausa

converte :: String -> String -> String -> String -> IO Cadastro
converte nome idade altura sexo = return (read ("(\""++nome++"\","++idade++","++altura++",'"++sexo++"')"))

-- conserte o pgm para algo simples como ................................... tudo simples e obvio...
meu_converte :: String -> String -> String -> String -> String
meu_converte nome idade altura sexo = nome ++ "#" ++ idade ++ "#" ++ altura ++"#"++ sexo ++ "\n"
meu_converte nome idade altura sexo = "um erro \n"



-- MARCIO OLHE os nomes abaixo..... veja se isto nao dah confusao...
imprimeCadastros :: IO ()    
imprimeCadastros = do 	cadastros <- leCadastros
			imprime cadastros
			putStrLn "Atualizando cadastros...."
			
imprime [] = putStr ""
imprime (x:xs) = do 
			imprimeCadastro x
			imprime xs


		
imprimeCadastro :: Cadastro -> IO()
imprimeCadastro x = putStrLn ((nome x)++"\t"++(show (idade x))++"\t"++(show (altura x))++"\t"++[(sexo x)])
	
			
			
			
buscaNomes = do 
		cadastros <- leCadastros
		putStrLn "Digite o nome desejado: "
		nome <- getLine
		putStrLn "Nome\tIdade\tAltura\tSexo\n\n"
		buscaPorNome cadastros nome

somaIdades :: IO ()
somaIdades = do 
		cadastros <- leCadastros
		putStrLn (show (soma idade cadastros))
			
alturaMedia :: IO ()
alturaMedia = do 
		cadastros <- leCadastros
		putStrLn (show (mediaAltura cadastros))
			
buscaSexo :: IO ()
buscaSexo = do 
		do 
		cadastros <- leCadastros
		putStrLn "Digite o sexo desejado (M | F): "
		sexo <- getChar
		if ( (toUpper sexo) /= 'M' && (toUpper sexo) /= 'F')
			then 
				do
				  putStrLn "Sexo Invalido"
				  buscaSexo
			else
				do
				  putStrLn "Nome\tIdade\tAltura\tSexo\n\n"
				  buscaPorSexo cadastros (toUpper sexo)	
			
excluirCadastro :: IO ()
excluirCadastro = do 
			putStrLn ""
			
			
excluirTodos :: IO ()
excluirTodos = 
		do 	
			putStrLn "Tem certeza que deseja apagar todos os dados do sistema?(s/n)"
			resp <- getChar
			if not((toUpper resp)=='S') then putStrLn "" else 
				  do 	arquivo <-openFile "dados.txt" WriteMode
					hPutStr arquivo ""
					putStrLn "Apagando dados...."       

sair :: Char -> IO ()
sair i 	|i=='I' 	= putStrLn "Saindo do sistema...."
	|otherwise 	= putStrLn "Operacao Invalida..."
	
-- Fun��es Auxiliares




{- Na presente fun��o, leitura dos cadastros, a fun��o 'read' se faz 
necess�ria para a convers�o do tipo de conte�do (de String para o 
desejado)
-}
leCadastros :: IO Cadastros
leCadastros = do {
			-- Estah errado este tipo...
			-- O ARQURIVO NAO FOI ABERTO.....
			 pt_arq <- abreArquivo "dados.txt" WriteMode; 
			
			--conteudo <- readFile "dados.txt" 
			-- E NAO FOI FECHADO....
			 return (read conteudo)



-- escreveCadastros :: Cadastros -> IO()
escreveCadastros cadastros =   do
                          { -- algo bem simples como .... 
			  pt_arq <- abreArquivo "dados.txt" WriteMode;
			  adicionaCadastros cadastros pt_arq;
			  fechaArquivo pt_arq;
			  putStr "salvo com sucesso";
			  pausa;
			  }
{- marcio .... aqui � abrir arquivo ... escreve e fechar... s� isto....-}				    {-handle <- openFile "dados.txt" WriteMode
				   hPutStr handle "["
				    hClose handle
				    handlea <- openFile "dados.txt" AppendMode
				    adicionaCadastros cadastros handlea
				    hClose handlea
-}
                        

adicionaCadastros [] handle = hPutStr handle "]"
adicionaCadastros (x:[]) handle = hPutStr handle ((show x)++"]")
adicionaCadastros (x:xs) handle = do hPutStr handle ((show x) ++ ",")
				     adicionaCadastros xs handle



buscaPorNome :: Cadastros -> [Char] -> IO ()   
buscaPorNome [] nm      = putStrLn "Cadastro nao encontrado..."
buscaPorNome (x:xs) nm  | (nome x) == nm  =  putStrLn ((nome x)++"\t"++(show (idade x))++"\t"++(show (altura x))++"\t"++[(sexo x)])
			| otherwise       = buscaPorNome xs nm

buscaPorSexo :: Cadastros -> Char -> IO ()   
buscaPorSexo [] sx      = putStrLn "Fim da Pesquisa..."
buscaPorSexo (x:xs) sx  | (sexo x) == sx  = do imprimeCadastro x
					       buscaPorSexo xs sx	
			
			| otherwise       = buscaPorSexo xs sx

soma :: Num a => (Cadastro -> a) -> Cadastros -> a
soma f []     = 0
soma f (x:xs) = (f x) + (soma f xs)

mediaAltura :: Cadastros -> Float
mediaAltura x =  (soma altura x)/( fromInt (length x) )

-- fromInt -> trasnforma de Int para Float

-- FUNCOES AUXILIARES DE ARQUIVOS
abreArquivo :: String -> IOMode -> IO Handle
abreArquivo arquivo modo =
       catch (openFile arquivo modo)
             (\_ -> do {
	               putStrLn ("Impossivel abrir "++ arquivo ++ " permiss�o negada ~ talvez ");
		       putStrLn "Ser� aberto com um novo nome default: saida.txt e limpo" ;
                       abreArquivo "saida.txt" WriteMode -- ou openFile "saida.txt" WriteMode diretamente
                       }      
	     )
		      

-- fechaArquivo :: IO Handle -> IO Handle
fechaArquivo handle_arq = hClose handle_arq
{-
       catch (hClose handle_arq)
             (\_ -> do {
	               putStrLn ("Impossivel fechar o arquivo ~ talvez ");
		       pausa;
                       }      
	     )
	     
-}
{-
        modo: AppendMode, WriteMode, ReadMode
-} 
		       

pausa = do{
	  putStrLn "\n\t\t<<Aperte alguma tecla>>";
	  getChar;
        }
		       

