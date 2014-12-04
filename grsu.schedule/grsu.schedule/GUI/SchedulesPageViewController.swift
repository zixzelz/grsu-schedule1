//
//  SchedulesPageViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/20/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class SchedulesPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    @IBInspectable var backgroundColor : UIColor = UIColor.whiteColor()
    
    @IBOutlet private var navigationTitle : UILabel!
    @IBOutlet private var pageControl : UIPageControl!
    
    var scheduleQuery : StudentScheduleQuery!
    var possibleWeeks : Array<GSWeekItem>!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.dataSource = self
        self.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = backgroundColor
        setupPageController()
    }
    
    func setupPageController() {
        let weeks = possibleWeeks.map { $0.startDate } as [NSDate]!

        pageControl.numberOfPages = possibleWeeks.count
        pageControl.currentPage = find(weeks, scheduleQuery.startWeekDate!)!
        updateNavigationTitle()
        
        let vc = weekScheduleController()
        self.setViewControllers([vc], direction: .Forward, animated: false, completion: nil)

    }
    
    func weekScheduleController(weekIndex : Int? = nil) -> WeekSchedulesViewController {
        let query = StudentScheduleQuery(q: scheduleQuery)
        if (weekIndex != nil) {
            query.startWeekDate = possibleWeeks[weekIndex!].startDate
            query.endWeekDate = possibleWeeks[weekIndex!].endDate
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("WeekSchedulesViewController") as WeekSchedulesViewController
        vc.scheduleQuery = query
        
        return vc
    }
    
    func updateNavigationTitle() {
        let index = pageControl.currentPage

        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.navigationTitle.alpha = 0.0
            self.navigationTitle.text = self.possibleWeeks[index].value
            self.navigationTitle.alpha = 1.0
        })
    }
    
    // pragma mark - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var vc : UIViewController?
        if (pageControl.currentPage > 0) {
            let index = pageControl.currentPage - 1
//            let week = possibleWeeks[index]
            
            vc = weekScheduleController(weekIndex: index)
        }
        return vc
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var vc : UIViewController?
        if (pageControl.currentPage < pageControl.numberOfPages - 1) {
            let index = pageControl.currentPage + 1
//            let week = possibleWeeks[index]
            
            vc = weekScheduleController(weekIndex: index)
        }
        return vc
    }
    
    // pragma mark - UIPageViewControllerDelegate
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        if (completed) {
            if let vc = pageViewController.viewControllers.last as? WeekSchedulesViewController {
                let index = indexOfViewController(vc)
                pageControl.currentPage = index
                updateNavigationTitle()
            }
        }
    }

    // pragma mark - Utils

    func indexOfViewController(vc: WeekSchedulesViewController) -> Int {
        let weeks = possibleWeeks.map { $0.startDate } as [NSDate]!
        return find(weeks, vc.scheduleQuery!.startWeekDate!)!
    }
    
}
