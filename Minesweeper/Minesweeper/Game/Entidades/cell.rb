

# Entidade célula do campo minado
class Celula
    attr_accessor :mina, :x, :y, :i, :j, :size, :cor, :quantidadeMinas, :arrayDeVizinhos     
    
    def initialize(i, j, size, deslocamentoX, deslocamentoY)
        @mina = true
        @revelado = false
        @cor = "black"
        @i = i
        @j = j
        @size = size
        @x = i*self.size + deslocamentoX + 2*i
        @y = j*self.size + deslocamentoY + 2*j
        @quantidadeMinas = 0
        @arrayDeVizinhos = Array[]
    end

    def setMina()
        if (rand(10) > 7)
            self.mina = true
        else
            self.mina = false
        end        
    end
    
    # Diz qual é o estado do mouse em relação a cada célula
    def mouseCelulaStatus(x, y)
        return (x > self.x and x < self.x + self.size and y > self.y and y < self.y + self.size)
    end

    def setX(valor)
        self.x = valor
    end
    
    def setY(valor)
        self.y = valor
    end

    def setSize(valor)
        self.size = valor
    end

    def setQuantidadeMinas(valor)
        self.quantidadeMinas = valor
    end

    def setarVizinhos(cell)
       self.arrayDeVizinhos().push(cell)
    end

    def setCor(valor)
        self.cor = valor
    end
    
    def getI()
        return self.i
    end
    
    def getJ()
        return self.j
    end
    
    def getX()
        return self.x
    end

    def getY()
        return self.y
    end
    
    def getMina()
        return self.mina
    end

    def getQuantidadeMinas()
        return self.quantidadeMinas
    end
    
    def getSize()
        return self.size
    end

    def getArrayDeVizinhos()
        return self.arrayDeVizinhos
    end

    def getCor()
        return self.cor
    end
end