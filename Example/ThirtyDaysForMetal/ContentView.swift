//
//  ContentView.swift
//  ThirtyDaysForMetal
//
//  Created by kumatt on 2024/12/31.
//

import SwiftUI

struct ContentView: View {
    
    private let demos: [AnyMetalDemo] = {
        let demoTypes: [AnyMetalDemo.Type] = [
            Demo01_TriangleRender.self,
            Demo02_Rectangle.self
        ]
        return demoTypes.map { $0.instance() }.filter { $0 != nil } as? [AnyMetalDemo] ?? []
    }()
    
    
    var body: some View {
        NavigationView(content: {
            List(Array(demos.enumerated()), id: \.offset) { item in
                let title = String(describing: type(of: item.element))
                NavigationLink(destination: MetalDemoRepresentableView(demo: item.element)
                    .navigationBarTitle(Text(title))
                ) { Text(title) }
            }
        })
    }
}

#Preview {
    ContentView()
}
