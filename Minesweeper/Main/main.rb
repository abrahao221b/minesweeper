require 'ruby2d'
require_relative '/Minesweeper/Minesweeper/Game/Entidades/minefield.rb'
require_relative '/Minesweeper/Minesweeper/UI/display.rb'
require_relative '/Minesweeper/Minesweeper/UI/menu.rb'
require_relative '/Minesweeper/Minesweeper/Game/IA/IA.rb'

# Função de setup
def setup()
    Window.set title: 'Campo minado'
    Window.set width: 600, height: 500

    # Iniciando o menu
    menuWindow()
    # Chamando todas as telas
    Window.show()
end

def menuWindow()
    
    menu = Menu.new()

    menu.criarBotaoTabuleiro8por8()
    menu.criarBotaoTabuleiro10por10()
    menu.criarBotaoTabuleiro16por16()
    menu.criarBotaoTabuleiro20por20()
    menu.criarBotaoHabilitarIA()
    menu.criarBotaoSair()

    background = Image.new(
        '/Minesweeper/Dados/menuBackground.jpg',
        x: 0, 
        y: 0,
        width: 600, height: 500,
        color: [1.0, 1.0, 1.0, 1.0],
        rotate: 0,
        z: 0
    )

    arrayIA = Array[]

    # Loop que pega os eventos do mouse
    on :mouse_down do |event|
        case event.button
        when :left
            menu.mousePressionadoEsquerdo(event.x, event.y)
        end
    end

    # Loop que atualiza a tela de menu
    update do
        if menu.getHabilitarIA()
            while !arrayIA.empty? 
                arrayIA.shift().remove
            end            
            retangulo1 = Rectangle.new x: 220, y: 30, width: 112, height: 20, color:'white', z: 0
            text1 = Text.new("IA habilitada", style: 'bold', x:224, y:35, size: 12, color: 'green', z: 0)
            arrayIA.push(retangulo1)
            arrayIA.push(text1)
        else
            while !arrayIA.empty? 
                arrayIA.shift().remove
            end
            retangulo2 = Rectangle.new x: 220, y: 30, width: 112, height: 20, color:'white', z: 0
            text2 = Text.new("IA não habilitada", x:224, y:35, style: 'bold', size: 12, color: 'red', z: 0)
            arrayIA.push(retangulo2)
            arrayIA.push(text2)
        end
        
        if menu.getJogo8por8()
            Window.clear()
            menu.setJogo8por8(false)
            display, mineField = gameConstrutores(8)
            gameWindow(menu, display, mineField) 
        elsif menu.getJogo10por10()
            Window.clear()
            menu.setJogo10por10(false)
            display, mineField = gameConstrutores(10)
            gameWindow(menu, display, mineField)
        elsif menu.getJogo16por16()
            Window.clear()
            menu.setJogo16por16(false)
            display, mineField = gameConstrutores(16)
            gameWindow(menu, display, mineField)
        elsif menu.getJogo20por20()
            Window.clear()
            menu.setJogo20por20(false)
            display, mineField = gameConstrutores(20)
            gameWindow(menu, display, mineField)
        elsif menu.getEncerrarJogo()
            Window.close()
        end
    end
    
end

def gameConstrutores(tamanho)
    display = Display.new(400, 400, tamanho)
    mineField = CampoMinado.new(400, 400, tamanho, 100, 30)
    return display, mineField
end

