# Considerações de segurança no gRPC para ASP.NET Core

**Por James Newton-King**

Este artigo fornece informações sobre como proteger gRPC com .NET.

## Segurança do transporte

As mensagens gRPC são enviadas e recebidas usando HTTP/2.

Recomendações:

- O TLS (Transport Layer Security) deve ser usado para proteger mensagens em aplicativos gRPC de produção.
- Os serviços gRPC só devem escutar e responder via portas seguras.

O TLS está configurado em Kestrel. Para obter mais informações sobre como configurar pontos de extremidade Kestrel, confira [Configuração do ponto de extremidade Kestrel](#).

É possível combinar um proxy de terminação TLS com o TLS. Os benefícios de usar a terminação TLS devem ser levados em consideração quanto aos riscos de segurança de enviar solicitações HTTP não confiáveis entre aplicativos na rede privada.

## Exceptions

Geralmente, as mensagens de exceção são consideradas dados confidenciais e que não devem ser revelados a um cliente.

Por padrão, o gRPC não envia ao cliente os detalhes de uma exceção gerada por um serviço gRPC. Em vez disso, o cliente recebe uma mensagem genérica indicando que ocorreu um erro.

A entrega de mensagens de exceção ao cliente pode ser sobrescrita (por exemplo, em desenvolvimento ou teste) com `EnableDetailedErrors`.

> **Importante:** As mensagens de exceção não devem ser expostas ao cliente em aplicativos de produção.

## Limites de tamanho de mensagem

As mensagens de entrada para clientes e serviços gRPC são carregadas na memória. Os limites de tamanho da mensagem são um mecanismo para ajudar a impedir que o gRPC consuma recursos excessivos.

O gRPC usa os limites de tamanho por mensagem para gerenciar mensagens de entrada e saída.

Por padrão, o gRPC limita as mensagens de entrada a **4 MB**. Não há limite para mensagens de saída.

No servidor, os limites de mensagem do gRPC podem ser configurados para todos os serviços em um aplicativo com `AddGrpc`:

### C#

```csharp
public void ConfigureServices(IServiceCollection services)
{
    services.AddGrpc(options =>
    {
        options.MaxReceiveMessageSize = 1 * 1024 * 1024; // 1 MB
        options.MaxSendMessageSize = 1 * 1024 * 1024; // 1 MB
    });
}