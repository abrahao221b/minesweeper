require_relative "cell.rb"

# Entidade campo minado
class CampoMinado

    attr_accessor :altura, :largura, :colunas, :linhas, :grid, :celulas

    def initialize(altura, largura)
        @altura = altura
        @largura = largura
        @celulas = Celula.new(0,0, 40)
        @colunas = self.largura / self.celulas.getSize()
        @linhas =  self.altura / self.celulas.getSize()
        @grid = criarArray2D()              
    end

    # Retorna a matriz do campo minado
    def criarArray2D()
        grid = Array.new(self.colunas){Array.new(self.linhas)}
        k = 0
        self.colunas.times do
            w = 0 
            self.linhas.times do
                grid[k][w] = Celula.new(k*self.celulas.getSize() + 20,  w*self.celulas.getSize() + 30, self.celulas.getSize())
                grid[k][w].setMina()
                w += 1                
            end
            k += 1
        end
        return grid
    end
    
    def getColunas()
        return self.colunas
    end
    
    def getLinhas()
        return self.linhas
    end

    def getAltura()
        return self.altura
    end
    
    def getLargura()
        return self.largura
    end
    
    def getGrid()
        return self.grid
    end
end

# minefild = CampoMinado.new(400,400)

# for arr in minefild.getGrid do
#     for cell in arr do
#         puts cell.getMina()
#     end
# end