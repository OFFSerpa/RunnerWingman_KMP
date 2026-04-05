# RunnerWingmanKMP

RunnerWingmanKMP é um aplicativo de corrida (Runner Tracker) desenvolvido em **Kotlin Multiplatform Mobile (KMP)** e **SwiftUI**. 

Este projeto faz parte do meu **Trabalho de Conclusão de Curso (TCC)** da Universidade Presbiteriana Mackenzie, onde o principal objetivo é realizar um estudo comparativo prático entre uma arquitetura 100% nativa (Swift/iOS) e uma arquitetura Híbrida/Multiplataforma utilizando **KMP (Kotlin Multiplatform)** para compartilhar a regra de negócios.

## 🎯 Objetivo do Projeto (TCC)

O objetivo principal deste repositório é demonstrar a implementação do aplicativo **RunnerWingman** em KMP. O aplicativo nativo Swift já existe, e esta versão KMP foi criada para:
1. Isolar toda a **Regra de Negócios** (Modelos, Cronômetro, Formatações de Tempo, Cálculos de Rota e Interfaces de Repositório) em um módulo compartilhado feito em **Kotlin**.
2. Manter a **Camada de UI** (SwiftUI) e integrações nativas de hardware (como MapKit para GPS e SwiftData para persistência local) em **Swift** nativo puro.
3. Comparar as duas abordagens em termos de:
    - Curva de aprendizado e velocidade de desenvolvimento
    - Reaproveitamento de código
    - Desempenho (CPU, Memória, Tamanho do Bundle)
    - Experiência de ponte/integração entre Kotlin e Swift

## 🏗 Arquitetura do Projeto

O projeto adota uma arquitetura Clean/MVVM dividida em duas grandes áreas graças ao Kotlin Multiplatform:

*   **`shared/` (Módulo Kotlin Multiplatform)**:
    *   Contém toda a lógica de negócios independente de plataforma.
    *   **Core Logic**: Conversores de tempo (`TimeFormatters`), lógicas matemáticas do cronômetro.
    *   **Models**: Entidades de domínio compartilhadas (Pistas, Tempos, Métricas).
    *   **Interfaces**: Protocolos/Interfaces de repositórios que são definidos em Kotlin, mas implementados nativamente em Swift (Inversão de Dependência).
*   **`iosApp/` (Aplicativo iOS Nativo)**:
    *   Desenvolvido em **SwiftUI**.
    *   **UI/UX**: Telas, Componentes, Animações.
    *   **ViewModels (`ObservableObject`)**: Consomem os casos de uso e lógicas do KMP.
    *   **Persistência**: Implementação nativa usando **SwiftData** para salvar as rotas localmente.
    *   **Hardware**: Uso do **CoreLocation** e **MapKit** para rastrear a corrida do usuário em tempo real.

## 🚀 Como rodar o projeto no Xcode

A geração do projeto Xcode é automatizada utilizando a ferramenta **XcodeGen**, garantindo que o framework KMP seja corretamente linkado.

### Pré-requisitos
Para rodar este projeto com sucesso, você precisará de:
*   **macOS** em versão recente.
*   **Xcode 15+** (para suportar o SwiftUI moderno e SwiftData).
*   **Homebrew** instalado no seu Mac.
*   **Java (JDK 17+)** necessário para o build do Gradle/Kotlin Native.

### Passo a Passo

1.  **Instale as dependências via Homebrew**:
    Abra o terminal e instale o `xcodegen`:
    ```bash
    brew install xcodegen
    ```

2.  **Gere o Projeto Xcode**:
    Navegue até a pasta do aplicativo iOS e rode o gerador de projeto:
    ```bash
    cd iosApp
    xcodegen generate
    ```
    Isso vai gerar e configurar magicamente o arquivo `RunnerWingmanKMP.xcodeproj` que estava faltando, incluindo os scripts necessários para compilar o código Kotlin junto com o App.

3.  **Abra o Projeto**:
    Você pode abrir o projeto clicando duas vezes no arquivo `RunnerWingmanKMP.xcodeproj` dentro da pasta `iosApp`, ou rodando no terminal:
    ```bash
    open RunnerWingmanKMP.xcodeproj
    ```

4.  **Rodando o App**:
    *   No Xcode, selecione um simulador recente (ex: iPhone 15 Pro) na barra superior.
    *   Clique no botão **Play (▶️)** ou pressione `Cmd + R`.
    *   *Nota: A primeira compilação demorará um pouco mais pois o Gradle fará o download das dependências do Kotlin Native e construirá o framework `Shared` pela primeira vez.*

## 🛠 Principais Tecnologias Utilizadas

*   **Kotlin Multiplatform (KMP)**
*   **Kotlinx.datetime**
*   **Swift 5.9+ e SwiftUI**
*   **SwiftData** (Persistência no iOS)
*   **MapKit e CoreLocation**
*   **XcodeGen** (Gerenciamento de `.xcodeproj`)
*   **Gradle** (Build System)

---
*Desenvolvido por Vinicius Serpa para o Trabalho de Conclusão de Curso (TCC) - Universidade Presbiteriana Mackenzie*
