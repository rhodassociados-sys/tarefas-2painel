-- Dados iniciais: cliente Pórtico e as 11 pendências levantadas em 01/10/2026.
-- Rode depois do schema.sql. Pode rodar de novo: não duplica nem sobrescreve o que você já editou.

insert into public.clientes (id, nome) values ('portico', 'Pórtico')
on conflict (id) do nothing;

insert into public.tarefas (id, cliente, titulo, acao, responsavel, prazo, prioridade, status, categoria, recorrencia) values
('portico-01', 'portico', 'Black – Justiça',
  'Enviar a documentação que o jurídico solicitou.',
  'Guilherme', null, 'Média', 'A fazer', 'Jurídico', ''),
('portico-02', 'portico', 'Consórcio – Jardim Suíça',
  'Colocar no terreno Jardim Suíça.',
  'Jonathan', null, 'Média', 'A fazer', 'Comercial', ''),
('portico-03', 'portico', 'Pendência no Bradesco',
  'Ir ao banco resolver a pendência para liberar a troca da empresa de nome.',
  'Marco', null, 'Média', 'A fazer', 'Financeiro', ''),
('portico-04', 'portico', 'Sistema novo',
  'Rodar o sistema novo, implementando conforme o cronograma do Louzada.',
  'Louzada', null, 'Média', 'A fazer', 'Tecnologia', ''),
('portico-05', 'portico', 'Michel – Espaço 3',
  'Falar com o Michel para viabilizar o projeto, entender como ele pensou em fazer e sugerir uma reunião de 1 turno para ajudá-lo a viabilizar.',
  'Guilherme', null, 'Média', 'A fazer', 'Comercial', ''),
('portico-06', 'portico', 'Darcione – cobrança e contrato',
  'Conseguimos finalizar a cobrança? Ele assinou o contrato?',
  'Marco', null, 'Média', 'A fazer', 'Financeiro', ''),
('portico-07', 'portico', 'Tiago Silva – proposta',
  'Ele ficou de me chamar para eu fazer a proposta: Corolla Cross + R$ 15.000,00 em 3 x de R$ 5.000,00.',
  'Guilherme', null, 'Média', 'Aguardando', 'Comercial', ''),
('portico-08', 'portico', 'Marketing – troca até o fim do ano',
  'Trocar até o final do ano. Definir quem entra: Bald ou Luander?',
  'Guilherme', '2026-12-31', 'Média', 'A fazer', 'Marketing', ''),
('portico-09', 'portico', 'Frete Uruguai',
  'Cotar com o Ricardo da Scala. Já chamei e estou aguardando o retorno.',
  'Guilherme', null, 'Média', 'Aguardando', 'Operacional', ''),
('portico-10', 'portico', 'Aprovação de pagamentos',
  'Aprovar até as 12h os pagamentos do dia. Alinhar com o Jonathan para ele executar todos os dias.',
  'Jonathan', null, 'Média', 'A fazer', 'Financeiro', 'Diária'),
('portico-11', 'portico', 'Férias e 13º salários',
  'Ele parcelou alguns? Precisamos rever isso. Conversar com o Jonathan.',
  'Jonathan', null, 'Média', 'A fazer', 'Financeiro', '')
on conflict (id) do nothing;
