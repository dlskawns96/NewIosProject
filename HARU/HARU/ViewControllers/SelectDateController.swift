//
//  SelectDateController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2020/12/26.
//

import UIKit
import EventKit

class SelectDateController : UIViewController {
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var scheduleView: UIView!
    @IBOutlet weak var diaryView: UIView!
    @IBOutlet weak var addBtn: UIButton!
    
    let AD = UIApplication.shared.delegate as? AppDelegate
    
    var delegate: SelectDateControllerDelegate?
    var needCalendarReload: Bool = false
    var dateEvents: [EKEvent] = []
    
    var scheduleVC: ScheduleViewController? = ScheduleViewController()
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // ScheduleViewController 에 이벤트 정보 넘기기
        dateEvents = AD?.selectedDateEvents ?? []
        scheduleVC = (segue.destination as? ScheduleViewController) ?? nil
        
        if (scheduleVC != nil), segue.identifier == "ScheduleViewSegue" {
            scheduleVC?.dateEvents = dateEvents
            scheduleVC?.scheduleVCDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleView.isHidden = false
        diaryView.isHidden = true
        //composeBtn.isEnabled = false
        isModalInPresentation = true
        self.presentationController?.delegate = self
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segment.selectedSegmentIndex
        {
        case 0:
            scheduleView.isHidden = false
            diaryView.isHidden = true
        case 1:
            scheduleView.isHidden = true
            diaryView.isHidden = false
        default:
            break
        }
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        print("SelectDateController - needCalendarReload", needCalendarReload)
        if needCalendarReload {
            print("SelectDateController - needCalendarReload")
            self.delegate?.SelectDateControllerDidFinish(self)
        }
    }
    
    @IBAction func addBtn(_ sender: Any) {
        
        switch segment.selectedSegmentIndex
        {
        case 0:
            let storyboard: UIStoryboard = UIStoryboard(name: "AddEvent", bundle: nil)
            guard let controller = storyboard.instantiateViewController(identifier: "AddEventNavigationViewController") as UINavigationController? else { return }
            controller.modalPresentationStyle = .pageSheet
            guard let childView = controller.viewControllers.first as? AddEventViewController else {return}
            childView.addEventViewControllerDelegate = self
            self.present(controller, animated: true, completion: nil)
        case 1:
//            guard let controller = self.storyboard?.instantiateViewController(identifier: "AddDiaryController") else { return }
//
//            self.present(controller, animated: true, completion: nil)
            guard let controller = self.storyboard?.instantiateViewController(identifier: "AddDiaryController") else { return }
            self.present(controller, animated: true, completion: nil)
            AddDiaryController.editTarget = CoreDataManager.returnDiary(date: (AD?.selectedDate)!)
        default:
            break
        }
        
    }
}

// AddEventController 로 부터 일정 수정 사항이 있는지 받아오기 위한 delegate
extension SelectDateController: AddEventViewControllerDelegate {
    func newEventAdded(newEvents: [EKEvent]) {
        print("SelecDateController - newEventAdded()")
        needCalendarReload = true
        dateEvents.append(contentsOf: newEvents)
        delegate?.insertNewEventToTable(events: dateEvents)
    }
    
    func eventDeleted() {
        needCalendarReload = true
    }
    
    /// 구현: 이벤트 수정 사항이 없이 그냥 종료 됐을 때 처리
}

protocol SelectDateControllerDelegate: class {
    func SelectDateControllerDidCancel(_ selectDateController: SelectDateController)
    func SelectDateControllerDidFinish(_ selectDateController: SelectDateController)
    
    func insertNewEventToTable(events: [EKEvent])
}

extension SelectDateController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        dismiss(animated: true)
        print("SelectDateController - needCalendarReload", needCalendarReload)
        if needCalendarReload {
            print("SelectDateController - needCalendarReload")
            self.delegate?.SelectDateControllerDidFinish(self)
        }
    }
}

extension SelectDateController: ScheduleViewControllerDelegate {
    func eventModified() {
        needCalendarReload = true
    }
}
