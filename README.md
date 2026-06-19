<h1 align="center">Compriceon</h1>
<p align="center"><strong>Unit price comparator — 100% offline, no ads</strong></p>
<p align="center">
  <img src="https://img.shields.io/badge/version-1.0.0-blue" alt="version" />
  <img src="https://img.shields.io/badge/platforms-Android%20%7C%20iOS-informational" alt="platforms" />
  <img src="https://img.shields.io/badge/100%25%20offline-no%20cloud-success" alt="offline" />
</p>

<p align="center">
  <a href="#english">English</a> &nbsp;·&nbsp;
  <a href="#português">Português</a>
</p>

---

## English

### What is Compriceon?

Compriceon calculates and compares the **unit price** of two products to show which one offers the best value — something the human eye often gets wrong at the supermarket.

A product with a higher total price may be cheaper per gram, milliliter, or unit. Compriceon does the math in seconds.

### How to use

1. Enter the **price and quantity** of Product A
2. Enter the **price and quantity** of Product B
3. Tap **Compare**
4. The app highlights the better product and shows the savings percentage

> Use the same unit of measure for both products (e.g. both in grams, or both in ml).

### How the calculation works

```
unit price = total price ÷ quantity

savings (%) = (loser_unit_price - winner_unit_price)
              ÷ loser_unit_price × 100
```

**Example:**
| Product | Price | Quantity | Price/unit |
|---------|-------|----------|------------|
| A       | R$ 7.50 | 350 g  | R$ 0.0214/g |
| B       | R$ 11.00 | 700 g | R$ 0.0157/g |

→ Product B is **26.7% cheaper per unit**, even though it costs more in total.

### Features

- Instant unit price comparison
- Animated highlight of the winning product
- Exact savings percentage
- Languages: **English (US)** and **Português (Brasil)**
- Automatic light and dark theme (follows system)
- 100% offline — no data is sent to any server
- No ads, no sign-up required

### Platforms

| Platform | Status |
|----------|--------|
| Android  | ✅ Supported |
| iOS      | ✅ Supported |

### Tech stack

| Component        | Technology                        |
|------------------|-----------------------------------|
| UI framework     | Flutter (Material 3)              |
| State / i18n     | InheritedWidget + S class         |
| Animations       | AnimationController + Interval curves |
| External deps    | None (fully standalone)           |

### Build

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS (requires Mac with Xcode)
flutter build ios --release
```

### Support the project

Compriceon is free and ad-free. If it helped you save money, consider supporting its development.

**PIX:** `3a2b8066-7987-4e10-b0da-8ccc4c9da565`

---

## Português

### O que é o Compriceon?

O Compriceon calcula e compara o **preço por unidade** de dois produtos para mostrar qual oferece o melhor custo-benefício — algo que o olho humano frequentemente erra no supermercado.

Um produto com preço maior pode ser mais barato por grama, mililitro ou unidade. O Compriceon faz essa conta em segundos.

### Como usar

1. Insira o **preço e a quantidade** do Produto A
2. Insira o **preço e a quantidade** do Produto B
3. Toque em **Comparar**
4. O app destaca o produto mais vantajoso e mostra o percentual de economia

> Use a mesma unidade de medida para os dois produtos (ex: ambos em gramas, ou ambos em ml).

### Como funciona o cálculo

```
preço unitário = preço total ÷ quantidade

economia (%) = (preço_unitário_perdedor - preço_unitário_vencedor)
               ÷ preço_unitário_perdedor × 100
```

**Exemplo:**
| Produto | Preço | Quantidade | Preço/un |
|---------|-------|------------|----------|
| A       | R$ 7,50 | 350 g    | R$ 0,0214/g |
| B       | R$ 11,00 | 700 g   | R$ 0,0157/g |

→ Produto B é **26,7% mais barato por unidade**, mesmo custando mais no total.

### Funcionalidades

- Comparação instantânea de preço por unidade
- Destaque animado do produto vencedor
- Percentual exato de economia
- Idiomas: **Português (Brasil)** e **English (US)**
- Tema claro e escuro automático (segue o sistema)
- 100% offline — nenhum dado é enviado para servidores
- Sem anúncios, sem cadastro

### Plataformas

| Plataforma | Status |
|------------|--------|
| Android    | ✅ Suportado |
| iOS        | ✅ Suportado |

### Tech stack

| Componente        | Tecnologia                        |
|-------------------|-----------------------------------|
| UI framework      | Flutter (Material 3)              |
| Estado / i18n     | InheritedWidget + classe S        |
| Animações         | AnimationController + Interval curves |
| Dependências ext. | Nenhuma (standalone)              |

### Build

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS (requer Mac com Xcode)
flutter build ios --release
```

### Apoiar o projeto

O Compriceon é gratuito e sem anúncios. Se ele te ajudou a economizar, considere apoiar o desenvolvimento.

**PIX:** `3a2b8066-7987-4e10-b0da-8ccc4c9da565`

---

<p align="center">
  eltondantas.com &nbsp;=)
</p>
