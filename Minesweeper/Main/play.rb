require 'ruby2d'
require_relative 'D:\Projetos Com Ruby\Minesweeper\Minesweeper\Game\Entidades\minefild.rb'
require_relative 'D:\Projetos Com Ruby\\Minesweeper\Minesweeper\UI\display.rb'

def setup()
    
    display = Display.new(450, 450) 
    mineFild = CampoMinado.new(400, 400)
    mineFild.verificaVizinhos()
    mineFild.radarDeMinas()

    # Setando a window e seu tamanho
    Window.set width: display.getLargura, height: display.getLargura()

    Window.set background: 'white'

    # Colocando o título da tela
    Window.set title: display.getTituloJogo()

    display.lineDisplay()

    display.displayCelulas(mineFild)


    on :mouse_down do |event|
        case event.button
            when :left
                display.setHouveEvent(display.mousePressionadoEsquerdo(mineFild, event.x, event.y))
            when :right
                display.setHouveEvent(display.mousePressionadoDireito(mineFild, event.x, event.y))
        end
    end

    # Loop da tela
    update do
        if (display.getHouveEvent())
            display.displayCelulas(mineFild)
            display.setHouveEvent(false)
        end 
    end

    Window.show
end


def play()
    begin
        setup()
    rescue => exception
        puts exception
    end
end


play()

