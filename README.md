<p align="center">
  <img src="logo.png" alt="XT Optimizer" width="130">
</p>

<h1 align="center">XT Optimizer</h1>

<p align="center">
  Otimizador de Windows 10/11 com interface gráfica, feito em PowerShell.<br>
  Deteta o teu hardware, sugere as otimizações certas e inclui um plano de energia próprio: o <b>XT Power Plan</b>.
</p>

---

## ⚡ Instalação rápida

1. Clica com o botão direito no menu **Iniciar** e abre o **Terminal (Administrador)** ou o **Windows PowerShell (Administrador)**.
2. Cola este comando e carrega em **Enter**:

```powershell
irm "https://raw.githubusercontent.com/YT-MrXT/XT-Optimizer/refs/heads/main/XT-Optimizer.ps1" | iex
```

3. Espera 2 a 3 segundos. A janela do XT Optimizer abre sozinha.

> ⚠️ **Tem de ser como Administrador.** Sem isso, o app não consegue alterar o sistema.

Enquanto o app trabalha, o PowerShell mostra tudo o que está a fazer (a criar o ponto de restauro, a aplicar cada otimização, erros, etc.). **Não feches essa janela** enquanto usas o XT Optimizer.

---

## 🧭 O que o app faz

| Página | Para que serve |
|---|---|
| **Painel** | Mostra o teu CPU, GPU, RAM e disco, e um monitor em tempo real de CPU e RAM. Tem o botão **Otimização rápida**, que aplica as otimizações recomendadas e ativa o XT Power Plan de uma vez. |
| **Otimizações** | Ajustes de sistema, jogos, rede e armazenamento. Vêm pré-selecionados conforme o teu hardware (por exemplo, a opção de GPU só aparece se tiveres placa dedicada). |
| **Energia XT** | Cria e ativa o **XT Power Plan** (veja abaixo). |
| **Limpeza** | Limpa temporários, cache do Windows Update, miniaturas, dumps de erros e Reciclagem. Mostra quantos MB vais libertar antes de limpares. |
| **Rede** | Limpar cache DNS, DNS Cloudflare, repor Winsock/TCP-IP e testar a latência (ping). |
| **Debloat** | Remove apps pré-instaladas que não usas. Nada vem selecionado, escolhes tu. |

### Como aplicar
1. Escolhe a página.
2. Marca ou desmarca as opções que queres.
3. Carrega no botão de baixo (por exemplo, **Aplicar selecionadas**).
4. Vê o progresso no log da janela e no PowerShell.
5. **Reinicia o PC** no fim para que tudo faça efeito.

---

## 🔋 XT Power Plan

Um plano de energia criado a partir do *Ultimate Performance* e afinado para latência mínima e desempenho constante.

**Quando estás ligado à corrente:**
- CPU sempre a 100%, sem descer de frequência
- Core parking desativado (todos os núcleos ativos)
- PCIe Link State Power Management desligado
- USB selective suspend desligado
- Disco e ecrã não desligam por inatividade
- Arrefecimento ativo (a ventoinha sobe antes de o CPU reduzir o clock)

**Em portátil, na bateria:** o plano usa um perfil económico, para não gastar bateria nem aquecer o portátil.

Mais desempenho significa mais consumo e mais calor. Usa o plano com boa ventilação.

---

## 🛡️ Segurança e como reverter

O XT Optimizer foi feito para ser seguro e reversível:

- **Ponto de restauro:** é criado antes de aplicar alterações. O Windows só permite 1 a cada 24 horas por defeito.
- **Backup do registo:** as chaves que o app altera são exportadas para `C:\ProgramData\XTOptimizer\backup-<data>`. Para repor, faz duplo clique nos ficheiros `.reg` e confirma.
- **Logs:** tudo fica registado em `C:\ProgramData\XTOptimizer\xt.log`.
- **Plano de energia:** na página **Energia XT**, o botão **Voltar ao Equilibrado** repõe o plano normal do Windows.
- **Apps removidas no Debloat:** podem ser reinstaladas pela Microsoft Store.
- **Código aberto:** o script é um único ficheiro de texto. Podes abri-lo e ler tudo o que faz antes de o correr.

Para repor o sistema por completo, abre o **Menu Iniciar → "Criar um ponto de restauro" → Restauro do Sistema**.

---

## 💻 Requisitos

- Windows 10 ou Windows 11
- Windows PowerShell 5.1 (já vem instalado no Windows)
- Privilégios de Administrador
- Ligação à internet (só para descarregar o script)

---

## ❓ Perguntas frequentes

**O antivírus alertou ou bloqueou o script. É perigoso?**
Alguns antivírus desconfiam de scripts que alteram o sistema ou que são executados com `irm | iex`. O código está todo visível neste repositório e podes ler antes de correr.

**Aparece "não é possível carregar o ficheiro porque a execução de scripts está desativada".**
Isso acontece só ao correr o `.ps1` descarregado. Com o comando `irm | iex` não acontece. Se quiseres correr localmente, usa:
```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\XT-Optimizer.ps1
```

**Os acentos aparecem estranhos ao correr o ficheiro localmente.**
Corre assim:
```powershell
Get-Content .\XT-Optimizer.ps1 -Raw -Encoding UTF8 | iex
```

**O ponto de restauro demora muito.**
É normal, o Windows pode demorar até 1 minuto. O app continua a responder e mostra o estado no PowerShell.

**Funciona em Windows 7/8 ou em Linux/macOS?**
Não. É só para Windows 10 e 11.

**As otimizações dão mais FPS garantidos?**
Não há garantias. O ganho depende do teu PC. Os maiores ganhos costumam vir de limpar o arranque, usar um bom plano de energia e manter os drivers atualizados.

---

## ⚠️ Aviso

Este projeto altera definições do Windows. Foi feito com cuidado e inclui backups, mas **o uso é por tua conta e risco**. Lê as descrições antes de aplicar e, se tiveres dúvidas, deixa as opções marcadas como *Moderado* desativadas. O autor não se responsabiliza por problemas causados pelo uso do programa.

---

<p align="center">Feito por <b>YT-MrXT</b> · XT Optimizer</p>
