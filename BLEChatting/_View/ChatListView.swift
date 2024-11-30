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
    @Environment(UseCaseFactory.self) private var factory: UseCaseFactory
    @State var items: [TestData]
    @State var showModal = false
    @State var centralName = ""
    
    var centralManaer: ChatBLMInterface {
        factory.getUseCase(.central)
    }
    var peripheralManager: ChatBLMInterface {
        factory.getUseCase(.peripheral)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack {
                        ForEach(items) { item in
                            NavigationLink(value: item) {
                                IssueListComponent(testData: item)
                                    .foregroundColor(Color.black)
                            }
                        }
                    }
                }
                EnterMyNameComponent($centralName)
            }
            .navigationDestination(for: TestData.self) { item in
                ChatRoomView(text: item.text)
            }
            .fullScreenCover(isPresented: $showModal) {
                FindPeripheralModal($showModal)
                    .presentationBackground(.ultraThinMaterial)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showModal = true
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .stroke(Color.black)
                            Image(systemName: "plus")
                                .foregroundColor(Color.black)
                                .padding(3)
                        }
                    }
                    .frame(width: 30)
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
        }
    }
}

private struct EnterMyNameComponent: View {
    @GestureState private var isDetectingLongPress = false
    @Binding private var centralName: String
    @State var popoverModel: PopoverModel?
    
    init(_ centralName: Binding<String>) {
        self._centralName = centralName
    }
    
    var body: some View {
        HStack(spacing: 10) {
            TextField("Enter name", text: $centralName)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
            Button {
                
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .stroke(Color.black)
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .foregroundColor(Color.black)
                        .showPopover($popoverModel)
                        .onLongPressGesture {
                            popoverModel = .init(message: "Find friend")
                        }
                }
            }
            .frame(width: 40)
            .aspectRatio(1.0, contentMode: .fit)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}

private struct FindPeripheralModal: View {
    @Binding var showModal: Bool
    @State private var offset: CGFloat = 700
    
    init(_ showModal: Binding<Bool>) {
        self._showModal = showModal
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showModal = false
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                
                Spacer()
                
                Text("hello")
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .padding()
        .offset(y: offset)
        .onAppear {
            withAnimation(.spring()) {
                offset = 0
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(UseCaseFactory())
}
