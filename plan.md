# Plano — Territory Insights SP

## Direção visual
- **Estilos considerados:** civic editorial (0,06), eco-tech claro (0,06), dashboard industrial (0,04).
- **Escolhido:** eco-tech claro.
- **Princípios:** evidência antes de opinião; leitura rápida; transparência; inclusão.
- **Paleta:** azul petróleo para confiança, teal para ação/impacto e âmbar para atenção sem alarmismo.
- **Layout:** cartões empilhados em fluxo vertical mobile, gráficos como evidência e navegação inferior.
- **Assinaturas:** marca circular de insights, chips de severidade e linha de fonte em cada dashboard.
- **Voz:** direta, responsável e sem prometer certeza; CTAs convidam à revisão humana.

## Implementação
Separar modelos, serviço HTTP, estado Provider, telas e widgets. O clima usa Open-Meteo com timeout/fallback; água e serviços usam séries sintéticas identificadas. Alertas são regras determinísticas, sem percentual de confiança inventado. SharedPreferences guarda consentimento e acessibilidade. O formulário valida entradas e registra ocorrências anonimizadas em sessão.