# Função da game window
def gameWindow(menu, display, mineField) 
    
    # Variável para o tempo
    $fps = Window.get(:fps)

    background = Image.new(
        '/Minesweeper/Dados/menuBackground.jpg',
        x: 0, 
        y: 0,
        width: 600, height: 500,
        color: [1.0, 1.0, 1.0, 1.0],
        rotate: 0,
        z: 0
    )

    voltarMenu = false

    vezJogador = true
    
    mineField.verificaVizinhos()
    
    tamanho = display.getTamanho()

    # Veirificando as bombas
    mineField.radarDeMinas()

    display.fieldBackground(tamanho)

    # Construindo os limites do campo
    display.lineDisplay(tamanho)

    # Criando o botão de voltar
    display.botaoVoltar()

    # Desenhando o campo minado
    display.displayCelulas(mineField)
    
    ia = Ia.new()
    ia.setTabelaDeCelulas(mineField)
    naoHabilitado = false

    if !menu.getHabilitarIA()
        naoHabilitado = true 
    end
    
    iterationJogo = 0

    # Loop que captura os eventos do mouse
    on :mouse_down do |event|
        if naoHabilitado
            menu.setHabilitarIA(false)
        end
        if !display.getEnd() and !ia.getVez() and vezJogador
            case event.button
            when :left
                voltarMenu = display.mousePressionadoEsquerdoNoBotaoVoltar(event.x, event.y)
                display.mousePressionadoEsquerdo(mineField, event.x, event.y)
                if menu.getHabilitarIA()
                    vezJogador = false
                    iterationJogo = 0
                    ia.atualizarHash(mineField)
                    ia.setVez(true)
                end
            when :right
                display.mousePressionadoDireito(mineField, event.x, event.y)
                if menu.getHabilitarIA()
                    vezJogador = false
                    iterationJogo = 0
                    ia.atualizarHash(mineField)
                    ia.setVez(true)
                end
            end
        end 
        event.button
        voltarMenu = display.mousePressionadoEsquerdoNoBotaoVoltar(event.x, event.y)
    end

    # arrays para eliminar objetos gráficos
    arrayTime_box = Array[]
    arrayTime_text = Array[]
    arrayTime_TempoJogo = Array[]
    
    #variáveis de tempo 
    timerTempojogo = 10
    sec = 0
    min = 0
    hour = 0

    # Loop que atualiza a tela do jogo
    update do
        if !display.getEnd()
            timer = 0.+((sec)./($fps)).to_f.round(0)
            arrayTime_box[sec] = Rectangle.new( x: 0, y: 0, width: 110, height: 20, color:'white', z: 0)
            arrayTime_text[sec] = Text.new("Time #{hour}:#{min}:#{timer}", style: 'bold', size: 15, color: 'red', z: 0)

            # zerando o timer dos jogos
            if menu.getHabilitarIA()
                if timerTempojogo <= 0
                    iterationJogo = 0
                    if vezJogador
                        ia.setVez(true)
                        vezJogador = false
                    end
                end
                timerTempojogo = 10.-((iterationJogo)./($fps)).to_f.round(0)
                iterationJogo += 1
                arrayTime_TempoJogo[sec] = Text.new("Time-jogada: #{timerTempojogo}", x:120, y:0, style: 'bold', size: 15, color: 'red', z: 0)
            end
            
            if timer > 59
                sec = 0
                min += 1
            end

            if min > 59
                sec = 0
                min = 0
                hour += 1
            end

            if hour == 24
                voltarMenu = true    
            end
        end

        # Verificando se o jogador ganhou
        display.win(mineField, tamanho, ia.getVez(), menu.getHabilitarIA())
        
        if menu.getHabilitarIA()
            # chamando os métodos da IA
            if ia.getVez and !display.getEnd()
                ia.fazerJogada(mineField, display, tamanho)
                ia.setVez(false)
                iterationJogo = 0
                vezJogador = true
            end
        end
        
        # Setup antes de voltar ao menu
        if voltarMenu 
            Window.clear()
            menu.setEncerrarJogo(false)
            ia.setVez(false)
            vezJogador = false
            menu.setHabilitarIA(false)
            ObjectSpace.define_finalizer(self, proc { display.self_destruct! })
            ObjectSpace.define_finalizer(self, proc { mineField.self_destruct! })
            ObjectSpace.define_finalizer(self, proc { ia.self_destruct! })
            ObjectSpace.define_finalizer(self, proc { menu.self_destruct! })
            menuWindow()    
        end 

        # Apagando objetos gráficos guardados nos arrays 
        if sec > 0 and !display.getEnd()
            arrayTime_box[sec - 1].remove
            arrayTime_text[sec - 1].remove
            
            if menu.getHabilitarIA 
                arrayTime_TempoJogo[sec - 1].remove
            end
        end
        
        sec += 1
    end
   
end

# Função play
def play()
    begin
        setup()
    rescue => exception
        puts exception
    end
end

play()