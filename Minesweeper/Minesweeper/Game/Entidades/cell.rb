require 'ruby2d'

# Entidade célula do campo minado
class Celula
    attr_accessor :mina, :revelado, :x, :y, :size, :numeroMinas     
    
    def initialize(x, y, size)
        @mina = true
        @revelado = false
        @numeroMinas = 0
        @x = x
        @y = y
        @size = size
    end

    def setMina()
        if (rand(10) < 5)
            self.mina = true
        else
            self.mina = false
        end        
    end

    def setStatus(valor)
        self.revelado = valor
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
    
    def getX()
        return self.x
    end

    def getY()
        return self.y
    end
    
    def getMina()
        return self.mina
    end

    def getStatus()
        return self.revelado
    end

    def getNumeroMinas()
        return self.numeroMinas
    end
    
    def getSize()
        return self.size
    end

end