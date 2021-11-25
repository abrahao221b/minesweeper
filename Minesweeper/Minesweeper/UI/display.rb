require 'ruby2d'
require 'ostruct'
require_relative 'D:\Projetos Com Ruby\Minesweeper\Minesweeper\Game\Entidades\minefield.rb'

class Display

    attr_accessor :altura, :largura, :background, :tituloTela, :tituloJogo, :end
    
    def initialize(altura, largura)
        @altura = altura
        @largura = largura
        @tituloTela = 'Game'
        @tituloJogo = 'Campo Minado'
        @end = false
    end

    def displayCelulas(mineField)
        for arr in mineField.getGrid() do
            for cell in arr do
                printarCorPreta(mineField, cell.getI(), cell.getJ())
            end
        end
    end

    def atualizarCampo(mineField, row, column)
        if (mineField.getGrid[row][column].getCor() == "black")
            if !mineField.getGrid[row][column].getMina() 
                printarCorAzul(mineField, row, column)
                mineField.getGrid[row][column].setCor("blue")
                
                if mineField.getGrid[row][column].getQuantidadeMinas() > 0
                    printarNumeroBombas(mineField, row, column)
                    mineField.setCelulasDescobertas(mineField.getCelulasDescobertas() + 1)
                else
                    pairVector = especialCase(mineField.getGrid[row][column], mineField)
                    for i in pairVector do
                        mineField.getGrid[i[0]][i[1]].setCor("blue")
                        mineField.setCelulasDescobertas(mineField.getCelulasDescobertas() + 1)
                        printarCorAzul(mineField, i[0], i[1])
                        if mineField.getGrid[i[0]][i[1]].getQuantidadeMinas() > 0
                          printarNumeroBombas(mineField, i[0], i[1])
                        end
                    end
                end
            else
                loose(mineField)
            end
        end
    end

    def printarCorPreta(mineField, row, column)
        s = Square.new(
            x: mineField.getGrid[row][column].getX() + mineField.getGrid[row][column].getI(), 
            y: mineField.getGrid[row][column].getY() + mineField.getGrid[row][column].getJ(),
            size: mineField.getGrid[row][column].getSize(),
            color: 'black',
            z: 0
        )
    end
    
    
    def printarCorVermelha(mineField, row, column)
        Image.new(
            'D:\Projetos Com Ruby\MinesweeperTestes\Minesweeper\Minesweeper\Dados\flag.png',
            x: (mineField.getGrid[row][column].getSize()/4) + mineField.getGrid[row][column].getX(), 
            y: (mineField.getGrid[row][column].getSize()/4) + mineField.getGrid[row][column].getY(),
            width: 30, height: 30,
            color: [1.0, 1.0, 1.0, 1.0],
            rotate: 0,
            z: 0
        )
    end

    def printarCorAzul(mineField, row, column)
        Square.new(
            x: mineField.getGrid[row][column].getX() + mineField.getGrid[row][column].getI(), 
            y: mineField.getGrid[row][column].getY() + mineField.getGrid[row][column].getJ(),
            size: mineField.getGrid[row][column].getSize(),
            color: 'blue',
            z: 0 
        )
    end
    
    def printarNumeroBombas(mineField, row, column)
        Text.new(
            String(mineField.getGrid[row][column].getQuantidadeMinas()),
            x: (mineField.getGrid[row][column].getSize()/3) + mineField.getGrid[row][column].getX() + mineField.getGrid[row][column].getI(), 
            y: (mineField.getGrid[row][column].getSize()/4) + mineField.getGrid[row][column].getY() + mineField.getGrid[row][column].getJ(),
            style: 'bold',
            size: mineField.getGrid[row][column].getSize() / 2,
            color: 'black',
            rotate: 0,
            z: 0
        )
    end
    
    def printarBomba(mineField, row, column)
        Square.new(
            x: mineField.getGrid[row][column].getX() + mineField.getGrid[row][column].getI(), 
            y: mineField.getGrid[row][column].getY() + mineField.getGrid[row][column].getJ(),
            size: mineField.getGrid[row][column].getSize(),
            color: 'green',
            z: 0 
        )
        bomb = Sprite.new(
            'D:\Projetos Com Ruby\MinesweeperTestes\Minesweeper\Minesweeper\Dados\bomoSpriteNew.png',
            x: (mineField.getGrid[row][column].getSize()/4) + mineField.getGrid[row][column].getX() + mineField.getGrid[row][column].getI(), 
            y: (mineField.getGrid[row][column].getSize()/4) + mineField.getGrid[row][column].getY() + mineField.getGrid[row][column].getJ(),
            width: 20,
            height: 20,
            rotate: 90,
            clip_width: 80,
            time: 30,
            loop: true,
            z: 0
        )
        bomb.play
    end
    

    def mousePressionadoEsquerdo(mineField, event_x , event_y)
        for arr in mineField.getGrid() do
            for cell in arr do
                if (cell.mouseCelulaStatus(event_x, event_y))
                    if cell.getCor() == "black"
                        atualizarCampo(mineField, cell.getI(), cell.getJ())
                    end
                end
            end
        end
    end
    
    def mousePressionadoDireito(mineField, event_x , event_y)
        for arr in mineField.getGrid() do
            for cell in arr do
                if (cell.mouseCelulaStatus(event_x, event_y))
                    if cell.getCor() == "black"
                        if cell.getMina()
                            mineField.setCelulasDescobertas(mineField.getCelulasDescobertas() + 1) 
                        end
                        cell.setCor("red")
                        printarCorVermelha(mineField, cell.getI(), cell.getJ())
                    elsif cell.getCor() == "red"
                        if cell.getMina()
                            mineField.setCelulasDescobertas(mineField.getCelulasDescobertas() - 1)
                        end
                        cell.setCor("black")
                        printarCorPreta(mineField, cell.getI(), cell.getJ())
                    end
                end
            end
        end 
    end

    # Caso especial celula com nenhuma bomba ao redor, usando BST (Binary Search Tree)
    def especialCase(cell, mineField)
        
        indexI = cell.getI()
        indexJ = cell.getJ()

        pair = OpenStruct.new
        visitado = Array.new(10){Array.new(10)}
        pairVector = Array[]
        
        list = Array[]
       
        for i in 0..9 do
            for j in 0..9 do
                visitado[i][j] = false
            end
        end
        
        visitado[indexI][indexJ] = true
        pair = [indexI, indexJ]
        list.push(pair)
        
        while !list.empty?
            pair = list.shift()
            if !mineField.getGrid()[pair[0]][pair[1]].getMina()
                pairVector.push(pair)
                if mineField.getGrid()[pair[0]][pair[1]].getQuantidadeMinas() == 0 
                    neighbors = mineField.getGrid()[pair[0]][pair[1]].getArrayDeVizinhos()
                    for i in neighbors do
                        if visitado[i.getI()][i.getJ()] == false and mineField.getGrid()[i.getI()][i.getJ()].getCor() == "black"
                            pair = [i.getI(), i.getJ()]
                            list.push(pair)
                            visitado[i.getI()][i.getJ()] = true 
                        end
                    end
                end
            end
        end
   
        return pairVector
    end
    

    def loose(mineField)
        Text.new(
            'You Lose!',
            x: 100, y: 200,
            style: 'bold',
            size: 50,
            color: 'yellow',
            rotate: 0,
            z: 1
        )
        
        for arr in mineField.getGrid() do
            for cell in arr do
                if cell.getMina()
                   printarBomba(mineField, cell.getI(), cell.getJ()) 
                end
            end
        end
        self.end = true
    end

    # Verifica se o jogador ganhou
    def win(mineField)
        if mineField.getCelulasDescobertas() == 100
            Text.new(
                'You Win!',
                x: 100, y: 200,
                style: 'bold',
                size: 50,
                color: 'green',
                rotate: 0,
                z: 0
            )
            self.end = true
        end
    end
    
    # Printa os limites do campo
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

    def getEspecialCase()
        return self.especialCase
    end
    
    def getEnd()
        return self.end
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

# # teste

# display = Display.new(450, 450)

# # Setando a window e seu tamanho
# Window.set width: display.getLargura, height: display.getLargura()

# Window.set background: 'white'

# # Colocando o título da tela
# Window.set title: display.getTituloJogo()



# mineField = CampoMinado.new(400, 400)
# mineField.verificaVizinhos()
# mineField.radarDeMinas()
# display.lineDisplay()
# display.displayCelulas(mineField)

# on :mouse_down do |event|
#     if !display.getEnd()
#         case event.button
#         when :left
#             display.mousePressionadoEsquerdo(mineField, event.x, event.y)
#         when :right
#             display.mousePressionadoDireito(mineField, event.x, event.y)
#         end
#     end 
# end

# update do
#   puts mineField.getCelulasDescobertas()
#   display.win(mineField)
# end

# Window.show 