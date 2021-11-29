require 'ostruct'
require 'ruby2d'
require_relative 'D:\Projetos Com Ruby\Minesweeper\Minesweeper\Game\Entidades\minefield.rb'
require_relative 'D:\Projetos Com Ruby\Minesweeper\Minesweeper\UI\display.rb'

class Ia 

    attr_accessor :tabelaDeCelulas, :vez

    def initialize()
      @tabelaDeCelulas = Hash[]
      @vez = false
    end
    
    def fazerJogada(mineField, display, tamanho)
        pair = OpenStruct.new
        range = tamanho - 1
        row = rand(range)
        column = rand(range)
        pair = [row, column]
        if !self.tabelaDeCelulas.key?(pair)
            while self.tabelaDeCelulas.key?(pair) do
                row = rand(range)
                column = rand(range)
            end
            pair = [row, column]
        end

        if !self.tabelaDeCelulas[pair]
            atualizarHash(row, column, mineField)
            display.atualizarCampo(mineField, row, column, true)
        elsif !self.tabelaDeCelulas[pair] and mineField.getGrid()[row][column].getCor() == "red"
            atualizarHash(row, column, mineField)
            display.printarCorVermelha(mineField, row, column)
        else
            atualizarHash(row, column, mineField)
            display.printarCorVermelha(mineField, row, column)
        end
    end

    def printarTextoIA()  
        text = Text.new(
            'IA vez!',
            x: 190, y: 200,
            style: 'bold',
            size: 50,
            color: 'red',
            rotate: 0,
            z: 0
        )
        return text
    end
    
    
    def setTabelaDeCelulas(mineField)
        pair = OpenStruct.new
        pair = [0, 0]

        for arr in mineField.getGrid() do
            for cell in arr do
                if cell.getCor() == "black"
                    if cell.getMina() 
                        pair = [cell.getI(), cell.getJ()]
                        self.tabelaDeCelulas.store(pair, true)
                    else 
                        pair = [cell.getI(), cell.getJ()]
                        self.tabelaDeCelulas.store(pair, false)
                    end 
                end
            end
        end
    end

    def atualizarHash(row, column, mineField)
        pair = OpenStruct.new
        pair = [row, column]
        puts mineField.getGrid()[row][column].getQuantidadeMinas() 
        if mineField.getGrid()[row][column].getQuantidadeMinas() == 0
            for arr in mineField.getGrid() do
                for cell in arr do
                    if cell.getCor() == "blue"
                        pair = [cell.getI(), cell.getJ()]
                        self.tabelaDeCelulas.delete(pair)
                    end
                end
            end
        else
            if self.tabelaDeCelulas.key?(pair)  
                if mineField.getGrid()[row][column].getMina() and mineField.getGrid()[row][column].getCor() == "red" 
                    self.tabelaDeCelulas.delete(pair)
                elsif mineField.getGrid()[row][column].getCor() == "blue"
                    self.tabelaDeCelulas.delete(pair)
                end
            else
                if mineField.getGrid()[row][column].getMina()  
                    self.tabelaDeCelulas.store(pair, true)
                else
                    self.tabelaDeCelulas.store(pair, false)
                end
            end
        end
    end

    def buscaCelula(x, y, mineField)
        for arr in mineField.getGrid() do
            for cell in arr do
                if cell.getI() == x and cell.getJ() == y
                    atualizarHash(cell.getI(), cell.getJ(), mineField)
                end
            end
        end
    end
    

    def setVez(valor)
        self.vez = valor
    end

    def getTabelaDeCelulas()
        return self.tabelaDeCelulas    
    end
    
    def getVez()
        return self.vez
    end    
end

# Test
# mineField = CampoMinado.new(400, 400, 8, 100, 30)
# mineField.verificaVizinhos()
# mineField.radarDeMinas()

# ia = Ia.new()

# ia.setTabelaDeCelulas(mineField)

# array = ia.getTabelaDeCelulas().keys

# for valor in array do
#     puts valor
#     puts ia.getTabelaDeCelulas()[valor]
# end