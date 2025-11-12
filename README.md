# 📈 StocksApp

An iOS application for tracking **real-time and historical stock prices**.  
Built with a **hybrid UIKit + SwiftUI** interface and powered by the **Finnhub API**.

---

## 🖼️ Preview

<p align="center">
  <img src="https://github.com/user-attachments/assets/e5d5a6fe-883e-4028-8cf6-da9ee90bda64" width="250"/>
  <img src="https://github.com/user-attachments/assets/80dfd149-4fd1-46e7-8d67-a87fd2621550" width="250"/>
  <img src="https://github.com/user-attachments/assets/13e1d03b-5639-4932-98dc-e5cf7e323f0f" width="250"/>
</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/c019bdff-5cba-477f-aa6a-b1215a3fc5be" width="250"/>
  <img src="https://github.com/user-attachments/assets/bcedaa50-3ac4-43a3-8b89-cc204fa3ebc3" width="250"/>
</p>

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
