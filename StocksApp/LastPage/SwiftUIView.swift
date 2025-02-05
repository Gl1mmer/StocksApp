//
//  SwiftUIView.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 24.12.2024.
//

import SwiftUI
import Charts

struct StockDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    private var stock: StockModel
    var favoriteChanged: ((Bool) -> Void)
    private var coreDataControl: CoreDataControl
    @StateObject private var viewModel: ChartsViewModel
    
    @State private var selectedID : Int?
    @State private var selectedRange: String = "All"
    
    init(stock: StockModel, coreData: CoreDataControl, favoriteChanged: @escaping ((Bool) -> Void)) {
        self.stock = stock
        self.coreDataControl = coreData
        _viewModel = StateObject(wrappedValue: ChartsViewModel(stock: stock, coreData: coreData, priceHistoryNetworking: PriceHistoryNetworkingClass()))
        self.favoriteChanged = favoriteChanged
    }
    
    var body: some View {
        VStack {
            navigationBarView
            infoOptionsView
            priceInfoView
            chartsView
            rangeButtonsView
            Spacer()
            buyButtonView
            .alert("Buy for $\(String(describing: viewModel.dataModel.price))", isPresented: $viewModel.isShowAlert) {
                Button("Buy") {
                    viewModel.isBoughtStock = true
                }
                Button("No, I don't", role: .cancel) {
                }
            } message: {
                Text("Are you sure you want to buy \(viewModel.dataModel.name) for \(String(describing: viewModel.dataModel.price))?")
            }
            .alert("Congratulations!!! \nYou bought 1 stock share of \(viewModel.dataModel.name)", isPresented: $viewModel.isBoughtStock) {
            }
        }
        .onAppear {
            viewModel.fetchHistoryPrice()
        }
    }
}

#Preview {
    StockDetailView(stock: StockModel(ticker: "IBM", name: "Apple Inc.", logoString: "logo", price: 123.12, change: -12.1, changePercent: -10.1, favorite: true), coreData: CoreDataControl()) { _ in
    }
}

extension StockDetailView {
    
    private var navigationBarView: some View {
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
                Text(viewModel.dataModel.ticker)
                    .font(.montserrat(.bold, size: 18))
                Text(viewModel.dataModel.name)
                    .font(.montserrat(.regular, size: 12))
            }
            
            Spacer()
            
            Button {
                viewModel.favoriteButtonTapped()
                favoriteChanged(viewModel.dataModel.isFavorite)
            } label: {
                if viewModel.dataModel.isFavorite {
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
    }
    
    private var infoOptionsView: some View {
        ScrollView(.horizontal, showsIndicators: false ,content: {
            HStack(spacing: 20) {
                Button("Chart") {
                    
                }
                .font(.montserrat(.bold, size: 24))
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
            .font(.montserrat(.light, size: 20))
            .foregroundStyle(Color.gray)
            .padding(.leading, 20)
            
        })
    }

    private var priceInfoView: some View {
        VStack {
            Text("$\(String(describing: viewModel.dataModel.price))")
                .font(.montserrat(.bold, size: 28))
            if (viewModel.dataModel.change >= 0) {
                Text("+$\(String(describing: viewModel.dataModel.change)) (\(String(describing: viewModel.dataModel.changePercent))%)")
                    .font(.montserrat(.regular, size: 12))
                    .foregroundStyle(Color.green)
            } else {
                Text("-$\(String(describing: abs(viewModel.dataModel.change))) (\(String(describing: abs(viewModel.dataModel.changePercent)))%)")
                    .font(.montserrat(.regular, size: 12))
                    .foregroundStyle(Color.red)
            }
        }
        .padding(.top, 48)
    }
    
    private var chartsView: some View {
        Chart {
            ForEach(viewModel.pricesPerPeriod) { priceDay in
                LineMark(
                    x: .value("id", priceDay.id),
                    y: .value("Price", priceDay.price)
                )
                AreaMark(
                    x: .value("id", priceDay.id),
                    yStart: .value("Price", 0),
                    yEnd: .value("Price", priceDay.price)
                        )
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0.3),
                            Color.black.opacity(0.1),
                            Color.black.opacity(0.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .foregroundStyle(Color.black)
            
            if let selectedData = viewModel.pricesPerPeriod.first(where: { $0.id == selectedID }) {
                PointMark(
                    x: .value("id", selectedData.id),
                    y: .value("Price", selectedData.price)
                )
                .symbol {
                    ZStack {
                        Circle()
                            .strokeBorder(Color.white, lineWidth: 4)
                            .frame(width: 12, height: 12)
                        Circle()
                            .fill(Color.black)
                            .frame(width: 8, height: 8)
                    }
                }
            }
            
            if let selectedID {
                RuleMark(x: .value("Index", selectedID))
                    .foregroundStyle(Color.clear)
                    .annotation(position: .top, overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                        VStack {
                            Text(viewModel.getPriceForIndex(of: selectedID))
                                .font(.montserrat(.bold, size: 16))
                            Text(viewModel.getDateForIndex(of: selectedID))
                                .font(.montserrat(.regular, size: 12))
                                
                        }
                        .foregroundStyle(Color.white)
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.black.gradient).opacity(0.95))
                    }
            }
        }
        .frame(height: 260)
        .padding(.top, 100)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartXSelection(value: $selectedID)
    }
    
    private var rangeButtonsView: some View {
        HStack(spacing: 15) {
            ForEach(["D", "3D", "W", "2W", "M", "All"], id: \.self) { period in
                Button {
                    withAnimation(.easeOut) {
                        selectedRange = period
                    }
                    viewModel.getPriceForPeriod(of: period)
                } label: {
                    Text(period)
                        .font(selectedRange == period ? .montserrat(.bold, size: 12) :.montserrat(.regular, size: 12))
                        .foregroundStyle(selectedRange == period ? Color.white : Color.black)
                        .frame(width: 42, height: 44)
                        .background(selectedRange == period ? .black : .gray.opacity(0.1))
                        .cornerRadius(12)
                    
                }
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)

    }
    
    private var buyButtonView: some View {
        Button {
            viewModel.isShowAlert = true
        } label: {
            Text("Buy for $\(String(describing: viewModel.dataModel.price))")
                .font(.montserrat(.semibold, size: 16))
                .foregroundStyle(Color.white)
        }
        .frame(width: 328, height: 56)
        .background(.black)
        .cornerRadius(16)
        .padding()
    }
}
