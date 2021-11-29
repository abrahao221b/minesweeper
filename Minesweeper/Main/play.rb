require 'ruby2d'
require_relative 'D:\Projetos Com Ruby\Minesweeper\Minesweeper\Game\Entidades\minefield.rb'
require_relative 'D:\Projetos Com Ruby\Minesweeper\Minesweeper\UI\display.rb'
require_relative 'D:\Projetos Com Ruby\Minesweeper\Minesweeper\UI\menu.rb'
require_relative 'D:\Projetos Com Ruby\Minesweeper\Minesweeper\Game\IA\IA.rb'


def setup()

    Window.set title: 'Campo minado'
    Window.set width: 600, height: 500

    menuWindow()
    Window.show()
end

def menuWindow()
    
    menu = Menu.new()

    menu.criarBotaoTabuleiro8por8()
    menu.criarBotaoTabuleiro10por10()
    menu.criarBotaoTabuleiro16por16()
    menu.criarBotaoTabuleiro20por20()
    menu.criarBotaoSair()

    background = Image.new(
        'D:\Projetos Com Ruby\Minesweeper\Minesweeper\Dados\menuBackground.jpg',
        x: 0, 
        y: 0,
        width: 600, height: 500,
        color: [1.0, 1.0, 1.0, 1.0],
        rotate: 0,
        z: 0
    )

    on :mouse_down do |event|
        case event.button
        when :left
            menu.mousePressionadoEsquerdo(event.x, event.y)
        end
    end
    
    # Loop que atualiza a tela
    update do
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


def gameWindow(menu, display, mineField) 
    
    background = Image.new(
        'D:\Projetos Com Ruby\Minesweeper\Minesweeper\Dados\menuBackground.jpg',
        x: 0, 
        y: 0,
        width: 600, height: 500,
        color: [1.0, 1.0, 1.0, 1.0],
        rotate: 0,
        z: 0
    )

    voltarMenu = false
    
    mineField.verificaVizinhos()
    
    tamanho = display.getTamanho()

    # Veirificando as bombas
    mineField.radarDeMinas()

    display.fieldBackground(tamanho)

    # Construindo os limites do campo
    display.lineDisplay(tamanho)

    display.botaoVoltar()

    # Desenhando o campo minado
    display.displayCelulas(mineField)
    
    
    ia = Ia.new()
    ia.setTabelaDeCelulas(mineField)

    # Loop que captura os eventos do mouse
    on :mouse_down do |event|
        if !display.getEnd() and !ia.getVez()
            case event.button
            when :left
                voltarMenu = display.mousePressionadoEsquerdoNoBotaoVoltar(event.x, event.y)
                display.mousePressionadoEsquerdo(mineField, event.x, event.y)
                ia.buscaCelula(event.x, event.y, mineField)
                ia.setVez(true)
            when :right
                display.mousePressionadoDireito(mineField, event.x, event.y)
                ia.buscaCelula(event.x, event.y, mineField)
                ia.setVez(true)
            end
        end 
        event.button
        voltarMenu = display.mousePressionadoEsquerdoNoBotaoVoltar(event.x, event.y)
    end

    # Loop que atualiza a tela
    update do
        puts Window.get(:fps)
        display.win(mineField, tamanho, ia.getVez())
        if ia.getVez and !display.getEnd()
            ia.fazerJogada(mineField, display, tamanho)
            ia.setVez(false)
        end
        if voltarMenu 
            Window.clear()
            menu.setEncerrarJogo(false)
            ia.setVez(false)
            ObjectSpace.define_finalizer(self, proc { display.self_destruct! })
            ObjectSpace.define_finalizer(self, proc { mineField.self_destruct! })
            ObjectSpace.define_finalizer(self, proc { menu.self_destruct! })
            menuWindow()    
        end
    end
   
end

# def play()
#     begin
#         setup()
#     rescue => exception
#         puts exception
#     end
# end


# play()
setup()