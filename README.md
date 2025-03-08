# Implementação de Sistemas Especialistas

Este projeto é uma implementação de um sistema especialista em Prolog para avaliar clientes com base em seu consumo atual, consumo médio, consumo estimado e histórico de infrações.

## Estrutura do Projeto

- `src/sistema_especialista.pl`: Contém a lógica principal do sistema, incluindo a interface de menu e a entrada dinâmica de dados.
- `src/regras.pl`: Contém as regras de classificação baseadas nos dados de consumo e histórico.

## Arquivos

### `sistema_especialista.pl`

Este arquivo define a interface do usuário e a lógica para entrada de dados e avaliação.

- Predicados Dinâmicos: Define predicados dinâmicos para armazenar dados temporários.
- Menu Interativo: Implementa um menu interativo para realizar avaliações.
- Entrada Dinâmica de Dados: Permite a entrada dinâmica de dados pelo usuário.
- Execução de Opções: Executa a opção escolhida pelo usuário no menu.
- Verificação de Problema: Consulta para verificar a avaliação do cliente.
- Início do Sistema: Predicado para iniciar o sistema.

### `regras.pl`

Este arquivo contém as regras de classificação diretamente baseadas na tabela fornecida.

- Regras de Avaliação: Define as regras de avaliação com base nos dados de consumo e histórico.

## Como Executar

1. Certifique-se de ter o SWI-Prolog instalado.
2. Carregue o arquivo `sistema_especialista.pl` no SWI-Prolog:
   ```prolog
   ?- [sistema_especialista].
   ```
3. Inicie o sistema:
   ```prolog
   ?- start.
   ```

## Uso

Siga as instruções do menu para avaliar clientes com base nos dados de consumo e histórico de infrações.

## Licença

Este projeto está licenciado sob a [Unlicense](https://unlicense.org).
