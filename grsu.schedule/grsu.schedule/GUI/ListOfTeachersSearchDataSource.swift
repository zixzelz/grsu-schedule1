//
//  ListOfTeachersSearchDataSource.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/16/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class ListOfTeachersSearchDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate {

    @IBOutlet var searchDisplayController: UISearchDisplayController!

    var items: [TeacherInfoEntity]?
    var searcheArray: [TeacherInfoEntity]?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searcheArray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: UITableViewCell?

        cell = tableView.dequeueReusableCell(withIdentifier: "TeacherSearchCellIdentifier")

        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "TeacherSearchCellIdentifier")
            cell?.accessoryType = .detailDisclosureButton

        }
        cell?.textLabel?.text = searcheArray![indexPath.row].title

        return cell!
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        searchDisplayController.searchContentsController.performSegue(withIdentifier: "TeacherInfoIdentifier", sender: tableView.cellForRow(at: indexPath))
    }

    // MARK: - UISearchDisplayDelegate

    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearch searchString: String?) -> Bool {

        // TODO: bug
        let filtredArr = items?.filter { $0.title?.range(of: searchString!, options: .caseInsensitive, range: nil, locale: nil) != nil }

        searcheArray = filtredArr

        return true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchDisplayController.searchContentsController.performSegue(withIdentifier: "SchedulePageIdentifier", sender: tableView.cellForRow(at: indexPath))
    }

}
