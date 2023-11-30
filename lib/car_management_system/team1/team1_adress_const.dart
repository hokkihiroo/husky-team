final LOTARY ='local/q0LRMbznxA2yPca1DKNw/team1/1ACUzVo3Quod24RLILGr/rotary';

final OUTSIDE ='local/q0LRMbznxA2yPca1DKNw/team1/1ACUzVo3Quod24RLILGr/outside';

final MAIN ='local/q0LRMbznxA2yPca1DKNw/team1/1ACUzVo3Quod24RLILGr/150';

final MOON ='local/q0LRMbznxA2yPca1DKNw/team1/1ACUzVo3Quod24RLILGr/moon';

final SINSA ='local/q0LRMbznxA2yPca1DKNw/team1/1ACUzVo3Quod24RLILGr/sinsa';



String CheckLocation(int location){
  if(location ==0){
    return LOTARY;
  }else if (location ==1){
    return OUTSIDE;
  }else if(location==2){
    return MAIN;
  }else if(location==3){
    return MOON;
  }else if(location==4){
    return SINSA;
  }
  return '';
}