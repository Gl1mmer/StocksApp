//
//  SwiftUIView.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 24.12.2024.
//

import SwiftUI
import Charts

struct SwiftUIView: View {
    
    @Environment(\.presentationMode) var presentationMode
    private var stock: StockModel
    var favoriteChanged: ((Bool) -> Void)
    private var coreDataControl: CoreDataControl
    @StateObject private var viewModel: ChartsViewModel
    
    init(stock: StockModel, coreData: CoreDataControl, favoriteChanged: @escaping ((Bool) -> Void)) {
        self.stock = stock
        self.coreDataControl = coreData
        _viewModel = StateObject(wrappedValue: ChartsViewModel(stock: stock, coreData: coreData))
        self.favoriteChanged = favoriteChanged
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundStyle(Color.black)
                }
                Spacer()
                VStack {
                    Text(viewModel.ticker)
                        .font(.title2)
                    Text(viewModel.name)
                        .font(.caption2)
                }
                Spacer()
                Button {
                    viewModel.favoriteButtonTapped()
                    favoriteChanged(viewModel.isFavorite)
                } label: {
                    if viewModel.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundStyle(Color.yellow)
                            .font(.title3)
                    } else {
                        Image(systemName: "star")
                            .foregroundStyle(Color.black)
                            .font(.title3)
                    }
                }
            }
            .padding()
            ScrollView(.horizontal, content: {
                HStack(spacing: 20) {
                    Button("Chart") {
                        
                    }
                    .fontWeight(.bold)
                    .font(.system(size: 24))
                    .foregroundStyle(Color.black)
                    Button("Summary") {
                        
                    }
                    Button("News") {
                        
                    }
                    Button("Forecasts") {
                        
                    }
                    Button("Ideas") {
                        
                    }
                    Button("Events") {
                        
                    }
                }
                .fontWeight(.light)
                .font(.system(size: 20))
                .foregroundStyle(Color.gray)
                .padding(.leading, 20)
            })
            VStack {
                Text("$\(String(describing: viewModel.price))")
                    .font(.largeTitle)
                    .bold()
                if (viewModel.change >= 0) {
                    Text("+$\(String(describing: viewModel.change)) (\(String(describing: viewModel.changePercent))%)")
                        .font(.subheadline)
                        .foregroundStyle(Color.green)
                } else {
                    Text("-$\(String(describing: abs(viewModel.change))) (\(String(describing: abs(viewModel.changePercent)))%)")
                        .font(.subheadline)
                        .foregroundStyle(Color.red)
                }
            }
            .padding(.top, 48)
            Chart {
                ForEach(viewModel.prices) { priceDay in
                    LineMark(
                        x: .value("Day", priceDay.date),
                        y: .value("Price", priceDay.price)
                    )
                    AreaMark(
                        x: .value("Day", priceDay.date),
                        yStart: .value("Price", 0), // Starting point for the fill
                        yEnd: .value("Price", priceDay.price) // End point for the fill
                            )
                        .foregroundStyle(
                            Color.pink.opacity(0.2) // Add a semi-transparent color for the fill
                        )
                }
                .foregroundStyle(Color.pink)
                
            }
            .frame(height: 260)
            .padding(.top, 100)
//            .background(.blue)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            HStack(spacing: 10) {
                ForEach(["D", "W", "M", "6M", "1Y", "All"], id: \.self) { period in
                    Button {
                        
                    } label: {
                        Text(period)
                            .font(.subheadline)
                            .foregroundStyle(Color.black)
                            .frame(width: 42, height: 44)
                            .background(.gray)
                            .cornerRadius(12)
                            
                    }
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            Spacer()
            Button("Buy for $\(String(describing: viewModel.price))") {
                
            }
            .foregroundStyle(Color.white)
            .frame(width: 328, height: 56)
            .background(.black)
            .cornerRadius(16)
            .padding()
        }
    }
}

#Preview {
    SwiftUIView(stock: StockModel(ticker: "AAPL", name: "Apple Inc.", logoString: "logo", price: 123.12, change: -12.1, changePercent: -10.1, favorite: true), coreData: CoreDataControl()) { _ in
    }
}


