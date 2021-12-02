require 'ruby2d'
require 'ostruct'
require_relative '/Minesweeper/Minesweeper/Game/Entidades/minefield.rb'
require_relative '/Minesweeper/Minesweeper/Game/IA/IA.rb' 

class Display

    attr_accessor :altura, :largura, :tamanho, :background, :positionBotaoVoltar, :end
    
    def initialize(altura, largura, tamanho)
        @altura = altura
        @largura = largura
        @tamanho = tamanho
        @positionBotaoVoltar = [275, 325, 3, 23]
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
                boom = Music.new('/Minesweeper/Minesweeper/Dados/explosionSound.mp3')
                boom.volume = 50
                boom.play
                sleep(0.1)                
                loose(mineField)
            end
        end
    end

    def printarCorPreta(mineField, row, column)
        s = Square.new(
            x: mineField.getGrid[row][column].getX(), 
            y: mineField.getGrid[row][column].getY(),
            size: mineField.getGrid[row][column].getSize(),
            color: 'black',
            z: 0
        )
    end
    
    
    def printarCorVermelha(mineField, row, column)
        Image.new(
            '/Minesweeper/Minesweeper/Dados/flag.png',
            x: mineField.getGrid[row][column].getX(), 
            y: mineField.getGrid[row][column].getY(),
            width: mineField.getGrid[row][column].getSize(), height: mineField.getGrid[row][column].getSize(),
            color: [1.0, 1.0, 1.0, 1.0],
            rotate: 0,
            z: 0
        )
    end

    def printarCorAzul(mineField, row, column)
        Square.new(
            x: mineField.getGrid[row][column].getX(), 
            y: mineField.getGrid[row][column].getY(),
            size: mineField.getGrid[row][column].getSize(),
            color: 'blue',
            z: 0 
        )
    end
    
    def printarNumeroBombas(mineField, row, column)
        Text.new(
            String(mineField.getGrid[row][column].getQuantidadeMinas()),
            x: (mineField.getGrid[row][column].getSize()*0.2) + mineField.getGrid[row][column].getX(), 
            y: mineField.getGrid[row][column].getY(),
            style: 'bold',
            size: (mineField.getGrid[row][column].getSize()*0.9),
            color: 'black',
            rotate: 0,
            z: 0
        )
    end
    
    def printarBomba(mineField, row, column)
        Square.new(
            x: mineField.getGrid[row][column].getX(), 
            y: mineField.getGrid[row][column].getY(),
            size: mineField.getGrid[row][column].getSize(),
            color: 'green',
            z: 0 
        )
        bomb = Sprite.new(
            '/Minesweeper/Minesweeper/Dados/bomoSpriteNew.png',
            x: mineField.getGrid[row][column].getX(), 
            y: mineField.getGrid[row][column].getY(),
            width: mineField.getGrid[row][column].getSize(),
            height: mineField.getGrid[row][column].getSize(),
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

    def mousePressionadoEsquerdoNoBotaoVoltar(event_x , event_y)
        if (event_x > self.positionBotaoVoltar[0]  and event_x < self.positionBotaoVoltar[1] and 
            event_y > self.positionBotaoVoltar[2]  and event_y < self.positionBotaoVoltar[3])
            self.end = true
            return true
        end
        return false
    end

    # Caso especial celula com nenhuma bomba ao redor, usando BFS (Breadth-First Search)
    def especialCase(cell, mineField)
        
        indexI = cell.getI()
        indexJ = cell.getJ()

        pair = OpenStruct.new
        visitado = Array.new(self.tamanho){Array.new(self.tamanho)}
        pairVector = Array[]
        
        list = Array[]
        range = self.tamanho - 1

        for i in 0..range do
            for j in 0..range do
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
            x: 190, y: 200,
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
    def win(mineField, tamanho, iaVez, iaHabilitar)
        valor = tamanho * tamanho
        if !iaHabilitar
            if mineField.getCelulasDescobertas() == valor and !iaVez
                Text.new(
                    'You Win!',
                    x: 190, y: 200,
                    style: 'bold',
                    size: 53,
                    color: 'green',
                    rotate: 0,
                    z: 0
                )
                self.end = true
            elsif mineField.getCelulasDescobertas() == valor and iaVez
                loose(mineField)
            end
        else
            if mineField.getCelulasDescobertas() == valor and iaVez
                Text.new(
                    'You Win!',
                    x: 190, y: 200,
                    style: 'bold',
                    size: 53,
                    color: 'green',
                    rotate: 0,
                    z: 0
                )
                self.end = true
            elsif mineField.getCelulasDescobertas() == valor and !iaVez
                loose(mineField)
            end
        end
    end
    
    # Printa os limites do campo
    def lineDisplay(tamanho)
        if tamanho == 8
            lineTamanho8()
        elsif tamanho == 10
            lineTamanho10()
        elsif tamanho == 16 
            lineTamanho16()
        elsif tamanho == 20
            lineTamanho20()
        end 
    end

    def lineTamanho8()
        Line.new(
            x1: 95, y1:32,
            x2: 513, y2: 32,
            width: 5,
            color: 'black',
            z: 1
        )
        Line.new(
            x1: 98, y1: 30,
            x2: 98, y2: 444,
            width: 5,
            color: 'black',
            z: 1
        )
        Line.new(
            x1: 513, y1: 29,
            x2: 513, y2: 444,
            width: 5,
            color: 'black',
            z: 1
        )
        Line.new(
            x1: 95, y1: 444,
            x2: 515, y2: 444,
            width: 5,
            color: 'black',
            z: 1
        )
    end

    def lineTamanho10()
        Line.new(
            x1: 95, y1:32,
            x2: 518, y2: 32,
            width: 5,
            color: 'black',
            z: 1
        )
        Line.new(
            x1: 98, y1: 30,
            x2: 98, y2: 448,
            width: 5,
            color: 'black',
            z: 1
        )
        Line.new(
            x1: 518, y1: 29,
            x2: 518, y2: 448,
            width: 5,
            color: 'black',
            z: 1
        )
        Line.new(
            x1: 95, y1: 448,
            x2: 520, y2: 448,
            width: 5,
            color: 'black',
            z: 1
        )
    end

    def lineTamanho16()
        Line.new(
            x1: 95, y1:30,
            x2: 530, y2: 30,
            width: 5,
            color: 'black',
            z: 1
        )
        Line.new(
            x1: 98, y1: 30,
            x2: 98, y2: 460,
            width: 5,
            color: 'black',
            z: 1
        )
        Line.new(
            x1: 530, y1: 27,
            x2: 530, y2: 460,
            width: 5,
            color: 'black',
            z: 1
        )
        Line.new(
            x1: 95, y1: 460,
            x2: 532, y2: 460,
            width: 5,
            color: 'black',
            z: 1
        )
    end
    
    def lineTamanho20()
        Line.new(
            x1: 95, y1:30,
            x2: 538, y2: 30,
            width: 5,
            color: 'black',
            z: 1
        )
        Line.new(
            x1: 98, y1: 30,
            x2: 98, y2: 468,
            width: 5,
            color: 'black',
            z: 1
        )
        Line.new(
            x1: 538, y1: 27,
            x2: 538, y2: 468,
            width: 5,
            color: 'black',
            z: 1
        )
        Line.new(
            x1: 95, y1: 468,
            x2: 540, y2: 468,
            width: 5,
            color: 'black',
            z: 1
        )
    end

    def botaoVoltar()
        Rectangle.new(
            x: 275, 
            y: 3,
            width: 50,
            height: 20,
            color: 'red',
            z: 0
        )

        Text.new(
            'Voltar',
            x: 284, y: 5,
            style: 'bold',
            size: 10,
            color: 'blue',
            rotate: 0,
            z: 0
        )
    end

    def fieldBackground(tamanho)
        if tamanho == 8 
            Square.new(
                x: 100, 
                y: 30,
                size: 411,
                color: 'red',
                z: 0 
            )
        elsif tamanho == 10 
            Square.new(
                x: 100, 
                y: 30,
                size: 416,
                color: 'red',
                z: 0 
            )
        elsif tamanho == 16
            Square.new(
                x: 100, 
                y: 30,
                size: 427,
                color: 'red',
                z: 0 
            )
        elsif tamanho == 20
            Square.new(
                x: 100, 
                y: 30,
                size: 437,
                color: 'red',
                z: 0 
            )
        end
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

    def getBackGround()
        return self.background
    end
    
    def getTamanho()
        return self.tamanho
    end
    
end