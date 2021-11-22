require 'ruby2d'
require_relative 'D:\Projetos Com Ruby\Minesweeper\Minesweeper\Game\Entidades\minefild.rb'
require_relative 'D:\Projetos Com Ruby\\Minesweeper\Minesweeper\UI\display.rb'

def setup()

    # Craindo o display
    display = Display.new(450, 450)

    # Setando a window e seu tamanho
    Window.set width: display.getLargura, height: display.getLargura()

    Window.set background: 'white'

    # Colocando o título da tela
    Window.set title: display.getTituloJogo()


    # Criando o campo
    mineFild = CampoMinado.new(400, 400)
    mineFild.verificaVizinhos()
    mineFild.radarDeMinas()

    # Criando o limite do campo
    display.lineDisplay()

    # Desenhando o campo minado
    display.displayCelulas(mineFild)

    # Loop que pega os eventos do mouse 
    on :mouse_down do |event|
        case event.button
            when :left
                display.setHouveEvent(display.mousePressionadoEsquerdo(mineFild, event.x, event.y))
            when :right
                display.setHouveEvent(display.mousePressionadoDireito(mineFild, event.x, event.y))
        end
    end

    # Loop que atualiza o a tela
    update do
        if display.getHouveEvent()
            display.displayCelulas(mineFild)
            if !display.getFinal()
                display.setHouveEvent(false)
            end
            display.win(mineFild.getGrid())
        end 
        if Window.get(:fps) < 10
            Window.close()
        end
    end

    # Apresentado a tela
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

