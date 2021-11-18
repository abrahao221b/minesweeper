require 'ruby2d'
require_relative 'D:\Projetos Com Ruby\Minesweeper\Minesweeper\Game\Entidades\minefild.rb'

class Display

    attr_accessor :altura, :largura, :background, :tituloTela, :tituloJogo, :houveEvent, :final
    
    def initialize(altura, largura)
        @altura = altura
        @largura = largura
        @tituloTela = 'Game'
        @tituloJogo = 'Campo Minado'
        @houveEvent = false
        @final = false
    end

    def displayCelulas(mineFild)
        i = 0
        mineFild.getLinhas().times do
            j = 0
            mineFild.getColunas().times do
                if (mineFild.getGrid()[i][j].getCor() == "red")
                    s = Square.new(
                        x: mineFild.getGrid()[i][j].getX() + i, y: mineFild.getGrid()[i][j].getY() + j,
                        size: mineFild.getGrid()[i][j].getSize(),
                        color: 'red',
                        z: 0 
                    )
                elsif (mineFild.getGrid()[i][j].getCor() == "black")
                    s = Square.new(
                        x: mineFild.getGrid()[i][j].getX() + i, y: mineFild.getGrid()[i][j].getY() + j,
                        size: mineFild.getGrid()[i][j].getSize(),
                        color: 'black',
                        z: 0 
                    )
                    if mineFild.getGrid()[i][j].getStatus()
                        if !mineFild.getGrid()[i][j].getMina()
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
                            else
                                for cell in mineFild.getGrid[i][j].getArrayDeVizinhos() do
                                   if !cell.getMina() and cell.getCor() == "black"  
                                      cell.setStatus(true)
                                   end
                                end
                            end
                        else
                            Circle.new(
                                x: (mineFild.getGrid()[i][j].getSize()/2) + mineFild.getGrid()[i][j].getX() + i, 
                                y: (mineFild.getGrid()[i][j].getSize()/2) + mineFild.getGrid()[i][j].getY() + j,
                                radius: mineFild.getGrid()[i][j].getSize() / 5,
                                sectors: 50,
                                color: 'green',
                                z: 0
                            )
                            lose(mineFild.getGrid())
                        end
                    end
                end
                j += 1
            end
            i += 1
        end

    end

    def mousePressionadoEsquerdo(mineFild, event_x , event_y)
        for arr in mineFild.getGrid() do
            for cell in arr do
                if (cell.mouseCelulaStatus(event_x, event_y))
                    if (cell.getCor() == "black")
                        cell.setStatus(true)
                        return true
                    end
                end
            end
        end
    end
    
    def mousePressionadoDireito(mineFild, event_x , event_y)
        for arr in mineFild.getGrid() do
            for cell in arr do
                if (cell.mouseCelulaStatus(event_x, event_y))
                    if cell.getCor() == "black" and !cell.getStatus()
                        cell.setCor("red")
                        return true
                    else 
                        cell.setCor("black")
                        return true
                    end
                end
            end
        end
        return true
    end

    def lose(grid)
        Text.new(
            'You Lose!',
            x: 100, y: 200,
            style: 'bold',
            size: 50,
            color: 'yellow',
            rotate: 0,
            z: 0
        )
        
        for arr in grid do
            for cell in arr do
                cell.setStatus(true)
            end
        end

        self.final = true
    end

    def win(grid)
        minasDesativadas = 0
        celulasDescobertas = 0
        
        for arr in grid do
            for cell in arr do
                if cell.getMina()
                    if cell.getCor() == "red"
                        minasDesativadas += 1
                    end                    
                else
                    if cell.getStatus() == true
                        celulasDescobertas += 1
                    end
                end
            end
        end

        if minasDesativadas + celulasDescobertas == 100
            Text.new(
                'You Win!',
                x: 100, y: 200,
                style: 'bold',
                size: 50,
                color: 'green',
                rotate: 0,
                z: 0
            )
            self.final = true
        end
        
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

    def setHouveEvent(valor)
        self.houveEvent = valor
    end

    def getHouveEvent()
        return self.houveEvent
    end

    def getFinal()
        return self.final
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

# teste

# display = Display.new(450, 450)

# # Setando a window e seu tamanho
# Window.set width: display.getLargura, height: display.getLargura()

# Window.set background: 'white'

# # Colocando o título da tela
# Window.set title: display.getTituloJogo()



# mineFild = CampoMinado.new(400, 400)
# mineFild.verificaVizinhos()
# mineFild.radarDeMinas()
# display.lineDisplay()
# display.displayCelulas(mineFild)

# on :mouse_down do |event|
#     case event.button
#         when :left
#             display.setHouveEvent(display.mousePressionadoEsquerdo(mineFild, event.x, event.y))
#         when :right
#             display.setHouveEvent(display.mousePressionadoDireito(mineFild, event.x, event.y))
#     end
# end

# update do
#   puts Window.get(:fps)
#   if display.getHouveEvent()
#     display.displayCelulas(mineFild)
#     if !display.getFinal()
#         display.setHouveEvent(false)
#     end
#     display.win(mineFild.getGrid())
#   end 
# end

# Window.show 