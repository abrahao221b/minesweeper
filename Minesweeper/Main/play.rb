require 'ruby2d'
require_relative 'D:\Projetos Com Ruby\Minesweeper\Minesweeper\Game\Entidades\minefield.rb'
require_relative 'D:\Projetos Com Ruby\Minesweeper\Minesweeper\UI\display.rb'
require_relative 'D:\Projetos Com Ruby\Minesweeper\Minesweeper\UI\menu.rb'


def setup()
    menu = Menu.new()
    display, mineField = novoDisplay()

    Window.set title: 'Campo minado'
    Window.set width: 600, height: 450

    menuWindow(menu, display, mineField, false)
    Window.show()
end

def menuWindow(menu, display, mineField, novoMenu)
    
    if !novoMenu
        menu.criarBotaoIniciar()
        menu.criarBotaoRestart()
        menu.criarBotaoSair()
    else 
        menu.criarBotaoRestart()
        menu.criarBotaoSair()
    end

    background = Image.new(
        'D:\Projetos Com Ruby\Minesweeper\Minesweeper\Dados\menuBackground.jpg',
        x: 0, 
        y: 0,
        width: 600, height: 450,
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
        if menu.getIniciar() and !menu.getNovoJogo()
            menu.setNovoJogo(true)
            Window.clear()
            gameWindow(menu, display, mineField, true) 
        elsif menu.getRestart() and menu.getNovoJogo()
            menu.setRestart(false)
            Window.clear()
            newDisplay, newMineField = novoDisplay()
            gameWindow(menu, newDisplay, newMineField, true)
        elsif menu.getEncerrarJogo()
            Window.close()
        end
    end
    
end

def novoDisplay()
    display = Display.new(400, 400)
    mineField = CampoMinado.new(400, 400)
    
    return display, mineField
end

def gameWindow(menu, display, mineField, podeMexer) 
    
    background = Image.new(
        'D:\Projetos Com Ruby\Minesweeper\Minesweeper\Dados\menuBackground.jpg',
        x: 0, 
        y: 0,
        width: 600, height: 450,
        color: [1.0, 1.0, 1.0, 1.0],
        rotate: 0,
        z: 0
    )

    voltarMenu = false
    
    mineField.verificaVizinhos()
    
    # Veirificando as bombas
    mineField.radarDeMinas()

    display.fieldBackground()

    # Construindo os limites do campo
    display.lineDisplay()

    display.botaoVoltar()

    # Desenhando o campo minado
    display.displayCelulas(mineField)
    
    
    # Loop que captura os eventos do mouse
    on :mouse_down do |event|
        if !display.getEnd() and podeMexer
            case event.button
            when :left
                display.mousePressionadoEsquerdo(mineField, event.x, event.y)
                voltarMenu = display.mousePressionadoEsquerdoNoBotaoVoltar(event.x, event.y)
            when :right
                display.mousePressionadoDireito(mineField, event.x, event.y)
            end
        end 
        if podeMexer
            event.button
            voltarMenu = display.mousePressionadoEsquerdoNoBotaoVoltar(event.x, event.y)
        end
    end

    # Loop que atualiza a tela
    update do
        puts Window.get(:fps)
        display.win(mineField)
        if voltarMenu
            podeMexer = false
            Window.clear()
            menu.setIniciar(false)
            menu.setSair(false)
            menuWindow(menu, display, mineField, true)
        end
    end
end

def play()
    begin
        setup()
    rescue => exception
        puts exception
    end
end


play()
