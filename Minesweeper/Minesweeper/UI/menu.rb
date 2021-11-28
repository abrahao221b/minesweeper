require 'ruby2d'
require 'ostruct'
require_relative 'D:\Projetos Com Ruby\Minesweeper\Minesweeper\UI\display.rb'

class Menu

    attr_accessor :iniciar, :novoJogo, :restart, :encerrarJogo, :botaoPositions, :comando
    
    def initialize()
        @iniciar = false
        @novoJogo = false
        @restart = false
        @encerrarJogo = false
        @comando = {iniciar: 'iniciar', restart: 'restart', encerrarJogo: 'encerrarJogo'}
        @botaoPositions = {iniciar: [70, 170, 120, 170], restart: [70, 170, 190, 240], encerrarJogo: [92, 144, 275, 328]}
    end


    def mousePressionadoEsquerdo(event_x , event_y)
    
        keys = self.botaoPositions.keys    

        for i in 0..2 do
            if (event_x > self.botaoPositions[keys[i]][0]  and event_x < self.botaoPositions[keys[i]][1] and 
                event_y > self.botaoPositions[keys[i]][2]  and event_y < self.botaoPositions[keys[i]][3])
                menuAction(String(keys[i])) 
            end
        end
    end

    def menuAction(action)
        case 
        when String(self.comando.key('iniciar')) == action 
            botaoIniciarAction()
        when String(self.comando.key('restart')) == action
            botaoRestartAction()
        when String(self.comando.key('encerrarJogo')) == action
            botaoSairAction()
        end
    end
    

    def criarBotaoIniciar()
        Rectangle.new(
            x: 70, 
            y: 120,
            width: 100,
            height: 50,
            color: 'red',
            z: 1
        )

        Text.new(
            "Iniciar",
            x: 98, 
            y: 135,
            style: 'bold',
            size: 15,
            color: 'black',
            rotate: 0,
            z: 1
        ) 
    end
    
    def criarBotaoRestart()
        Rectangle.new(
            x: 70, 
            y: 190,
            width: 100,
            height: 50,
            color: 'red',
            z: 1
        )

        Text.new(
            "Restart",
            x: 93, 
            y: 205,
            style: 'bold',
            size: 15,
            color: 'black',
            rotate: 0,
            z: 1
        ) 
        
    end
    
    def criarBotaoSair()
        Circle.new(
            x: 118, y: 300,
            radius: 30,
            sectors: 8,
            color: 'red',
            z: 1
        )

        Text.new(
            "Sair",
            x: 103, 
            y: 291,
            style: 'bold',
            size: 15,
            color: 'white',
            rotate: 0,
            z: 1
        )
    end
    
    def botaoIniciarAction()
       self.iniciar = true
    end

    def botaoRestartAction()
        self.restart = true
    end
    
    def botaoSairAction()
        self.encerrarJogo = true
    end

    def setNovoJogo(valor)
        self.novoJogo = valor
    end

    def setIniciar(valor)
        self.iniciar = valor
    end
    
    def setRestart(valor)
        self.restart = valor
    end

    def setSair(valor)
        self.encerrarJogo = valor
    end
    

    def getIniciar()
        return self.iniciar
    end
    
    def getEncerrarJogo()
        return self.encerrarJogo
    end
        
    def getNovoJogo()
        return self.novoJogo
    end
    
    def getRestart()
        return self.restart
    end

    def getBotaoIniciar()
        return self.botaoIniciar
    end
    
    def getBotaoRestart()
        return self.botaoRestart
    end
    
    def getBotaoSair()
        return self.botaoSair
    end

    def getBackground()
        return self.background
    end

    def getTituloTela()
        return self.tituloTela
    end
    
    def getTituloJogo()
        return self.tituloJogo
    end
    
    def getComando()
        return self.comando
    end
    
end