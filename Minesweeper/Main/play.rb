require 'ruby2d'
require_relative 'D:\Projetos Com Ruby\Minesweeper\Minesweeper\Game\Entidades\minefild.rb'
require_relative 'D:\Projetos Com Ruby\Minesweeper\Minesweeper\UI\display.rb'

def setup()
    tools = Array[]
    
    display = Display.new(450, 450) 
    mineFild = CampoMinado.new(400, 400)
    mineFild.verificaVizinhos()
    mineFild.radarDeMinas()

    tools[0] = display
    tools[1] = mineFild
    
    return tools

end

def draw(display, mineFild)
    # Setando a window e seu tamanho
    Window.set width: display.getLargura, height: display.getLargura()

    Window.set background: 'white'

    # Colocando o título da tela
    Window.set title: display.getTituloJogo()
    
    display.lineDisplay()

    display.displayCelulas(mineFild)

    update do
    on :mouse do |event|
        case event.button
        
            when :left
                display.mousePressionadoEsquerdo(mineFild, event.x, event.y)
            when :right
                display.mousePressionadoDireito(mineFild, event.x, event.y)
        end
    end
    display.displayCelulas(mineFild)
    end

    Window.show 
end

ferramentas = setup()

draw(ferramentas[0], ferramentas[1])




