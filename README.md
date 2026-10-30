# Casa de Memórias — Álbum da família

Aplicação web responsiva, sem etapa de build, pronta para colocar em um repositório GitHub e publicar pelo GitHub Pages. Inclui login por código enviado ao e-mail (OTP), Google OAuth, galeria, seleção múltipla de fotos, upload para armazenamento privado e download individual.

> **A privacidade depende de concluir a configuração do Supabase.** A prévia demonstrativa mostra fotos ilustrativas sem autenticação. Antes de configurar o serviço, upload e login não funcionam e nenhuma foto é armazenada. Não use a prévia para guardar imagens privadas.

## Publicar no GitHub Pages

1. Crie um repositório no GitHub e carregue `index.html`, `schema.sql` e este guia na raiz.
2. Abra **Settings → Pages**, selecione a publicação a partir da branch `main` e pasta `/ (root)` e salve.
3. A URL gerada pelo GitHub Pages será a URL do site (por exemplo, `https://SEU-USUARIO.github.io/SEU-REPOSITORIO/`).
4. Sites GitHub Pages são públicos. O app protege a galeria e o acesso às imagens através da autenticação e das políticas de acesso do Supabase; mantenha o bucket privado.

## Configurar Supabase (necessário para acesso e armazenamento reais)

1. Crie um projeto no Supabase e acesse **SQL Editor**. Copie e execute todo o conteúdo de `schema.sql`.
2. Em `index.html`, substitua os valores vazios `SUPABASE_URL` e `SUPABASE_ANON_KEY` pela URL do projeto e pela chave pública **anon/publishable**. Essas duas configurações são feitas no início do bloco `<script type="module">`.
3. **Nunca** inclua a chave `service_role` no site. A chave pública é destinada ao frontend e o acesso é restringido por autenticação, RLS e políticas do Storage.
4. Em **Authentication → URL Configuration**, informe a URL do site como `Site URL` e adicione a URL exata do GitHub Pages em `Redirect URLs`.
5. Em **Authentication → Providers → Email**, ative e-mail/OTP. Configure um provedor de envio de e-mail nas configurações SMTP do Supabase para personalizar entrega e capacidade. Edite o modelo de e-mail para incluir o token `{{ .Token }}` caso queira código numérico; o fluxo do site verifica o código OTP.
6. Para Google: configure um OAuth Client no Google Cloud Console, adicione a URL de callback do Supabase indicada no painel de Google Provider e cadastre Client ID e Client Secret no Supabase. Ative o provider Google e confirme as URLs permitidas.
7. O script SQL cria acesso **por usuário**: cada conta só vê e baixa suas próprias imagens. Para compartilhar o álbum entre familiares, use uma única conta familiar ou altere conscientemente as políticas RLS e regras de Storage para uma lista/grupo compartilhado; não remova RLS nem torne o bucket público.

## Observações

- Para limitar o álbum apenas a convidados, desative o cadastro público em **Authentication → Settings** depois de convidar os membros. Contas Google e e-mail devem ter as permissões apropriadas.
- E-mail, domínio OAuth e limites de upload/envio dependem da configuração e dos planos de terceiros.
- O app demonstra uma galeria ilustrativa sem serviço conectado; fotos reais só são transferidas depois da configuração Supabase e login.
- HTML e conexão Supabase são configurados localmente antes de enviar/atualizar o conteúdo no GitHub. O aplicativo não publica arquivos no GitHub automaticamente.
