# 📈 StocksApp

An iOS application for tracking **real-time and historical stock prices**.  
Built with a **hybrid UIKit + SwiftUI** interface and powered by the **Finnhub API**.

---

## 🖼️ Preview



---

## 🚀 Overview

**StocksApp** allows users to monitor stock prices, view performance charts, and manage favorite companies — all within a clean, responsive UI.  
The project demonstrates a **hybrid architecture (UIKit + SwiftUI)** and uses **MVVM**, **Core Data**, and **URLSession** for data-driven development.

---

## 💡 Key Features

### 📊 Company List (UIKit)
- Displays **company name, ticker, logo, and current price**
- Supports **Pull-to-Refresh** for manual updates
- Smooth navigation with `UINavigationController`

### ⭐ Favorites (Core Data)
- Add or remove stocks from the **Favorites** list  
- Persistent local storage via Core Data

### 📈 Details View (SwiftUI + Swift Charts)
- Displays **historical stock price data**
- Interactive chart built with **Swift Charts**
- Integrated into UIKit via `UIHostingController`

---

## 🧩 Tech Stack

| Layer | Tools |
|--------|--------|
| **Language** | Swift 5 |
| **UI Frameworks** | UIKit, SwiftUI, Swift Charts |
| **Architecture** | MVVM |
| **Networking** | URLSession, Codable |
| **Persistence** | Core Data |
| **API** | Finnhub API |
| **Layout** | Auto Layout |

---

## 🧠 Architecture

The project follows a **hybrid MVVM architecture**, combining **UIKit** for main screens and **SwiftUI** for the details view.

```bash
StocksApp
├── Core
│   ├── Home
│   │   ├── ViewModels
│   │   └── Views (UIKit)
│   └── StockDetails
│       ├── ViewModels
│       └── Views (SwiftUI + Swift Charts)
├── Services (networking, data fetching)
├── CoreData (favorites storage)
└── Models (StockModel, DetailedPriceModel)
