# ABF Estratificado (Stratified Adaptive Biasing Force)

Este repositório contém um workflow automatizado e organizado para calcular a energia livre (PMF) de fármacos/peptídeos atravessando uma barreira lipídica, utilizando o método ABF estratificado no NAMD 2/3 com o módulo Colvars.

##  Pré-requisitos
Para iniciar este workflow, você deve ter concluído uma simulação prévia de **Steered Molecular Dynamics (SMD)**, e o fármaco deve ter atravessado completamente a bicamada lipídica no tempo simulado, garantindo uma amostragem ao longo de toda a coordenada de reação (eixo Z).

---

##  Estrutura de Diretórios e Arquivos

Para manter o projeto organizado e evitar erros de caminho de arquivo, estruture seu diretório raiz da seguinte maneira:

meu_projeto_abf/
├── step5_input.psf                  # Topologia original (PSF) do sistema
├── step5_input.str                  # Lista de topologias/parâmetros base (CHARMM-GUI)
├── step6.6_equilibration.xsc        # Dimensões da célula (Extended System)
├── step7_production.dcd             # Trajetória do SMD (Puxamento)
├── nona/                            #  Pasta com parâmetros customizados do ligante (topologias do ligante)
│   └── nona.prm 
├── toppar/                          # Pasta com parâmetros de campo de força gerais
│   └── toppar_all36_label_fluorophore.str ...
├── scripts/                         # Todos os scripts auxiliares deste repositório
│   ├── 2_extratifica_pdb.tcl        # Script Tcl/VMD para extrair os frames corretos do DCD
│   ├── run_all_locate.sh            # Script Bash para calcular e dividir as janelas (overlaps)
│   └── 3_setupdirs.sh               # Cria as pastas para cada janela (não alterar)
│   └── setup_win.sh                 # Script Bash para rodar o 3_setupdirs.sh mantendo o número de janelas previamente estabelecido. 
└── win00/                           
    ├── 00_ref/                      # PDBs de referência extraídos para esta janela específica
    │   ├── abf.win00.pdb            # Sistema completo
    │   └── octovespina.win00.pdb    # Apenas o fármaco
    ├── 01/                          # Primeira rodada (Relaxamento + Início ABF)
    ├── toppar/ 
    │   ├── abfConfig.win00.inp      # Configurações do Colvars para a janela 00
    │   └── abf.win00.01.inp         # Input de simulação NAMD (run01)
    └── 02/                          # Segunda rodada (Produção)
    ├── toppar/ 
        ├── abfConfig.win00.inp      # Mesma config do Colvars
        └── abf.win00.02.inp         # Input de simulação NAMD (run02 - lê restart da 01)
    └── merge/ # Pós-processamento e obtenção do PMF 
      ├── merge.inp # Input principal do NAMD para unir as janelas 
      ├── mergeConfig.inp # Configuração Colvars para a junção 
      │ 
      ├── win01.count # Link para ../win01/02/win01.02.count 
      ├── win01.grad # Link para ../win01/02/win01.02.grad 
      ├── win02.count # Link para ../win02/02/win02.02.count 
      ├── win02.grad # Link para ../win02/02/win02.02.grad 
      ├── ... 
      ├── winNN.count # Link para ../winNN/02/winNN.02.count 
      ├── winNN.grad # Link para ../winNN/02/winNN.02.grad 
      │ 
      ├── merge.out # Saída da execução do NAMD do arquivo merge.inp 
      ├── merged.count # Contagens combinadas das janelas 
      ├── merged.grad # Gradientes combinados das janelas 
      └── merged.pmf # Perfil de energia livre resultante (resultado principal)
