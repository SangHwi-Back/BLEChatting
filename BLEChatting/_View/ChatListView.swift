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
    @Environment(UseCaseFactory.self) var useCaseFactory
    @ObservedObject private var viewModel: ChatListViewModel
    
    init(viewModel: ChatListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { proxy in
            NavigationStack {
                VStack {
                    ScrollView { VStack {
                        ForEach(viewModel.items) { item in
                            NavigationLink(value: item) {
                                IssueListComponent(text: item.name)
                                    .foregroundColor(Color.black)
                            }
                        }
                    }}
                    
                    ChatListActionBar(name: $viewModel.userName, showModal: $viewModel.showModal)
                        .frame(height: 50)
                        .background(Color.white)
                        .shadow(radius: 2)
                        .padding(.vertical, 5)
                }
                .navigationDestination(for: TestData.self) { item in
                    ChatRoomView(serviceID: .TEST,
                                 viewModel: ChatRoomViewModel(useCaseFactory: useCaseFactory))
                }
            }
            .overlay {
                if viewModel.showModal {
                    ZStack {
                        Color.black.opacity(0.2)
                        CreateChatModalPopup(geometryProxy: proxy,
                                             useCaseFactory: useCaseFactory,
                                             showModal: $viewModel.showModal)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
            }
            .animation(.spring(), value: viewModel.showModal)
        }
    }
    
    fileprivate struct ChatListActionBar: View {
        @Binding var name: String
        @Binding var showModal: Bool
        
        var body: some View {
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
    }
    
    fileprivate struct CreateChatModalPopup: View {
        @Binding private var showModal: Bool
        @ObservedObject private var viewModel: ChatListModalViewModel
        
        var geometryProxy: GeometryProxy
        var onClose: (() -> Void)?
        
        var width: CGFloat { geometryProxy.size.width }
        var height: CGFloat { geometryProxy.size.height }
        
        init(geometryProxy: GeometryProxy,
             useCaseFactory: UseCaseFactory,
             showModal: Binding<Bool>) {
            self.geometryProxy = geometryProxy
            self._showModal = showModal
            self.viewModel = ChatListModalViewModel(useCaseFactory: useCaseFactory)
        }
        
        var body: some View {
            VStack {
                ZStack {
                    Text("누구와 채팅방을 만들까요?").font(.title2)
                        .foregroundStyle(.black)
                        .padding(.horizontal, 45)
                    HStack {
                        Spacer()
                        Button { 
                            showModal = false
                        } label: {
                            Image(systemName: "xmark.circle")
                                .foregroundStyle(.red)
                                .frame(width: 40, height: 40)
                        }
                    }
                }
                .padding()
                Group {
                    List(viewModel.peripherals, id: \CBPeripheral.name) { peripheral in
                        HStack(spacing: 4) {
                            PersonThumbnail()
                                .frame(width: 40, height: 40)
                            Text(peripheral.name ?? "")
                        }
                    }
                    .toolbar { EditButton() }
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
