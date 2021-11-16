require_relative "cell.rb"

# Entidade campo minado
class CampoMinado

    attr_accessor :altura, :largura, :colunas, :linhas, :grid, :celulas

    def initialize(altura, largura)
        @altura = altura
        @largura = largura
        @celulas = Celula.new(0, 0, 40)
        @linhas = self.altura / self.celulas.getSize()
        @colunas =  self.largura / self.celulas.getSize()
        @grid = criarArray2D()              
    end

    # Retorna a matriz do campo minado
    def criarArray2D()
        grid = Array.new(self.colunas){Array.new(self.linhas)}
        k = 0
        self.linhas.times do
            w = 0 
            self.colunas.times do
                grid[k][w] = Celula.new(k, w, self.celulas.getSize())
                grid[k][w].setMina()
                w += 1
                            
            end
            k += 1
        end

        return grid
    end

    # verifica se o elemento está dentro da matriz
    def dentroDoGrid(k, w)
        if (k >= 0 and w >= 0 and k < self.colunas and w < self.linhas)
            return true
        end
        return false
    end
    
    # Verifica os vizinhos de cada elemento da matriz
    def verificaVizinhos()
        arrayDeslocamentoV = Array[1, 0, -1, 0, 1, 1, -1, -1]
        arrayDeslocamentoH = Array[0, -1, 0, 1, 1, -1, 1, -1]
        k = 0
        self.linhas.times do
            w = 0 
            self.colunas.times do
                i = 0
                while i <= 7
                    x = k + arrayDeslocamentoV[i]
                    y = w + arrayDeslocamentoH[i]
                    if dentroDoGrid(x, y)
                        self.grid[k][w].setarVizinhos(self.grid[x][y])
                    end
                    i += 1
                end 
                w += 1            
            end
            k += 1
        end

    end
    

    # Conta o número de minas ao redor
    def radarDeMinas()
        
        k = 0
        self.linhas.times do
            w = 0 
            self.colunas.times do
                if(self.grid[k][w].getMina()) 
                    self.grid[k][w].setQuantidadeMinas(-1) 
                end
                total = 0
                for i in self.grid[k][w].getArrayDeVizinhos() do
                    if i.getMina() 
                        total += 1
                    end
                end
                self.grid[k][w].setQuantidadeMinas(total)
                w += 1                
            end
            k += 1
        end

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

# Teste
minefild = CampoMinado.new(400,400)
minefild.verificaVizinhos()
minefild.radarDeMinas()

for arr in minefild.getGrid do
    for cell in arr do
        puts cell.quantidadeMinas()
    end
end