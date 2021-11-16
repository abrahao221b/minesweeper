require 'ruby2d'
require_relative 'D:\Projetos Com Ruby\Minesweeper\Minesweeper\Game\Entidades\minefild.rb'

class Display

    attr_accessor :altura, :largura, :background, :tituloTela, :tituloJogo, :cells
    
    def initialize(altura, largura)
        @altura = altura
        @largura = largura
        @tituloTela = 'Game'
        @tituloJogo = 'Campo Minado'
        @cells = Array[]
    end

    def displayCelulas(mineFild)
        i = 0
        mineFild.getColunas().times do
            j = 0
            mineFild.getLinhas().times do
                s = Square.new(
                    x: mineFild.getGrid()[i][j].getX() + i, y: mineFild.getGrid()[i][j].getY() + j,
                    size: mineFild.getGrid()[i][j].getSize(),
                    color: 'black',
                    z: 0 
                )
                if mineFild.getGrid()[i][j].getStatus()
                    if mineFild.getGrid[i][j].getMina()
                        Circle.new(
                            x: (mineFild.getGrid()[i][j].getSize()/2) + mineFild.getGrid()[i][j].getX() + i, 
                            y: (mineFild.getGrid()[i][j].getSize()/2) + mineFild.getGrid()[i][j].getY() + j,
                            radius: mineFild.getGrid()[i][j].getSize() / 5,
                            sectors: 50,
                            color: 'green',
                            z: 0
                        )
                    else
                        Square.new(
                            x: mineFild.getGrid()[i][j].getX() + i, y: mineFild.getGrid()[i][j].getY() + j,
                            size: mineFild.getGrid()[i][j].getSize(),
                            color: 'blue',
                            z: 0 
                        )

                        if mineFild.getGrid()[i][j].getQuantidadeMinas() > 0
                            Text.new(
                                String(mineFild.getGrid()[i][j].getQuantidadeMinas()),
                                x: (mineFild.getGrid()[i][j].getSize()/3) + mineFild.getGrid()[i][j].getX() + i, 
                                y: (mineFild.getGrid()[i][j].getSize()/4) + mineFild.getGrid()[i][j].getY() + j,
                                style: 'bold',
                                size: mineFild.getGrid()[i][j].getSize() / 2,
                                color: 'black',
                                rotate: 0,
                                z: 0
                            )
                        end
                        

                    end
                end
                j += 1
            end
            i += 1
        end

    end

    def mousePressionado(grid, event_x , event_y)
        for arr in grid do
            for cell in arr do
                if (cell.mouseCelulaStatus(event_x, event_y))
                    cell.setStatus(true)
                end
            end
        end
    end

    def final(grid)
        for arr in grid do
            for cell in arr do
                if (cell.getMina() and cell.getStatus())
                    lose(grid)
                end
            end
        end
    end

    def lose(grid)
        Window.set title: "You lose!"
        i = 0
        grid.getColunas().times do
            j = 0
            grid.getLinhas().times do
                grid[i][j].setStatus(true)
                j += 1
            end
            i += 1
        end
        k = 500
        k.times do
            displayCelulas(grid)
        end
        return
    end
    

    def lineDisplay()
        Line.new(
            x1: 15, y1:30,
            x2: 432, y2: 30,
            width: 5,
            color: 'black',
            z: 0
        )
        Line.new(
            x1: 18, y1: 30,
            x2: 18, y2: 442,
            width: 5,
            color: 'black',
            z: 0
        )
        Line.new(
            x1: 430, y1: 30,
            x2: 430, y2: 442,
            width: 5,
            color: 'black',
            z: 0
        )
        Line.new(
            x1: 15, y1: 442,
            x2: 432, y2: 442,
            width: 5,
            color: 'black',
            z: 0
        )
    end
    

    def getLargura()
        return self.altura
    end

    def getAltura()
        return self.altura
    end
    
    def getTituloTela()
        return self.tituloTela
    end
    
    def getTituloJogo()
        return self.tituloJogo
    end

    def getBackGround()
        return self.background
    end

end

display = Display.new(450, 450)

# Setando a window e seu tamanho
Window.set width: display.getLargura, height: display.getLargura()

Window.set background: 'white'

# Colocando o título da tela
Window.set title: display.getTituloJogo()


mineFild = CampoMinado.new(400, 400)
mineFild.verificaVizinhos()
mineFild.radarDeMinas()
display.lineDisplay()

update do
  display.displayCelulas(mineFild)
  on :mouse do |event|
    case event.button
    
        when :left
            display.mousePressionado(mineFild.getGrid(), event.x, event.y)
            # display.final(mineFild.getGrid())
        when :right

    end

  end
end

Window.show 