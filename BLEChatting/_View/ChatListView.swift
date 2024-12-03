//
//  ContentView.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/24/24.
//

import SwiftUI
import SwiftData
import CoreBluetooth

struct TestData: Identifiable, Hashable {
    let text: String
    let id: UUID = UUID()
}

struct ChatList: View {
    typealias Responder = (any ChatBLMInterface<ChatResponderUseCase.Actions>)
    
    @Environment(UseCaseFactory.self) var useCaseFactory: UseCaseFactory
    
    @State var items: [TestData]
    @State var name: String = ""
    @State private var responder: Responder?
    @State private var peripherals = Set<CBPeripheral>()
    @State private var showModal = false
    
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { proxy in
            NavigationStack {
                VStack {
                    ScrollView { VStack {
                        ForEach(items) { item in
                            NavigationLink(value: item) {
                                IssueListComponent(testData: item)
                                    .foregroundColor(Color.black)
                            }
                        }
                    }}
                    
                    ChatListActionBar
                        .frame(height: 50)
                        .background(Color.white)
                        .shadow(radius: 2)
                        .padding(.vertical, 5)
                }
                .navigationDestination(for: TestData.self) { item in
                    ChatRoomView(text: item.text)
                }
            }
            .overlay {
                if showModal {
                    ZStack {
                        Color.black.opacity(0.2)
                        CreateChatModalPopup(
                            peripherals: $peripherals,
                            geometryProxy: proxy,
                            onClose: {
                                showModal = false
                            }
                        )
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
            }
            .animation(.spring(), value: showModal)
        }
        .onAppear {
            if responder == nil {
                responder = useCaseFactory.getUseCase(.central)
            }
            
            responder?.reduce(.scan)
        }
        .onReceive(timer) { _ in
            responder?.reduce(.getPeripherals({ peripherals in
                self.peripherals = peripherals
            }))
        }
    }
    
    private var ChatListActionBar: some View {
        HStack {
            TextField("이름을 입력하세요", text: $name)
                .textFieldStyle(.roundedBorder)
            Button {
                showModal = true
            } label: {
                Image(systemName: "plus.circle")
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal)
    }
    
    struct CreateChatModalPopup: View {
        @Binding var peripherals: Set<CBPeripheral>
        var geometryProxy: GeometryProxy
        var onClose: (() -> Void)?
        
        var width: CGFloat { geometryProxy.size.width }
        var height: CGFloat { geometryProxy.size.height }
        
        var body: some View {
            VStack {
                ZStack {
                    Text("누구와 채팅방을 만들까요?").font(.title2)
                        .padding(.horizontal, 45)
                    HStack {
                        Spacer()
                        Button {
                            onClose?()
                        } label: {
                            Image(systemName: "xmark.circle")
                                .foregroundStyle(.red)
                                .frame(width: 40, height: 40)
                        }
                    }
                }
                .padding()
                Group {
                    List(Array($peripherals.wrappedValue), id: \CBPeripheral.name) { peripheral in
                        HStack(spacing: 4) {
                            PersonThumbnail()
                            Text(peripheral.name ?? "")
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                .padding()
            }
            .background(Color.white)
            .frame(height: 300)
            .cornerRadius(10)
        }
    }
}

#Preview {
    ContentView()
}
