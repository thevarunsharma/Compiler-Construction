int i = 10;
do{
    if(i == 5){
        i = i-2;
        continue;
    }
    i = i-1;
}while(i != 0);

char c;
switch(i){
    case 1:
        c = '1';
        break;
    case 0:
        c = '0';
    default:
        i = i*2;
}