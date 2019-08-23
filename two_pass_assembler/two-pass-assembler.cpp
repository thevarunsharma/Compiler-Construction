#include<iostream>
#include <fstream>
#include<streambuf>
#include<iomanip>
#include<unordered_map>
#include<string>
#include<regex>

using namespace std;

string int_to_hex(int i){
    std::stringstream stream;
    stream << std::setfill('0') << std::setw(4) << std::hex << i;
    return stream.str();
}

class TwoPassAssembler{
public:
    unordered_map<string, string> opcodes;
    string filename;
    int start_addr, end_addr;
    unordered_map<int, string> table;
    unordered_map<string, int> labels;

    TwoPassAssembler(string fname, int saddr) : 
    filename(fname), start_addr(saddr), end_addr(-1) {
        opcodes["MVI_A"] = "3E";
        opcodes["LDA"] = "3A";
        opcodes["STA"] = "32";
        opcodes["MOV_B_A"] = "47";
        opcodes["MVI_A"] = "3E";
        opcodes["ADD_B"] = "80";
        opcodes["ADI"] = "C6";
    }
    void symbol_parse(void);
    unordered_map<int, string> to_machine_code(void);
};

void TwoPassAssembler::symbol_parse(void){
    std::ifstream prog(filename);
    std::string lines;
    prog.seekg(0, std::ios::end);
    lines.reserve(prog.tellg());
    prog.seekg(0, std::ios::beg);
    lines.assign((std::istreambuf_iterator<char>(prog)),
               std::istreambuf_iterator<char>());
    prog.close();

    regex wordreg("([0-9a-zA-Z_]+)");
    regex labelreg("([0-9a-zA-Z_]+)\\s*:");
    int addr = start_addr;
    string prev = "";
    auto word = sregex_iterator(lines.begin(), lines.end(), wordreg);
    auto label = sregex_iterator(lines.begin(), lines.end(), labelreg);
    auto word_end = sregex_iterator(), label_end = sregex_iterator();
    vector<string> Addr_tokens {"STA", "LDA", "JMP", "CALL"};
    smatch extract;
    string slabel = "";
    if (label != label_end){
        slabel = label->str();
        regex_search(slabel, extract, labelreg);
        slabel = extract[1];
    }
    for(sregex_iterator wd = word; wd != word_end; wd++){
        string Word = wd->str();
        if (labels.find(Word) != labels.end()){
            Word = int_to_hex(labels[Word]);
        }
        if (find(Addr_tokens.begin(), Addr_tokens.end(), prev) != Addr_tokens.end()
            && regex_match(Word, regex("([0-9a-fA-F]{4})"))){
            string byte1 = Word.substr(2, 2), byte2 = Word.substr(0, 2);
            table[addr++] = byte1;
            table[addr++] = byte2;
        }else if (label != label_end && slabel == Word){
            labels[Word] = addr;
            label++;
            if (label != label_end){
                slabel = label->str();
                regex_search(slabel, extract, labelreg);
                slabel = extract[1];
            }
        }else {
            table[addr++] = Word;
        }
        prev = Word;
    }
    end_addr = addr;
}

unordered_map<int, string> TwoPassAssembler::to_machine_code(){
    unordered_map<int, string> machine_code;
    for(int addr = start_addr; addr < end_addr; addr++){
        string tok = table[addr];
        if (opcodes.find(tok) != opcodes.end())
            tok = opcodes[tok];
        machine_code[addr] = tok;
    }
    return machine_code;
}

int main(int argc, char *argv[]){
    string filename(argv[1]);
    string saddr(argv[2]);
    saddr = "0x" + saddr;
    int start_addr = stoul(saddr, nullptr, 16);
    
    TwoPassAssembler assembler(filename, start_addr);
    assembler.symbol_parse();
    unordered_map<int, string> machine_code;
    machine_code = assembler.to_machine_code();

    cout << "Address\t\tPnemonic\tMachine Code" << endl;
    for (int addr=assembler.start_addr; addr<assembler.end_addr; addr++){
        cout << hex << "0x" << addr << "\t\t";
        cout << assembler.table[addr] << "\t\t" << machine_code[addr] << endl;
    }
    return 0;
}