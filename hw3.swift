
import Foundation

//MARK: Extensions

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}

//MARK: Utils

struct Utils {
    static let alphabet : [String : Int] = [ "A" : 0, "B" : 1, "C" : 2, "D" : 3, "E" : 4, "F" : 5, "G" : 6, "H" : 7, "I" : 8, "J" : 9, "K" : 10, "L" : 11, "M" : 12, "N" : 13, "O" : 14, "P" : 15, "Q" : 16, "R" : 17, "S" : 18, "T" : 19, "U" : 20, "V" : 21, "W" : 22, "X" : 23, "Y" : 24, "Z" : 25 ]
}

//MARK: Trie class

class Trie{
    let root: TrieNode
    let row: Int
    let column: Int
    let boggle: [[String]]
    var results: [String]
    
    init(m: Int, n: Int, boggle letters: [[String]]){
        root = TrieNode()
        boggle = letters
        row = m
        column = n
        results = []
    }
    
    class TrieNode{
        var children : [TrieNode?]
        var isEndOfAWord : Bool
        init(){
            children = Array(repeating: nil, count: 26)
            isEndOfAWord = false
        }
        
        func addChild(character : String){
            if children[Utils.alphabet[character]!] == nil{
               children[Utils.alphabet[character]!] = TrieNode()
            }
        }
    }

    func addWordToTrie(word: String){
        let capWord = word.uppercased()
        var node: TrieNode = self.root
        for char in capWord{
            let index : Int = Utils.alphabet[String(char)]!
            if let unwrappedNode = node.children[index]{
                node = unwrappedNode
            }else{
                node.children[index] = TrieNode()
                node = node.children[index]!
            }
        }
        node.isEndOfAWord = true
    }
    
    func searchWord(node: TrieNode, i: Int, j: Int, visited: [[Bool]], str: String){
        
        if node.isEndOfAWord{
            var flag : Bool = false
            for result in results{
                if result == str{
                    flag = true
                    break
                }
            }
            if(!flag){
                results.append(str)
            }
        }
        next:
        if (canBeNext(i: i, j: j, visited: visited)){
            var newVisited = visited
            newVisited[i][j] = true
            
            for childIndex in 0..<26{
                
                if let child = node.children[childIndex]{
                    
                    let checkStr: String = Utils.alphabet.someKey(forValue: childIndex)!
                    
                    if checkNeighbor(i: i+1, j: j+1, visited: visited, str: checkStr){
                        searchWord(node: child, i: i+1, j: j+1, visited: newVisited, str: str + checkStr)
                    }
                    
                    if checkNeighbor(i: i, j: j+1, visited: visited, str: checkStr){
                        searchWord(node: child, i: i, j: j+1, visited: newVisited, str: str + checkStr)
                    }
                    
                    if checkNeighbor(i: i+1, j: j, visited: visited, str: checkStr){
                        searchWord(node: child, i: i+1, j: j, visited: newVisited, str: str + checkStr)
                    }
                    
                    if checkNeighbor(i: i+1, j: j-1, visited: visited, str: checkStr){
                        searchWord(node: child, i: i+1, j: j-1, visited: newVisited, str: str + checkStr)
                    }
                    
                    if checkNeighbor(i: i-1, j: j+1, visited: visited, str: checkStr){
                        searchWord(node: child, i: i-1, j: j+1, visited: newVisited, str: str + checkStr)
                    }
                    
                    if checkNeighbor(i: i-1, j: j-1, visited: visited, str: checkStr){
                        searchWord(node: child, i: i-1, j: j-1, visited: newVisited, str: str + checkStr)
                    }
                    
                    if checkNeighbor(i: i-1, j: j, visited: visited, str: checkStr){
                        searchWord(node: child, i: i-1, j: j, visited: newVisited, str: str + checkStr)
                    }
                    
                    if checkNeighbor(i: i, j: j-1, visited: visited, str: checkStr){
                        searchWord(node: child, i: i, j: j-1, visited: newVisited, str: str + checkStr)
                    }
                    
                }
                
            }
            
        }
    }
    
    func checkNeighbor(i: Int, j: Int, visited: [[Bool]], str: String) -> Bool{
        if canBeNext(i: i, j: j, visited: visited){
            if boggle[i][j] == str{
                return true
            }
        }
        return false
    }

    func canBeNext(i: Int, j: Int, visited: [[Bool]]) -> Bool{
        if i >= row || j >= column || i < 0 || j < 0{
            return false
        }
        if visited[i][j]{
            return false
        }
        return true
    }
    
    func searchWords(){
        var charIndex : Int
        
        for i in 0..<row{
            for j in 0..<column{
                charIndex = Utils.alphabet[boggle[i][j]]!
                if let child = root.children[charIndex]{
                    let visited : [[Bool]] = Array(repeating: Array(repeating: false, count: column), count: row)
                    searchWord(node: child, i: i, j: j, visited: visited, str: boggle[i][j])
                }
            }
        }
        for result in results{
            print(result)
        }
    }
}

//MARK: Main function

func main(){

    let stringSplitter = { (str: String) in str.components(separatedBy: " ") }
    
    //MARK: Reading inputs
    
    let dictionary = stringSplitter(readLine()!)
    
    let dimensions = stringSplitter(readLine()!)
    let (m, n) = (Int(dimensions[0])!, Int(dimensions[1])!)

    var boggle : [[String]] = []
    for _ in 0..<m {
        boggle += [stringSplitter(readLine()!)]
    }
    
    boggle = boggle.map(){ (str: [String]) in str.map(){ (str: String) in str.uppercased() } }
    
    let trie : Trie = Trie(m: m, n: n, boggle: boggle)
    for word in dictionary{
        trie.addWordToTrie(word: word)
    }
    
    trie.searchWords()
}

main()
