require 'ostruct'
require 'ruby2d'
require_relative '/Minesweeper/Minesweeper/Game/Entidades/minefield.rb'
require_relative '/Minesweeper/Minesweeper/UI/display.rb'

# Classe da IA
class Ia 

    attr_accessor :tabelaDeCelulas, :vez

    def initialize()
      @tabelaDeCelulas = Hash[]
      @vez = false
    end
    
    # Função da jogada da IA
    def fazerJogada(mineField, display, tamanho)
        value = self.tabelaDeCelulas.shift()
        pair = value[0]

        if !value[1] and mineField.getGrid()[pair[0]][pair[1]].getCor() == "black"
            display.atualizarCampo(mineField, pair[0], pair[1])
        elsif !value[1] and mineField.getGrid()[pair[0]][pair[1]].getCor() == "red" 
            mineField.setCelulasDescobertas(mineField.getCelulasDescobertas() - 1)
            display.printarCorVermelha(mineField, pair[0], pair[1])
            fazerJogada(mineField, display, tamanho)
        elsif value[1] and mineField.getGrid()[pair[0]][pair[1]].getCor() == "black"
            mineField.setCelulasDescobertas(mineField.getCelulasDescobertas() + 1)
            display.printarCorVermelha(mineField, pair[0], pair[1])
        end

        atualizarHash(mineField)
    end
    
    # Coloca os valores dentro da hash
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

    # Atualiza a hash
    def atualizarHash(mineField)
        pair = OpenStruct.new

        for arr in mineField.getGrid() do
            for cell in arr do
                if cell.getCor() == "blue"
                    pair = [cell.getI(), cell.getJ()]
                    if !self.tabelaDeCelulas.member?(pair)
                        self.tabelaDeCelulas.delete(pair)
                    end
                elsif cell.getMina() and cell.getCor() == "red"
                    pair = [cell.getI(), cell.getJ()]
                    if !self.tabelaDeCelulas.member?(pair)
                        self.tabelaDeCelulas.delete(pair)
                    end
                elsif !cell.getMina() and cell.getCor() == "red"
                    pair = [cell.getI(), cell.getJ()]
                    if !self.tabelaDeCelulas.member?(pair)
                        self.tabelaDeCelulas.store(pair, false)
                    end
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