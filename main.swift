import Foundation


//функция для обозначения вывода правил игры
func printGameRules() -> Void{
    print("Начинается игра!")
    sleep(1)
    print()
    print("Символ '↓' означает начало лестницы")
    print("Символ '#' означает конец лестницы")
    print("Символ '↑' означает голову змеи")
    print("Символ '0' означает хвост змеи")
    print()
    sleep(1)
}

//функция для вывода игрового поля на экран
func printGameField(_ gameField: [[String]]) -> Void{
    for i in 0...size-1{
        for j in 0...size-1{
            print("\(gameField[i][j])", terminator: " ")
        }
        print();
    }
}

//функция для добавления змей в игровое поле
func addSnakes(_ gameField: inout [[String]], _ size: Int, _ snakesCount: Int) -> [String: [Int]]{
    //словарь для хранения координат змеи
    //ключ - индексы элемента игрового поля, где голова змеи
    //значение - индексы элемента игрового поля, где хвост змеи
    var snakePositions: [String: [Int]] = [:]
    
    for _ in 0..<snakesCount {
        var headCoordinates: [Int] = []
        var tailCoordinates: [Int] = []
        
        //генерируем элемент головы змеи
        while(true){
            let random1X = Int.random(in: 1..<size)
            let random1Y = Int.random(in: 0..<size)
            
            //если элемент свободен
            if gameField[random1X][random1Y] == "*" {
                gameField[random1X][random1Y] = "↑" //ставим голову змеи
                headCoordinates = [random1X, random1Y]
                break
            }
            //print("Змея, голова", random1X, random1Y)
        }
        
        //генерируем элемент хвоста змеи
        while(true){
            let random2X = Int.random(in: 0..<size)
            let random2Y = Int.random(in: 0..<size)
            
            //если кордината по X меньше, чем кордината по X у головы змеи и элемент свободен
            if random2X < headCoordinates[0] && gameField[random2X][random2Y] == "*" {
                gameField[random2X][random2Y] = "0" //ставим хвост змеи
                tailCoordinates = [random2X, random2Y]
                break
            }
            
            //print("Змея, хвост", random2X, random2Y)
        }
        
        //добавляем координаты головы и хвоста змеи в словарь
        let headKey = "\(headCoordinates[0]),\(headCoordinates[1])"
        snakePositions[headKey] = tailCoordinates
    }
    
    return snakePositions
}

//функция для добавления лестниц в игровое поле
func addStairs(_ gameField: inout [[String]], _ size: Int, _ strairsCount: Int) -> [String: [Int]]{
    //словарь для хранения координат лестницы
    //ключ - индексы элемента игрового поля, где начало лестницы
    //значение - индексы элемента игрового поля, где конец лестницы
    var stairsPositions: [String: [Int]] = [:]
    
    for _ in 0..<stairsCount {
        var beginingCoordinates: [Int] = []
        var endingCoordinates: [Int] = []
        
        //генерируем элемент начала лестницы
        while(true){
            let random1X = Int.random(in: 0..<size-1)
            let random1Y = Int.random(in: 0..<size)
            
            //если элемент свободен
            if gameField[random1X][random1Y] == "*"  {
                gameField[random1X][random1Y] = "↓" //ставим начало лестницы
                beginingCoordinates = [random1X, random1Y]
                break
            }
            
            //print("Лестница, начало", random1X, random1Y)
        }
        
        //генерируем элемент конца лестницы
        while(true){
            let random2X = Int.random(in: 0..<size)
            let random2Y = Int.random(in: 0..<size)
            
            //если кордината по Y больше, чем кордината по Y у начала лестницы и элемент свободен
            if random2X > beginingCoordinates[0] && gameField[random2X][random2Y] == "*" {
                gameField[random2X][random2Y] = "#" //ставим конец лестницы
                endingCoordinates = [random2X, random2Y]
                break
            }
            
            //print("Лестница, конец", random2X, random2Y)
        }
        
        //добавляем координаты начала и конца лестницы в словарь
        let headKey = "\(beginingCoordinates[0]),\(beginingCoordinates[1])"
        stairsPositions[headKey] = endingCoordinates
    }
    
    return stairsPositions
}

//функция начала игры
func startGame(_ gameField: inout [[String]], _ size: Int, _ playersCount: Int, _ snakePositions: inout [String: [Int]], _ stairsPositions: inout[String: [Int]]) -> Void {
    
    var playersPositions: [[Int]] = [
        [0, 0],
        [0, 0],
        [0, 0],
        [0, 0],
        [0, 0],
        [0, 0]
    ]
    printGameRules()
    while(true){
        printGameField(gameField)
        var flag = false;
        for player in 0..<playersCount{
            print("Ходит игрок №\(player+1)")
            print("Позиция игрока №\(player+1) - \(playersPositions[player])")
            print()
            sleep(1)
            print("Бросается кубик...")
            print()
            sleep(1)
            let number = Int.random(in: 1...6)
            print("Выпало число: \(number)")
            let x = playersPositions[player][0] + Int((playersPositions[player][1] + number) / size)
            let y = (playersPositions[player][1] + number) % size
            playersPositions[player] = [x, y]
            moveBySnake(&playersPositions, player, &snakePositions)
            moveByStair(&playersPositions, player, &stairsPositions)
            print("Позиция игрока №\(player+1) - \(playersPositions[player])")
            if x >= size || (y == size-1 && x == size-1){
                print("Победил игрок №\(player+1)")
                flag = true
                break
            }
            print("Нажмите Enter, чтобы продолжить")
            readLine()
        }
        if flag{
            break
        }
    }
}

//функция для перемещения игрока по змее
func moveBySnake(_ playersPositions: inout [[Int]], _ player: Int, _ snakePositions: inout [String: [Int]]) -> Void{
    for key in snakePositions.keys{
        if key == "\(playersPositions[player][0]),\(playersPositions[player][1])"{
            print("Вы попали на голову змеи на позиции \(key)")
            sleep(1)
            playersPositions[player] = snakePositions[key]!
        }
    }
}

//функция для перемещения игрока по лестнице
func moveByStair(_ playersPositions: inout [[Int]], _ player: Int, _ stairsPositions: inout [String: [Int]]) -> Void{
    for key in stairsPositions.keys{
        if key == "\(playersPositions[player][0]),\(playersPositions[player][1])"{
            print("Вы попали на начало лестницы на позиции [\(key)]")
            sleep(1)
            playersPositions[player] = stairsPositions[key]!
        }
    }
}

print("Введите кол-во пользователей: ", terminator: "")
let playersCount = Int(readLine()!)!

print("Введите размер квадратного игрового поля в клетках: ", terminator: "")
let size = Int(readLine()!)!

print("Введите кол-во лестниц: ", terminator: "")
let stairsCount = Int(readLine()!)!

print("Введите кол-во змей: ", terminator: "")
let snakesCount = Int(readLine()!)!

var gameField = Array(repeating: Array(repeating: "*", count: size), count: size)

//добавляем змей и лестницы
var snakePositions = addSnakes(&gameField, size, snakesCount)
var stairsPositions = addStairs(&gameField, size, stairsCount)

startGame(&gameField, size, playersCount, &snakePositions, &stairsPositions)




