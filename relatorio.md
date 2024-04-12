## Relatório: Projeto de Chat P2P
- 
### Introdução
O projeto consiste no desenvolvimento de um sistema de mensagens distribuído, que permite a comunicação entre usuários de forma eficiente e confiável. O sistema é composto por um servidor implementado em Python e um cliente desenvolvido em Flutter. O servidor utiliza o módulo `http.server` do Python para lidar com requisições HTTP, enquanto o cliente Flutter utiliza a biblioteca `http` para se comunicar com o servidor.
- 
### Funcionamento do Servidor (server.py)
O servidor foi implementado utilizando a biblioteca padrão `http.server` do Python. Ele é responsável por receber as mensagens dos clientes, armazená-las e fornecê-las quando solicitado. O servidor possui três métodos principais:

1. **do_GET:** Este método é chamado quando o servidor recebe uma requisição HTTP GET. Ele retorna as mensagens armazenadas em formato JSON para o cliente.
   
2. **do_POST:** Quando o servidor recebe uma requisição HTTP POST, este método é chamado. Ele é responsável por extrair a mensagem do corpo da requisição, armazená-la e retornar uma confirmação ao cliente.

3. **do_OPTIONS:** Este método trata as requisições OPTIONS, que são usadas para pré-voar requisições cross-origin (CORS). Ele define os cabeçalhos necessários para permitir requisições de origens diferentes.

### Funcionamento do Cliente (client Flutter)
O cliente foi desenvolvido em Flutter, uma estrutura de desenvolvimento de aplicativos multiplataforma. Ele se comunica com o servidor utilizando requisições HTTP GET e POST. O cliente possui as seguintes funcionalidades:

1. **Exibição de Mensagens:** O cliente exibe todas as mensagens recebidas do servidor em uma lista na interface do usuário.

2. **Envio de Mensagens:** Os usuários podem digitar mensagens em um campo de texto e enviá-las ao servidor pressionando um botão.

3. **Atualização Automática:** O cliente busca periodicamente novas mensagens do servidor para garantir que a lista de mensagens esteja sempre atualizada.

4. **Tratamento de Mensagens Vazias:** Caso não haja mensagens disponíveis no servidor, o cliente exibe a mensagem "Empty" na lista de mensagens para informar o usuário.

## ---------------------------------------------------------------------------------------------------------------------------
**Diferenças entre Modelos Síncronos e Assíncronos**

**Modelo Síncrono**:

- **Vantagens**:
  - Comunicação em tempo real: As mensagens são enviadas e recebidas imediatamente, o que é adequado para aplicativos que exigem respostas rápidas.
  - Simplicidade de implementação: O modelo síncrono é mais fácil de entender e implementar, pois as operações são executadas em uma ordem previsível.

- **Desvantagens**:
  - Possibilidade de bloqueio: Se um dos participantes na comunicação estiver ocupado ou indisponível, isso pode resultar em bloqueio, impedindo que outras operações sejam executadas até que a comunicação seja concluída.
  - Menor escalabilidade: O modelo síncrono pode ter dificuldades em lidar com um grande número de clientes simultâneos devido à espera por respostas imediatas.

**Modelo Assíncrono**:

- **Vantagens**:
  - Maior escalabilidade: O modelo assíncrono é mais adequado para lidar com um grande número de clientes simultâneos, pois não bloqueia a execução do programa principal enquanto espera por respostas.
  - Tolerância a falhas: Como as operações assíncronas não bloqueiam o programa, é mais fácil lidar com falhas e indisponibilidades dos participantes na comunicação.

- **Desvantagens**:
  - Complexidade de implementação: O modelo assíncrono pode ser mais complexo de implementar e entender, pois envolve o gerenciamento de operações em diferentes tempos e ordens.
  - Menor previsibilidade: Como as operações assíncronas não são executadas em uma ordem previsível, pode ser mais difícil garantir a consistência e integridade dos dados.
 
## ---------------------------------------------------------------------------------------------------------------------------

**Impacto no Desempenho e Eficiência do Sistema de Mensagens**

- **Cenário 1: Comunicação entre dois usuários em tempo real**:
  - Modelo Síncrono: Seria mais eficiente, pois as mensagens são enviadas e recebidas imediatamente, proporcionando uma comunicação em tempo real sem atrasos perceptíveis.
  - Modelo Assíncrono: Pode introduzir um pequeno atraso devido à natureza assíncrona das operações, mas ainda assim seria eficaz para a comunicação entre dois usuários.

- **Cenário 2: Comunicação em grupo com múltiplos participantes**:
  - Modelo Síncrono: Pode enfrentar problemas de escalabilidade, especialmente se muitos participantes estiverem enviando mensagens ao mesmo tempo, resultando em congestionamento e possíveis bloqueios.
  - Modelo Assíncrono: Seria mais adequado devido à sua maior escalabilidade, permitindo que um grande número de participantes envie e receba mensagens simultaneamente sem bloquear a comunicação.
## ---------------------------------------------------------------------------------------------------------------------------

### Conclusão
O projeto de Chat P2P implementa um sistema de mensagens distribuído usando Python para o servidor e Flutter para o cliente. Ele demonstra a comunicação entre cliente e servidor por meio de requisições HTTP, permitindo que os usuários troquem mensagens de forma síncrona. Este projeto pode ser expandido para incluir recursos adicionais, como autenticação de usuários, criptografia de mensagens e suporte a múltiplos usuários.
