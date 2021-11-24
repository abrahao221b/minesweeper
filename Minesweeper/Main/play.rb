require 'ruby2d'
require_relative 'D:\Projetos Com Ruby\Minesweeper\Minesweeper\Game\Entidades\minefild.rb'
require_relative 'D:\Projetos Com Ruby\MinesweeperTestes\Minesweeper\Minesweeper\UI\display.rb'

def setup()

    display = Display.new(450, 450)

    # Setando a window e seu tamanho
    Window.set width: display.getLargura, height: display.getLargura()

    Window.set background: 'white'

    # Colocando o título da tela
    Window.set title: display.getTituloJogo()


    # Criando o campo
    mineField = CampoMinado.new(400, 400)
    mineField.verificaVizinhos()
    mineField.radarDeMinas()

    # Construindo os limites do campo
    display.lineDisplay()

    # Desenhando o campo minado
    display.displayCelulas(mineField)

    # Loop que captura os eventos do mouse
    on :mouse_down do |event|
        if !display.getEnd()
            case event.button
            when :left
                display.mousePressionadoEsquerdo(mineField, event.x, event.y)
            when :right
                display.mousePressionadoDireito(mineField, event.x, event.y)
            end
        end 
    end

    # Loop que atualizando a tela
    update do
        display.win(mineField)
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

