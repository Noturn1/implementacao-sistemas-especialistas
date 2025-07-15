:- consult('regras.pl').
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sistema Especialista para Análise de Perdas em UC %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Declaração de predicados dinâmicos para armazenar os dados de entrada
:- dynamic(consumo_atual/1).
:- dynamic(tensao_medida/1).
:- dynamic(corrente_medida/1).
:- dynamic(consumo_hist/2).

% Dados internos fixos (fatos do sistema)
crescimento_vegetativo(1.035).    % 3,5% ao ano
tensao_atendimento(127).         % Tensão nominal de atendimento (V) para baixa tensão
fator_potencia(0.92).            % Fator de potência normatizado

% Classificação da tensão medida (para 127V)
% Faixas:
%   Adequada: 117 ≤ V ≤ 133
%   Precária: 110 ≤ V < 117 (inferior) ou 133 < V ≤ 135 (superior)
%   Crítica: V < 110 (inferior) ou V > 135 (superior)

tensao_status(V, adequada) :- V >= 117, V =< 133.
tensao_status(V, precaria_inferior) :- V >= 110, V < 117.
tensao_status(V, precaria_superior) :- V > 133, V =< 135.
tensao_status(V, critica_inferior) :- V < 110.
tensao_status(V, critica_superior) :- V > 135.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Predicado de Avaliação
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

avaliar :-
     possivel_perda_tecnica ->
         ( perda_tecnica_subtensao ->
               write('Diagnóstico: Perda técnica por subtensao na UC (problema de transformacao ou quedas de tensao na rede).'), nl
         ; perda_tecnica_sobretensao ->
               write('Diagnóstico: Perda técnica por sobretensao na UC (problema de transformacao ou sobretensao na rede).'), nl
         ; perda_tecnica_joule ->
               write('Diagnóstico: Perda tecnica por efeito Joule (sobrecarga).'), nl
         ; write('Diagnostico: Possivel perda tecnica, mas sem indicacao especifica.'), nl
         )
    ; possivel_perda_nao_tecnica ->
         ( 
          possivel_desvio_energia ->
             write('Diagnostico: Perda não técnica = Possivel desvio de energia (by-pass do medidor).'), nl
         ; erro_medicao_tensao ->
             write('Diagnostico: Perda não técnica = Possivel erro de medicao de tensao.'), nl
         ; erro_medicao_corrente ->
               write('Diagnostico: Perda não técnica = Possivel erro de medicao de corrente.'), nl
         ; write('Diagnostico: Consumo normal sem indicios de perda nao-tecnica.'), nl
         )
    ; write('Situacao regular (de acordo com as regras definidas.)'), nl.
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Interface Interativa
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

menu :-
    write('--- Sistema Especialista de Perdas ---'), nl,
    write('Digite o consumo atual da UC (kWh): '), read(ConsumoAtual),
    retractall(consumo_atual(_)), assertz(consumo_atual(ConsumoAtual)),
    
    write('Digite a tensao medida (V): '), read(Tensao),
    retractall(tensao_medida(_)), assertz(tensao_medida(Tensao)),
    
    write('Digite a corrente medida (A): '), read(Corrente),
    retractall(corrente_medida(_)), assertz(corrente_medida(Corrente)),
    
    write('Digite o consumo do mesmo mes de dois anos atras (kWh): '), read(ConsumoAno2),
    write('Digite o consumo do mesmo mes do ano anterior (kWh): '), read(ConsumoAno1),
    retractall(consumo_hist(_,_)), assertz(consumo_hist(ConsumoAno2, ConsumoAno1)),
    
    nl,
    compute_consumo_medio(Medio),
    compute_consumo_estimado(Estimado),
    compute_corrente_media_atual(CorrenteMedia),

    write('Consumo medio calculado: '), write(Medio), nl,
    write('Consumo estimado calculado: '), write(Estimado), nl,
    write('Corrente media atual calculada: '), write(CorrenteMedia), nl,
    nl,
    avaliar,
    nl,
    write('Fim da avaliacao.'), nl,
    menu_opcao.

menu_opcao :-
    nl, write('Deseja realizar nova avaliacao? (s/n): '), read(Resp),
    (Resp = s -> menu ; write('Encerrando o sistema.'), nl).

start :-
    menu,
        
