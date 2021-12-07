//
//  StopwatchController.swift
//  CL2_Stopwatch
//
//  Created by 이건준 on 2021/12/06.
//

import UIKit

private let reuseIdentifier = "cell"
class StopwatchController:UIViewController{
    //MARK: Variables
    var arrayForLap = [String]()
    let mainTimer:Stopwatch = Stopwatch()
    let subTimer:Stopwatch = Stopwatch()
    var isPlaying:Bool = false
    
    //MARK: UIComponents
    private lazy var tbView:UITableView={ // 시간을 기록하기위한 테이블 뷰
        let vw = UITableView()
        vw.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        vw.heightAnchor.constraint(equalToConstant: view.frame.height/2).isActive = true
        return vw
    }()
    
    private lazy var startStopButton:UIButton={ // Start, Stop 버튼
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("Start", for: UIControl.State.normal)
        btn.tintColor = .systemGreen
        btn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.layer.cornerRadius = 25
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(startStopTimer), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    private lazy var lapResetButton:UIButton={ // Lap, Reset 버튼
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("Reset", for: UIControl.State.normal)
        btn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.layer.cornerRadius = 25
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(lapResetTimer), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    private lazy var mainTimerLb:UILabel={
       let lb = UILabel()
        lb.text = "00:00:00"
        lb.font = UIFont.systemFont(ofSize: 50)
        return lb
    }()
    
    private lazy var subTimerLb:UILabel={
       let lb = UILabel()
        lb.text = "00:00:00"
        return lb
    }()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        self.tbView.dataSource = self
        self.tbView.register(TableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    //MARK: -Action
    @objc func startStopTimer(_ sender:UIButton){
        if !isPlaying{ //Start버튼을 눌렀을때 실행
            changeButton(startStopButton: sender, lapResetButton: lapResetButton, changeColor: .systemRed)
        
            mainTimer.timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: #selector(updateMainTimer), userInfo: nil, repeats: true)
            
            subTimer.timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: #selector(updateSubTimer), userInfo: nil, repeats: true)
                
                isPlaying = true
        }else if isPlaying{ //Stop버튼을 눌렀을때 실행
            changeButton(startStopButton: sender, lapResetButton: lapResetButton, changeColor: .systemGreen)
            
            stopTimer(stopwatch: mainTimer)
            stopTimer(stopwatch: subTimer)
            
            isPlaying = false
        }
        }
    
    @objc func lapResetTimer(){
        if !isPlaying{ //Reset버튼을 눌렀을때
            resetTimer(stopwatch: mainTimer)
            resetTimer(stopwatch: subTimer)
        }else if isPlaying{//Lap버튼을 눌렀을때
            guard let text = mainTimerLb.text else {return}
            lapTimer(labText: text)
        }
    }
    
    @objc func updateMainTimer(){
        updateTimer(stopwatch: mainTimer, label: mainTimerLb)
    }
    
    @objc func updateSubTimer(){
        updateTimer(stopwatch: subTimer, label: subTimerLb)
    }
    
    //MARK: -Configure
    func configure(){
        view.backgroundColor = .systemBackground
        
        view.addSubview(tbView)
        tbView.translatesAutoresizingMaskIntoConstraints = false
        tbView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tbView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
        view.addSubview(mainTimerLb)
        mainTimerLb.translatesAutoresizingMaskIntoConstraints = false
        mainTimerLb.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainTimerLb.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        
        view.addSubview(subTimerLb)
        subTimerLb.translatesAutoresizingMaskIntoConstraints = false
        subTimerLb.rightAnchor.constraint(equalTo: mainTimerLb.rightAnchor).isActive = true
        subTimerLb.bottomAnchor.constraint(equalTo: mainTimerLb.topAnchor).isActive = true
        
        view.addSubview(startStopButton)
        startStopButton.translatesAutoresizingMaskIntoConstraints = false
        startStopButton.leftAnchor.constraint(equalTo: mainTimerLb.leftAnchor).isActive = true
        startStopButton.topAnchor.constraint(equalTo: mainTimerLb.bottomAnchor, constant: 50).isActive = true
        
        view.addSubview(lapResetButton)
        lapResetButton.translatesAutoresizingMaskIntoConstraints = false
        lapResetButton.centerYAnchor.constraint(equalTo: startStopButton.centerYAnchor).isActive = true
        lapResetButton.rightAnchor.constraint(equalTo: mainTimerLb.rightAnchor).isActive = true
    }
    
    //MARK: -Helper
    func changeButton(startStopButton:UIButton, lapResetButton:UIButton, changeColor:UIColor){
        if startStopButton.titleLabel?.text == "Start"{
            startStopButton.setTitle("Stop", for: UIControl.State.normal)
            startStopButton.tintColor = changeColor
            
            lapResetButton.setTitle("Lap", for: UIControl.State.normal)
        }else if startStopButton.titleLabel?.text == "Stop"{
            startStopButton.setTitle("Start", for: UIControl.State.normal)
            startStopButton.tintColor = changeColor
            
            lapResetButton.setTitle("Reset", for: UIControl.State.normal)
        }
    }
    
    func updateTimer(stopwatch:Stopwatch, label:UILabel){ // Start버튼을 눌렀을때 타이머시간을 계속 변하게 도와주는 함수
        stopwatch.counter = stopwatch.counter + 0.035
        
        var minutes: String = "\((Int)(stopwatch.counter / 60))"
        if (Int)(stopwatch.counter / 60) < 10 {
          minutes = "0\((Int)(stopwatch.counter / 60))"
        }
        
        var seconds: String = String(format: "%.2f", (stopwatch.counter.truncatingRemainder(dividingBy: 60))) //Onenote참고
        if stopwatch.counter.truncatingRemainder(dividingBy: 60) < 10 {
          seconds = "0" + seconds
        }
        
        label.text = minutes + ":" + seconds
        
    }
    
    func resetTimer(stopwatch:Stopwatch){ // Reset버튼을 눌렀을때 타이머를 리셋시키는 함수
        stopwatch.timer.invalidate()
        stopwatch.counter = 0
        mainTimerLb.text = "00:00:00"
        subTimerLb.text = "00:00:00"
    }
    
    func stopTimer(stopwatch:Stopwatch){ // Stop버튼을 눌렀을때 타이머를 멈추는 함수
        stopwatch.timer.invalidate() // 받아온 타이머를 정지
    }
    
    func lapTimer(labText:String){ // Lap버튼을 눌렀을때 기록하는 함수
        arrayForLap.append(labText) //버튼을 눌렀을때 텍스트를 배열에 저장해준다
        subTimer.counter = 0 //subTimerLb에 0으로 초기화하는게 아닌 해당 타이머의 counter를 이용
//        print("subTimerLb.text = \(subTimerLb.text)") //확인 로깅용
        tbView.reloadData() //이후에 테이블뷰를 reload해줌으로써 새로고침효과부여
    }
}

//MARK: -Extension
extension StopwatchController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayForLap.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TableViewCell
        
        if let numLabel = cell.viewWithTag(1) as? UILabel{
            numLabel.text = "Lap \(arrayForLap.count - indexPath.row)"
        }
        
        if let lapLabel = cell.viewWithTag(2) as? UILabel{
            lapLabel.text = arrayForLap[indexPath.row]
        }
        return cell
    }
}
