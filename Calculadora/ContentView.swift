//
//  ContentView.swift
//  Calculadora
//
//  Created by Victor Tejeda on 9/10/24.
//

import SwiftUI

struct ContentView: View {
    
    let grid = [
        ["AC","􀆗","%","/",],
        ["7","8","9","X",],
        ["4","5","6","-",],
        ["1","2","3","+",],
        [".","0","","=",]
    ]
    
    let operacion =  ["/","+","X","%",]
    
    @State var visibleworking = ""
    @State var visibleResult = ""
    @State var showAlert = false
    
    var body: some View {
        VStack {
            HStack
            {
                Spacer()
                Text(visibleworking)
                    .padding()
                    .foregroundColor(Color.white)
                    .font(.system(size: 30, weight: .heavy))
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack
            {
                Spacer()
                Text(visibleResult)
                    .padding()
                    .foregroundColor(Color.white)
                    .font(.system(size: 50, weight: .heavy))
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            ForEach(grid, id: \.self)
            {
                row in
                HStack
                {
                    ForEach(row, id: \.self)
                    {
                        cell in
                        
                        Button(action: { buttonPressed(cell: cell)}, label: {
                            Text(cell)
                                .foregroundColor(buttomColor(cell))
                                .font(.system(size: 40, weight: .heavy))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        })
                    }
                }
            }
            
        }
        .background(Color.black.ignoresSafeArea())
        .alert(isPresented: $showAlert)
        {
            Alert(
                title: Text("Invalid Input"),
                message: Text(visibleworking),
                dismissButton: .default(Text("Okey"))
            )
        }
    }
    func buttomColor(_ cell: String) -> Color
    {
        if(cell == "AC" || cell == "􀆗")
        {
            return .red
        }
        
        if(cell == "-" || cell == "=" || operacion.contains(cell))
        {
            return .orange
        }
        return .white
    }
    
    
    func buttonPressed(cell: String)
    {
        switch cell{
                
            case "AC":
                visibleworking = ""
                visibleResult = ""
                
            case "􀆗":
                visibleworking = String(visibleworking.dropLast())
            case "=":
                visibleResult = calculadoraResultado()
                
            case "-":
                addMinus()
            default:
                visibleworking += cell
        }
    }
    
    func addOperador(_ cell : String ){
        if !visibleworking.isEmpty
        {
            let last = String(visibleworking.last!)
            if operacion.contains(last) || last == "-"
            {
                visibleworking.removeLast()
            }
            visibleworking += cell
        }
    }
    
    
    func addMinus()  {
        if visibleworking.isEmpty || visibleworking.last != "-"
        {
            visibleworking += "-"
        }
    }
    
    func calculadoraResultado() -> String
    {
        if(validInput())
        {
            var workings = visibleworking.replacingOccurrences(of: "%", with: "*0.01")
            workings = workings.replacingOccurrences(of: "X", with: "*")
            let expression = NSExpression(format: workings)
            let result = expression.expressionValue(with: nil, context: nil) as! Double
            return formatoResultado(val: result)
        }
        showAlert = true
        return ""
    }
    
    func validInput() -> Bool
    {
        if(visibleworking.isEmpty)
        {
            return false
        }
        let last = String(visibleworking.last!)
        
        if(operacion.contains(last) || last == "-")
        {
            if(last != "%" || visibleworking.count == 1)
            {
                return false
            }
        }
            return true
    }
    
    func formatoResultado(val: Double) -> String
    {
        if(val.truncatingRemainder(dividingBy: 1) == 0)
        {
            return String(format: "%.0f", val)
        }
        
        return String(format: "%.2f", val)
    }
}
#Preview {
    ContentView()
}
