require 'ruby2d'
require 'ostruct'
require_relative '/Minesweeper/Minesweeper/UI/display.rb'

class Menu

    attr_accessor :jogo8por8, :jogo10por10, :jogo16por16, :jogo20por20, :encerrarJogo, :habilitarIA, :botaoPositions, :comando
    
    def initialize()
        @jogo8por8 = false
        @jogo10por10 = false
        @jogo16por16 = false
        @jogo20por20 = false
        @encerrarJogo = false
        @habilitarIA = false
        @comando = {tabuleiro8: 'tabuleiro 8×8', tabuleiro10: 'tabuleiro 10×10', 
            tabuleiro16: 'tabuleiro 16×16', tabuleiro20: 'tabuleiro 20×20', habilitarIA: 'habilitarIA', encerrarJogo: 'encerrarJogo'}
        @botaoPositions = {tabuleiro8: [70, 202, 90, 140], tabuleiro10: [70, 202, 160, 210],
            tabuleiro16: [70, 202, 230, 280], tabuleiro20: [70, 202, 300, 350], habilitarIA: [70, 202, 30, 80], encerrarJogo: [105, 165, 365, 425]}
    end


    def mousePressionadoEsquerdo(event_x , event_y)
        
        keys = self.botaoPositions.keys

        for i in 0..5 do
            if (event_x > self.botaoPositions[keys[i]][0]  and event_x < self.botaoPositions[keys[i]][1] and 
                event_y > self.botaoPositions[keys[i]][2]  and event_y < self.botaoPositions[keys[i]][3])
                menuAction(String(keys[i])) 
            end
        end
    end

    def menuAction(action)
        case 
        when String(self.comando.key('tabuleiro 8×8')) == action 
            self.jogo8por8 = true
        when String(self.comando.key('tabuleiro 10×10')) == action
            self.jogo10por10 = true
        when String(self.comando.key('tabuleiro 16×16')) == action
            self.jogo16por16 = true
        when String(self.comando.key('tabuleiro 20×20')) == action
            self.jogo20por20 = true
        when String(self.comando.key('habilitarIA')) == action
            if !self.habilitarIA
               self.habilitarIA = true 
            else
               self.habilitarIA = false
            end
        when String(self.comando.key('encerrarJogo')) == action
            self.encerrarJogo = true
        end
    end

    def criarBotaoHabilitarIA()
        Rectangle.new(
            x: 70, 
            y: 30,
            width: 132,
            height: 50,
            color: 'red',
            z: 1
        )

        Text.new(
            "Habilitar IA",
            x: 90, 
            y: 45,
            style: 'bold',
            size: 15,
            color: 'black',
            rotate: 0,
            z: 1
        ) 
    end

    def criarBotaoTabuleiro8por8()
        Rectangle.new(
            x: 70, 
            y: 90,
            width: 132,
            height: 50,
            color: 'red',
            z: 1
        )

        Text.new(
            "Tabuleiro 8×8",
            x: 83, 
            y: 105,
            style: 'bold',
            size: 15,
            color: 'black',
            rotate: 0,
            z: 1
        ) 
    end
    
    def criarBotaoTabuleiro10por10()
        Rectangle.new(
            x: 70, 
            y: 160,
            width: 132,
            height: 50,
            color: 'red',
            z: 1
        )

        Text.new(
            "Tabuleiro 10×10",
            x: 78, 
            y: 175,
            style: 'bold',
            size: 15,
            color: 'black',
            rotate: 0,
            z: 1
        ) 
        
    end

    def criarBotaoTabuleiro16por16()
        Rectangle.new(
            x: 70, 
            y: 230,
            width: 132,
            height: 50,
            color: 'red',
            z: 1
        )

        Text.new(
            "Tabuleiro 16×16",
            x: 78, 
            y: 245,
            style: 'bold',
            size: 15,
            color: 'black',
            rotate: 0,
            z: 1
        ) 
        
    end

    def criarBotaoTabuleiro20por20()
        Rectangle.new(
            x: 70, 
            y: 300,
            width: 132,
            height: 50,
            color: 'red',
            z: 1
        )

        Text.new(
            "Tabuleiro 20×20",
            x: 78, 
            y: 315,
            style: 'bold',
            size: 15,
            color: 'black',
            rotate: 0,
            z: 1
        ) 
        
    end
    
    def criarBotaoSair()
        Circle.new(
            x: 135, y: 395,
            radius: 30,
            sectors: 8,
            color: 'red',
            z: 1
        )

        Text.new(
            "Sair",
            x: 120, 
            y: 384,
            style: 'bold',
            size: 15,
            color: 'white',
            rotate: 0,
            z: 1
        )
    end

    def setJogo8por8(valor)
        self.jogo8por8 = valor
    end

    def setJogo10por10(valor)
        self.jogo10por10 = valor
    end

    def setJogo16por16(valor)
        self.jogo16por16 = valor
    end

    def setJogo20por20(valor)
        self.jogo20por20 = valor
    end

    def setHabilitarIA(valor)
        self.habilitarIA = valor
    end

    def setEncerrarJogo(valor)
        self.encerrarJogo = valor
    end

    def getJogo8por8()
        return self.jogo8por8
    end

    def getJogo10por10()
        return self.jogo10por10
    end

    def getJogo16por16()
        return self.jogo16por16
    end

    def getJogo20por20()
        return self.jogo20por20
    end
    
    def getEncerrarJogo()
        return self.encerrarJogo
    end

    def getHabilitarIA()
        return self.habilitarIA
    end
    
    def getComando()
        return self.comando
    end
    
end