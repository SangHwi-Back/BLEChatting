//
//  ContentView.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/24/24.
//

import SwiftUI
import SwiftData
import CoreBluetooth
import Combine

struct TestData: Identifiable, Hashable {
    let text: String
    let id: UUID = UUID()
}

struct ChatList: View {
    typealias Responder = (any ChatBLMInterface<ChatResponderUseCase.Actions>)
    
    @Environment(UseCaseFactory.self) var useCaseFactory: UseCaseFactory
    
    @State var items: [TestData]
    @State private var showModal = false
    
    var body: some View {
        GeometryReader { proxy in
            NavigationStack {
                VStack {
                    ScrollView { VStack {
                        ForEach(items) { item in
                            NavigationLink(value: item) {
                                IssueListComponent(testData: item)
                                    .foregroundColor(Color.black)
                                    .frame(maxWidth: 700)
                            }
                        }
                    }}
                    
                    ChatListActionBar(showModal: $showModal)
                        .frame(height: 50)
                        .padding(.vertical, 5)
                }
                .navigationDestination(for: TestData.self) { item in
                    ChatRoomView(serviceID: .TEST)
                }
            }
            .overlay {
                if showModal {
                    ZStack {
                        Color.black.opacity(0.2)
                        CreateChatModalPopup(
                            geometryProxy: proxy,
                            useCaseFactory: useCaseFactory,
                            onClose: { showModal = false }
                        )
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
            }
            .animation(.spring(), value: showModal)
        }
    }
    
    fileprivate struct ChatListActionBar: View {
        @State private var name: String = ""
        @Binding var showModal: Bool
        var body: some View {
            HStack {
                TextField("이름을 입력하세요", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .shadow(radius: 2)
                Button { showModal = true } label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal)
        }
    }
    
    fileprivate struct CreateChatModalPopup: View {
        @State private var peripherals: [CBPeripheral] = []
        
        @State private var subscriptions = Set<AnyCancellable>()
        private var responder: Responder?
        
        private var scanPublisher: PassthroughSubject<[CBPeripheral], Never> = .init()
        
        var geometryProxy: GeometryProxy
        var onClose: (() -> Void)?
        
        var width: CGFloat { geometryProxy.size.width }
        var height: CGFloat { geometryProxy.size.height }
        
        init(geometryProxy: GeometryProxy,
             useCaseFactory: UseCaseFactory,
             onClose: (() -> Void)? = nil
        ) {
            self.geometryProxy = geometryProxy
            self.onClose = onClose
            self.responder = useCaseFactory.getUseCase(.central)
        }
        
        var body: some View {
            VStack {
                ZStack {
                    Text("누구와 채팅방을 만들까요?")
                        .font(.title2)
                        .foregroundStyle(.black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.2)
                        .padding(.horizontal, 45)
                    HStack {
                        Spacer()
                        Button { onClose?() } label: {
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
                                .frame(width: 40, height: 40)
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
            .onAppear {
                scanPublisher.sink { peripherals in
                    print("🚦 peripherals count \(peripherals.count)")
                    self.peripherals = peripherals
                }
                .store(in: &subscriptions)
                responder?.reduce(.scan(scanPublisher))
                
            }
        }
    }
}

#Preview {
    ContentView()
}
