require_relative "cell.rb"

# Entidade campo minado
class CampoMinado

    attr_accessor :altura, :largura, :tamanho, :celulaSize, :deslocamentoX, :deslocamentoY, :colunas, :linhas, :grid, :celulasDescobertas

    def initialize(altura, largura, tamanho, deslocamentoX, deslocamentoY)
        @altura = altura
        @largura = largura
        @celulasDescobertas = 0
        @tamanho = tamanho
        @deslocamentoX = deslocamentoX
        @deslocamentoY = deslocamentoY
        if tamanho == 8
            @celulaSize = 50
        elsif tamanho == 10
            @celulaSize = 40
        elsif tamanho == 16
            @celulaSize = 25
        elsif tamanho == 20
            @celulaSize = 20
        end
        @linhas = self.altura / celulaSize
        @colunas =  self.largura / celulaSize
        @grid = criarArray2D()              
    end

    # Retorna a matriz do campo minado
    def criarArray2D()
        grid = Array.new(self.colunas){Array.new(self.linhas)}
        k = 0
        self.linhas.times do
            w = 0 
            self.colunas.times do
                grid[k][w] = Celula.new(k, w, self.celulaSize, deslocamentoX, deslocamentoY)
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
        for arr in self.grid do
            for cell in arr do
                if(cell.getMina()) 
                    cell.setQuantidadeMinas(-1) 
                end
                total = 0
                for i in cell.getArrayDeVizinhos() do
                    if i.getMina() 
                        total += 1
                    end
                end
                cell.setQuantidadeMinas(total)
            end    
        end
    end

    def setCelulasDescobertas(valor)
        self.celulasDescobertas = valor
    end
    
    def getCelulasDescobertas()
        return self.celulasDescobertas
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