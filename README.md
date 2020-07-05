## Analisador Léxico

Aplicação do trabalho de análise léxica da cadeira de Tradutores.

Especificação do trabalho segue no arquivo `Trabalho GA.pdf`.

### Programas necessários

- JDK 8 ou superior.
- Maven (rodado na versão 3.6.3).
- JFlex (rodado na versão 1.8.1).

### Como proceder para instalar

#### Java

Instalar JDK 8 ou superior (pode ser encontrado em: https://www.oracle.com/java/technologies/javase-downloads.html)

Adicione a variável de ambiente do sistema `JAVA_HOME` com a pasta de instalação do JDK (neste caso: `C:\Program Files\Java\jdk1.8.0_211`)

Adicione também na variável `PATH` do sistema a pasta bin do JDK (neste caso: `C:\Program Files\Java\jdk1.8.0_211\bin`)

Feche todos os prompts de comando, caso estejam abertos.

Abra o `cmd` e execute o seguinte comando, para verificar se está configurado corretamente a pasta do JDK:

````
echo %JAVA_HOME%
````

Execute também os comandos `java` e `javac` para verificar se está tudo OK.

#### Maven

Faça a transferência do Maven (pode ser encontrado em https://maven.apache.org/download.cgi)

Neste caso foi usado o arquivo `apache-maven-3.6.3-bin.zip`.

Descompactar o arquivo e copie a pasta `apache-maven-3.6.3` para `C:\Program Files`, por exemplo.

Adicione na variável `PATH` do sistema a pasta do Maven (neste caso: `C:\Program Files\apache-maven-3.6.3\bin`)

Feche todos os prompts de comando, caso estejam abertos.

Abra o `cmd` e execute o seguinte comando, para verificar se está configurado corretamente a pasta do Maven:

````
mvn -e 
````

#### JFlex

Faça a transferência do JFlex (pode ser encontrado em https://maven.apache.org/download.cgi)
            
Descompactar o arquivo e copie a pasta `jflex-1.8.1` para `C:\Program Files`, por exemplo. 

Adicione a variável de ambiente do sistema `JFLEX_HOME` com o local da pasta (neste caso: `C:\Program Files\jflex-1.8.1`)

Adicione também na variável `PATH` do sistema o local da pasta (neste caso: `C:\Program Files\jflex-1.8.1\bin`)

Se tiver algum problema verifique a página https://github.com/jflex-de/jflex, tudo está configurado (nesta versão 1.8.1).

Ddownload https://github.com/jflex-de/jflex/releases

### Como Executar

- Baixe o repositório.
- Para reexecutar/recriar a aplicação _(opcional)_:
    - Abra o `cmd` e estando dentro da pasta `src`, execute os seguintes comandos.
    - Para **recriar** `Lexer.java`:
        ````
        jflex Lexer.flex
        ````
    - Para **recriar** `Lexer.class`:
        ````
        javac Lexer.java
        ````
- Para analisar o arquivo `code.txt` e **executar** o programa `Lexer.class`:
    ````
    java Lexer 
    ````
Feito.