# TALKYAPP CHAT

É um chat app desenvolvido em Flutter que permite conexão em tempo real através da conexão do back-end com o front-end via socket.io. O aplicativo possui num total de 4 telas: acesso, cadastro, lista de contatos e chat com contato.
A tela de acesso permite o usuário entrar na aplicação, e quando os dados estão corretos, é gerado um token pelo back-end e armazenado pelo shared_preferences dentro do celular. A lista de contatos, é ampla e puxa do back-end todos os usuários disponíveis, exceto o próprio usuário da aplicação, e ao clicar, num perfil, é aberto o chat, e automaticamente é gerado no back-end um ID para aquela "sala de bate-papo".

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
