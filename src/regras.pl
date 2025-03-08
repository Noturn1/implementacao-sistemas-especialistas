% REGRAS DE CLASSIFICAÇÃO:

% 1) Situação normal: Consumo_atual está dentro de ±10% do Consumo_medio
consumo_normal :-
    consumo_atual(Consumo),
    compute_consumo_medio(Medio),
    Lower is Medio * 0.9,
    Upper is Medio * 1.1,
    Consumo >= Lower, Consumo =< Upper.

% 2) Possível perda técnica: se (Consumo_atual / Consumo_estimado) > 1.035
possivel_perda_tecnica :-
    consumo_atual(Consumo),
    compute_consumo_estimado(Estimado),
    crescimento_vegetativo(Crescimento),
    Ratio is Consumo / Estimado,
    Ratio > Crescimento.

% Sub-regras para perda técnica:

% a) Perda técnica por subtensão: se a tensão for precária ou crítica (inferior)
%    e a corrente medida > 1.2 * Corrente_media_atual
perda_tecnica_subtensao :-
    possivel_perda_tecnica,
    tensao_medida(V),
    ( tensao_status(V, precaria_inferior) ; tensao_status(V, critica_inferior) ),
    corrente_medida(CM),
    compute_corrente_media_atual(CM_media),
    CM > 1.2 * CM_media.

% b) Perda técnica por sobretensão: se a tensão for precária ou crítica (superior)
%    e a corrente medida < 0.8 * Corrente_media_atual
perda_tecnica_sobretensao :-
    possivel_perda_tecnica,
    tensao_medida(V),
    ( tensao_status(V, precaria_superior) ; tensao_status(V, critica_superior) ),
    corrente_medida(CM),
    compute_corrente_media_atual(CM_media),
    CM < 0.8 * CM_media.

% c) Perda técnica por efeito Joule: se a tensão for adequada e a corrente medida > 1.2 * Corrente_media_atual
perda_tecnica_joule :-
    possivel_perda_tecnica,
    tensao_medida(V),
    tensao_status(V, adequada),
    corrente_medida(CM),
    compute_corrente_media_atual(CM_media),
    CM > 1.2 * CM_media.

% 3) Possível perda não-técnica: se o consumo estiver dentro de ±10% do consumo_medio
possivel_perda_nao_tecnica :-
    consumo_normal.

% Sub-regras para perda não-técnica:

% a) Possível erro de medição de corrente: se a corrente medida desviar ±20% da corrente média
erro_medicao_corrente :-
    possivel_perda_nao_tecnica,
    corrente_medida(CM),
    compute_corrente_media_atual(CM_media),
    Lower is CM_media * 0.8,
    Upper is CM_media * 1.2,
    (CM < Lower ; CM > Upper).

% b) Possível erro de medição de tensão: se a tensão medida for classificada como crítica
erro_medicao_tensao :-
    possivel_perda_nao_tecnica,
    tensao_medida(V),
    tensao_status(V, critica_inferior) ; tensao_status(V, critica_superior).

% c) Possível desvio de energia: se Consumo_atual for inferior a 20% do Consumo_medio
possivel_desvio_energia :-
    possivel_perda_nao_tecnica,
    consumo_atual(Consumo),
    compute_consumo_medio(Medio),
    Consumo < 0.2 * Medio.

% d) Possível fraude na medição: se a tensão estiver adequada e a corrente dentro de ±20%
%    mas o consumo for inferior a 20% do consumo_medio
possivel_fraude_medicao :-
    possivel_perda_nao_tecnica,
    tensao_medida(V),
    tensao_status(V, adequada),
    corrente_medida(CM),
    compute_corrente_media_atual(CM_media),
    Lower is CM_media * 0.8,
    Upper is CM_media * 1.2,
    CM >= Lower, CM =< Upper,
    consumo_atual(Consumo),
    compute_consumo_medio(Medio),
    Consumo < 0.2 * Medio.