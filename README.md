# 환율 계산

- 예시와 같이 송금국가는 미국(USD), 수취국가는 한국(KRW), 일본(JPY), 필리핀(PHP) 입니다.
- 모든 환율 정보는 Alamofire 라이브러리를 사용해서 https://currencylayer.com/ 에서 가져옵니다.
- 환율은 수취국가를 변경할 때마다 등록한 API키를 통해서 가져오게 됩니다. 이때, 조회시간도 현재 시간이 됩니다.
- 송금금액은 0~10,000 USD까지만 입력이 가능하고 그렇지 않으면 Alert 기능을 사용해 메시지를 보여줍니다.
- 수취금액의 단위는 수취국가를 변경할 때 변하고 송금금액을 입력할 때마다 수취금액이 계산되어 나타납니다.
- 환율과 수취금액은 소수점 2자리 까지 나타내고 3자리마다 콤마를 찍어줍니다.
- 수취국가 picker view와 숫자 키패드는 화면터치하면 사라집니다.
- Unit Test는 아직 지식이 부족해서 구현하지 못했습니다.

---
구동 예시는 아래와 같습니다. (왼쪽 : 아이폰12, 오른쪽 : 아이패드 프로 4세대)  

<img src = "https://user-images.githubusercontent.com/41609708/104838925-473dbd80-5901-11eb-925c-fc34eaada755.png" width="30%">  <img src = "https://user-images.githubusercontent.com/41609708/104838520-b82fa600-58fe-11eb-813b-1eb2d45de584.png" width="50%">
